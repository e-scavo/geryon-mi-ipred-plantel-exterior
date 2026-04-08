import 'dart:convert';

import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/entities/botella_empalme.dart';

class BotellaEmpalmeSyncSnapshotMapper {
  static Map<String, dynamic> toMap(BotellaEmpalme botella) {
    return {
      'id': botella.id.value,
      'entityType': 'botella_empalme',
      'codigo': botella.codigo,
      'descripcion': botella.descripcion,
      'latitude': botella.location?.latitude,
      'longitude': botella.location?.longitude,
      'syncStatus': botella.syncStatus.name,
      'createdAt': botella.createdAt?.toIso8601String(),
      'updatedAt': botella.updatedAt?.toIso8601String(),
    };
  }

  static String toJson(BotellaEmpalme botella) => jsonEncode(toMap(botella));

  static String deleteSnapshot({
    required String entityId,
    required String codigo,
  }) {
    return jsonEncode({
      'id': entityId,
      'entityType': 'botella_empalme',
      'codigo': codigo,
      'operation': 'delete',
      'capturedAt': DateTime.now().toIso8601String(),
    });
  }
}
