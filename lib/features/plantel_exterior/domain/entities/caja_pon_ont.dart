import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/enums/sync_status.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/value_objects/geo_point.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/value_objects/outside_plant_id.dart';

class CajaPonOnt {
  final OutsidePlantId id;
  final String codigo;
  final String descripcion;
  final GeoPoint? location;
  final SyncStatus syncStatus;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const CajaPonOnt({
    required this.id,
    required this.codigo,
    required this.descripcion,
    this.location,
    this.syncStatus = SyncStatus.synced,
    this.createdAt,
    this.updatedAt,
  });

  CajaPonOnt copyWith({
    OutsidePlantId? id,
    String? codigo,
    String? descripcion,
    GeoPoint? location,
    bool clearLocation = false,
    SyncStatus? syncStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CajaPonOnt(
      id: id ?? this.id,
      codigo: codigo ?? this.codigo,
      descripcion: descripcion ?? this.descripcion,
      location: clearLocation ? null : (location ?? this.location),
      syncStatus: syncStatus ?? this.syncStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get hasLocation => location != null;
}
