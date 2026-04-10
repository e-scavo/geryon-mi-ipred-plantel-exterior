import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/enums/sync_status.dart';

class OutsidePlantRelationship {
  final String id;
  final String sourceEntityType;
  final String sourceEntityId;
  final String targetEntityType;
  final String targetEntityId;
  final String relationshipType;
  final SyncStatus syncStatus;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const OutsidePlantRelationship({
    required this.id,
    required this.sourceEntityType,
    required this.sourceEntityId,
    required this.targetEntityType,
    required this.targetEntityId,
    required this.relationshipType,
    this.syncStatus = SyncStatus.synced,
    this.createdAt,
    this.updatedAt,
  });

  OutsidePlantRelationship copyWith({
    String? id,
    String? sourceEntityType,
    String? sourceEntityId,
    String? targetEntityType,
    String? targetEntityId,
    String? relationshipType,
    SyncStatus? syncStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return OutsidePlantRelationship(
      id: id ?? this.id,
      sourceEntityType: sourceEntityType ?? this.sourceEntityType,
      sourceEntityId: sourceEntityId ?? this.sourceEntityId,
      targetEntityType: targetEntityType ?? this.targetEntityType,
      targetEntityId: targetEntityId ?? this.targetEntityId,
      relationshipType: relationshipType ?? this.relationshipType,
      syncStatus: syncStatus ?? this.syncStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool involvesEntity({
    required String entityType,
    required String entityId,
  }) {
    return hasSource(entityType: entityType, entityId: entityId) ||
        hasTarget(entityType: entityType, entityId: entityId);
  }

  bool hasSource({
    required String entityType,
    required String entityId,
  }) {
    return sourceEntityType == entityType && sourceEntityId == entityId;
  }

  bool hasTarget({
    required String entityType,
    required String entityId,
  }) {
    return targetEntityType == entityType && targetEntityId == entityId;
  }

  bool isSameLinkAs(OutsidePlantRelationship other) {
    return sourceEntityType == other.sourceEntityType &&
        sourceEntityId == other.sourceEntityId &&
        targetEntityType == other.targetEntityType &&
        targetEntityId == other.targetEntityId &&
        relationshipType == other.relationshipType;
  }
}
