import 'package:drift/drift.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/entities/outside_plant_relationship.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/enums/sync_status.dart';

class OutsidePlantRelationshipMapper {
  static const allowedEntityTypes = <String>{
    'caja_pon_ont',
    'botella_empalme',
  };

  static OutsidePlantRelationship fromRow(Map<String, dynamic> row) {
    return OutsidePlantRelationship(
      id: row['id'] as String,
      sourceEntityType: row['source_entity_type'] as String,
      sourceEntityId: row['source_entity_id'] as String,
      targetEntityType: row['target_entity_type'] as String,
      targetEntityId: row['target_entity_id'] as String,
      relationshipType: row['relationship_type'] as String,
      syncStatus: _syncStatusFromDb(row['sync_status'] as String),
      createdAt: row['created_at'] as DateTime?,
      updatedAt: row['updated_at'] as DateTime?,
    );
  }

  static List<Variable<Object>> insertVariables(
      OutsidePlantRelationship entity) {
    final createdAt = entity.createdAt ?? DateTime.now();
    final updatedAt = entity.updatedAt ?? createdAt;

    return [
      Variable<String>(entity.id),
      Variable<String>(entity.sourceEntityType),
      Variable<String>(entity.sourceEntityId),
      Variable<String>(entity.targetEntityType),
      Variable<String>(entity.targetEntityId),
      Variable<String>(entity.relationshipType),
      Variable<String>(_syncStatusToDb(entity.syncStatus)),
      Variable<String>(createdAt.toIso8601String()),
      Variable<String>(updatedAt.toIso8601String()),
    ];
  }

  static SyncStatus _syncStatusFromDb(String raw) {
    switch (raw) {
      case 'pending':
        return SyncStatus.pending;
      case 'synced':
        return SyncStatus.synced;
      case 'error':
        return SyncStatus.error;
      default:
        return SyncStatus.pending;
    }
  }

  static String _syncStatusToDb(SyncStatus status) {
    switch (status) {
      case SyncStatus.pending:
        return 'pending';
      case SyncStatus.synced:
        return 'synced';
      case SyncStatus.error:
        return 'error';
    }
  }
}
