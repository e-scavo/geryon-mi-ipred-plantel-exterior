import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/enums/sync_status.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/value_objects/geo_point.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/value_objects/outside_plant_id.dart';

class BotellaEmpalme {
  static const Object _undefined = Object();

  final OutsidePlantId id;
  final String codigo;
  final String descripcion;
  final GeoPoint? location;
  final String? codigoTecnico;
  final String? referenciaExterna;
  final String? observacionesTecnicas;
  final String? estadoOperativo;
  final int? criticidad;
  final String? zona;
  final String? sector;
  final String? tramo;
  final SyncStatus syncStatus;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const BotellaEmpalme({
    required this.id,
    required this.codigo,
    required this.descripcion,
    this.location,
    this.codigoTecnico,
    this.referenciaExterna,
    this.observacionesTecnicas,
    this.estadoOperativo,
    this.criticidad,
    this.zona,
    this.sector,
    this.tramo,
    this.syncStatus = SyncStatus.synced,
    this.createdAt,
    this.updatedAt,
  });

  BotellaEmpalme copyWith({
    OutsidePlantId? id,
    String? codigo,
    String? descripcion,
    GeoPoint? location,
    bool clearLocation = false,
    Object? codigoTecnico = _undefined,
    Object? referenciaExterna = _undefined,
    Object? observacionesTecnicas = _undefined,
    Object? estadoOperativo = _undefined,
    Object? criticidad = _undefined,
    Object? zona = _undefined,
    Object? sector = _undefined,
    Object? tramo = _undefined,
    SyncStatus? syncStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BotellaEmpalme(
      id: id ?? this.id,
      codigo: codigo ?? this.codigo,
      descripcion: descripcion ?? this.descripcion,
      location: clearLocation ? null : (location ?? this.location),
      codigoTecnico: identical(codigoTecnico, _undefined)
          ? this.codigoTecnico
          : codigoTecnico as String?,
      referenciaExterna: identical(referenciaExterna, _undefined)
          ? this.referenciaExterna
          : referenciaExterna as String?,
      observacionesTecnicas: identical(observacionesTecnicas, _undefined)
          ? this.observacionesTecnicas
          : observacionesTecnicas as String?,
      estadoOperativo: identical(estadoOperativo, _undefined)
          ? this.estadoOperativo
          : estadoOperativo as String?,
      criticidad: identical(criticidad, _undefined)
          ? this.criticidad
          : criticidad as int?,
      zona: identical(zona, _undefined) ? this.zona : zona as String?,
      sector: identical(sector, _undefined) ? this.sector : sector as String?,
      tramo: identical(tramo, _undefined) ? this.tramo : tramo as String?,
      syncStatus: syncStatus ?? this.syncStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get hasLocation => location != null;
}
