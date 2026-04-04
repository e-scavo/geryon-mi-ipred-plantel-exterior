import 'package:drift/drift.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/data/local/app_database.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/entities/botella_empalme.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/enums/sync_status.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/value_objects/geo_point.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/value_objects/outside_plant_id.dart';

class BotellaEmpalmeMapper {
  static BotellaEmpalme toEntity(BotellasEmpalmeTableData row) {
    return BotellaEmpalme(
      id: OutsidePlantId(row.id),
      codigo: row.codigo,
      descripcion: row.descripcion,
      location: row.latitude != null && row.longitude != null
          ? GeoPoint(
              latitude: row.latitude!,
              longitude: row.longitude!,
            )
          : null,
      syncStatus: _syncStatusFromDb(row.syncStatus),
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  static BotellasEmpalmeTableCompanion toCompanion(BotellaEmpalme entity) {
    return BotellasEmpalmeTableCompanion(
      id: Value(entity.id.value),
      codigo: Value(entity.codigo),
      descripcion: Value(entity.descripcion),
      latitude: entity.location == null
          ? const Value.absent()
          : Value(entity.location!.latitude),
      longitude: entity.location == null
          ? const Value.absent()
          : Value(entity.location!.longitude),
      syncStatus: Value(_syncStatusToDb(entity.syncStatus)),
      createdAt: Value(entity.createdAt),
      updatedAt: Value(entity.updatedAt),
    );
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
