import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/data/local/app_database.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/data/mappers/botella_empalme_sync_snapshot_mapper.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/data/mappers/caja_pon_ont_sync_snapshot_mapper.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/contracts/outside_plant_repository_contract.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/contracts/outside_plant_sync_contract.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/entities/botella_empalme.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/entities/caja_pon_ont.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/entities/outside_plant_sync_queue_item.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/enums/sync_operation_type.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/enums/sync_queue_status.dart';

class OutsidePlantSyncService {
  final PlantelExteriorDatabase db;
  final OutsidePlantRepositoryContract repository;
  final OutsidePlantSyncContract syncRepository;

  const OutsidePlantSyncService({
    required this.db,
    required this.repository,
    required this.syncRepository,
  });

  Future<void> saveCajaPonOnt(
    CajaPonOnt caja, {
    required bool isEditMode,
  }) async {
    final now = DateTime.now();
    final entity = caja.copyWith(
      syncStatus: caja.syncStatus,
      createdAt: caja.createdAt ?? now,
      updatedAt: now,
    );

    await db.transaction(() async {
      await repository.saveCajaPonOnt(entity);
      await syncRepository.enqueue(
        OutsidePlantSyncQueueItem(
          id: _queueId('caja_pon_ont', entity.id.value, now),
          entityType: 'caja_pon_ont',
          entityId: entity.id.value,
          operationType:
              isEditMode ? SyncOperationType.update : SyncOperationType.create,
          payloadJson: CajaPonOntSyncSnapshotMapper.toJson(entity),
          status: SyncQueueStatus.pending,
          attemptCount: 0,
          createdAt: now,
          updatedAt: now,
        ),
      );
    });
  }

  Future<void> saveBotellaEmpalme(
    BotellaEmpalme botella, {
    required bool isEditMode,
  }) async {
    final now = DateTime.now();
    final entity = botella.copyWith(
      syncStatus: botella.syncStatus,
      createdAt: botella.createdAt ?? now,
      updatedAt: now,
    );

    await db.transaction(() async {
      await repository.saveBotellaEmpalme(entity);
      await syncRepository.enqueue(
        OutsidePlantSyncQueueItem(
          id: _queueId('botella_empalme', entity.id.value, now),
          entityType: 'botella_empalme',
          entityId: entity.id.value,
          operationType:
              isEditMode ? SyncOperationType.update : SyncOperationType.create,
          payloadJson: BotellaEmpalmeSyncSnapshotMapper.toJson(entity),
          status: SyncQueueStatus.pending,
          attemptCount: 0,
          createdAt: now,
          updatedAt: now,
        ),
      );
    });
  }

  Future<void> deleteCajaPonOnt(CajaPonOnt caja) async {
    final now = DateTime.now();

    await db.transaction(() async {
      await syncRepository.enqueue(
        OutsidePlantSyncQueueItem(
          id: _queueId('caja_pon_ont', caja.id.value, now),
          entityType: 'caja_pon_ont',
          entityId: caja.id.value,
          operationType: SyncOperationType.delete,
          payloadJson: CajaPonOntSyncSnapshotMapper.deleteSnapshot(
            entityId: caja.id.value,
            codigo: caja.codigo,
          ),
          status: SyncQueueStatus.pending,
          attemptCount: 0,
          createdAt: now,
          updatedAt: now,
        ),
      );
      await repository.deleteCajaPonOnt(caja.id);
    });
  }

  Future<void> deleteBotellaEmpalme(BotellaEmpalme botella) async {
    final now = DateTime.now();

    await db.transaction(() async {
      await syncRepository.enqueue(
        OutsidePlantSyncQueueItem(
          id: _queueId('botella_empalme', botella.id.value, now),
          entityType: 'botella_empalme',
          entityId: botella.id.value,
          operationType: SyncOperationType.delete,
          payloadJson: BotellaEmpalmeSyncSnapshotMapper.deleteSnapshot(
            entityId: botella.id.value,
            codigo: botella.codigo,
          ),
          status: SyncQueueStatus.pending,
          attemptCount: 0,
          createdAt: now,
          updatedAt: now,
        ),
      );
      await repository.deleteBotellaEmpalme(botella.id);
    });
  }

  String _queueId(String entityType, String entityId, DateTime now) {
    return '$entityType-$entityId-${now.microsecondsSinceEpoch}';
  }
}
