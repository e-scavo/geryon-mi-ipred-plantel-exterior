import 'dart:convert';

import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/entities/caja_pon_ont.dart';

class CajaPonOntSyncSnapshotMapper {
  static Map<String, dynamic> toMap(CajaPonOnt caja) {
    return {
      'id': caja.id.value,
      'entityType': 'caja_pon_ont',
      'codigo': caja.codigo,
      'descripcion': caja.descripcion,
      'latitude': caja.location?.latitude,
      'longitude': caja.location?.longitude,
      'syncStatus': caja.syncStatus.name,
      'createdAt': caja.createdAt?.toIso8601String(),
      'updatedAt': caja.updatedAt?.toIso8601String(),
    };
  }

  static String toJson(CajaPonOnt caja) => jsonEncode(toMap(caja));

  static String deleteSnapshot({
    required String entityId,
    required String codigo,
  }) {
    return jsonEncode({
      'id': entityId,
      'entityType': 'caja_pon_ont',
      'codigo': codigo,
      'operation': 'delete',
      'capturedAt': DateTime.now().toIso8601String(),
    });
  }
}
