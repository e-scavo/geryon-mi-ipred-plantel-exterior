import 'package:drift/drift.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/data/local/app_database.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/contracts/outside_plant_sync_contract.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/entities/outside_plant_sync_queue_item.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/enums/sync_operation_type.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/enums/sync_queue_status.dart';

class DriftOutsidePlantSyncRepository implements OutsidePlantSyncContract {
  final PlantelExteriorDatabase db;

  const DriftOutsidePlantSyncRepository(this.db);

  @override
  Future<void> enqueue(OutsidePlantSyncQueueItem item) async {
    await db.customInsert(
      '''
      INSERT INTO outside_plant_sync_queue (
        id,
        entity_type,
        entity_id,
        operation_type,
        payload_json,
        status,
        attempt_count,
        last_error,
        created_at,
        updated_at
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
      ''',
      variables: [
        Variable<String>(item.id),
        Variable<String>(item.entityType),
        Variable<String>(item.entityId),
        Variable<String>(_operationTypeToDb(item.operationType)),
        Variable<String>(item.payloadJson),
        Variable<String>(_queueStatusToDb(item.status)),
        Variable<int>(item.attemptCount),
        Variable<String>(item.lastError ?? ''),
        Variable<String>(item.createdAt.toIso8601String()),
        Variable<String>(item.updatedAt.toIso8601String()),
      ],
      updates: {},
    );
  }

  @override
  Future<List<OutsidePlantSyncQueueItem>> getPendingItems() async {
    final rows = await db.customSelect(
      '''
      SELECT
        id,
        entity_type,
        entity_id,
        operation_type,
        payload_json,
        status,
        attempt_count,
        last_error,
        created_at,
        updated_at
      FROM outside_plant_sync_queue
      WHERE status IN ('pending', 'error')
      ORDER BY created_at ASC
      ''',
      readsFrom: {},
    ).get();

    return rows.map(_mapRow).toList();
  }

  @override
  Future<int> getPendingItemsCount() async {
    final row = await db.customSelect(
      '''
      SELECT COUNT(*) AS total
      FROM outside_plant_sync_queue
      WHERE status IN ('pending', 'error')
      ''',
      readsFrom: {},
    ).getSingle();

    return row.read<int>('total');
  }

  @override
  Future<void> markProcessing(String id) async {
    await db.customUpdate(
      '''
      UPDATE outside_plant_sync_queue
      SET status = ?, updated_at = ?
      WHERE id = ?
      ''',
      variables: [
        Variable<String>('processing'),
        Variable<String>(DateTime.now().toIso8601String()),
        Variable<String>(id),
      ],
      updates: {},
    );
  }

  @override
  Future<void> markError(String id, String errorMessage) async {
    await db.customUpdate(
      '''
      UPDATE outside_plant_sync_queue
      SET status = ?,
          attempt_count = attempt_count + 1,
          last_error = ?,
          updated_at = ?
      WHERE id = ?
      ''',
      variables: [
        Variable<String>('error'),
        Variable<String>(errorMessage),
        Variable<String>(DateTime.now().toIso8601String()),
        Variable<String>(id),
      ],
      updates: {},
    );
  }

  @override
  Future<void> remove(String id) async {
    await db.customUpdate(
      'DELETE FROM outside_plant_sync_queue WHERE id = ?',
      variables: [Variable<String>(id)],
      updates: {},
    );
  }

  OutsidePlantSyncQueueItem _mapRow(QueryRow row) {
    final lastErrorValue = row.read<String>('last_error');

    return OutsidePlantSyncQueueItem(
      id: row.read<String>('id'),
      entityType: row.read<String>('entity_type'),
      entityId: row.read<String>('entity_id'),
      operationType: _operationTypeFromDb(row.read<String>('operation_type')),
      payloadJson: row.read<String>('payload_json'),
      status: _queueStatusFromDb(row.read<String>('status')),
      attemptCount: row.read<int>('attempt_count'),
      lastError: lastErrorValue.isEmpty ? null : lastErrorValue,
      createdAt: DateTime.parse(row.read<String>('created_at')),
      updatedAt: DateTime.parse(row.read<String>('updated_at')),
    );
  }

  SyncOperationType _operationTypeFromDb(String raw) {
    switch (raw) {
      case 'create':
        return SyncOperationType.create;
      case 'update':
        return SyncOperationType.update;
      case 'delete':
        return SyncOperationType.delete;
      default:
        return SyncOperationType.update;
    }
  }

  String _operationTypeToDb(SyncOperationType type) {
    switch (type) {
      case SyncOperationType.create:
        return 'create';
      case SyncOperationType.update:
        return 'update';
      case SyncOperationType.delete:
        return 'delete';
    }
  }

  SyncQueueStatus _queueStatusFromDb(String raw) {
    switch (raw) {
      case 'pending':
        return SyncQueueStatus.pending;
      case 'processing':
        return SyncQueueStatus.processing;
      case 'error':
        return SyncQueueStatus.error;
      default:
        return SyncQueueStatus.pending;
    }
  }

  String _queueStatusToDb(SyncQueueStatus status) {
    switch (status) {
      case SyncQueueStatus.pending:
        return 'pending';
      case SyncQueueStatus.processing:
        return 'processing';
      case SyncQueueStatus.error:
        return 'error';
    }
  }
}
