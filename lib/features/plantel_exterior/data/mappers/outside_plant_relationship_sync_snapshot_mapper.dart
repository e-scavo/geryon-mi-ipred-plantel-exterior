import 'dart:convert';

import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/entities/outside_plant_relationship.dart';

class OutsidePlantRelationshipSyncSnapshotMapper {
  static Map<String, dynamic> toMap(OutsidePlantRelationship relationship) {
    return {
      'id': relationship.id,
      'entityType': 'outside_plant_relationship',
      'sourceEntityType': relationship.sourceEntityType,
      'sourceEntityId': relationship.sourceEntityId,
      'targetEntityType': relationship.targetEntityType,
      'targetEntityId': relationship.targetEntityId,
      'relationshipType': relationship.relationshipType,
      'syncStatus': relationship.syncStatus.name,
      'createdAt': relationship.createdAt?.toIso8601String(),
      'updatedAt': relationship.updatedAt?.toIso8601String(),
    };
  }

  static String toJson(OutsidePlantRelationship relationship) =>
      jsonEncode(toMap(relationship));

  static String deleteSnapshot({
    required String relationshipId,
    required String sourceEntityType,
    required String sourceEntityId,
    required String targetEntityType,
    required String targetEntityId,
    required String relationshipType,
  }) {
    return jsonEncode({
      'id': relationshipId,
      'entityType': 'outside_plant_relationship',
      'sourceEntityType': sourceEntityType,
      'sourceEntityId': sourceEntityId,
      'targetEntityType': targetEntityType,
      'targetEntityId': targetEntityId,
      'relationshipType': relationshipType,
      'operation': 'delete',
      'capturedAt': DateTime.now().toIso8601String(),
    });
  }
}
