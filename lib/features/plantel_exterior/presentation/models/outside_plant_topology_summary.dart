class OutsidePlantTopologySummary {
  final String entityType;
  final String entityId;
  final int totalRelationships;
  final int incomingCount;
  final int outgoingCount;
  final int connectedCajasCount;
  final int connectedBotellasCount;
  final Map<String, int> relationshipTypeCounts;
  final List<OutsidePlantTopologyNeighbor> neighbors;

  const OutsidePlantTopologySummary({
    required this.entityType,
    required this.entityId,
    required this.totalRelationships,
    required this.incomingCount,
    required this.outgoingCount,
    required this.connectedCajasCount,
    required this.connectedBotellasCount,
    required this.relationshipTypeCounts,
    required this.neighbors,
  });
}

class OutsidePlantTopologyNeighbor {
  final String relationshipId;
  final String direction;
  final String relationshipType;
  final String otherEntityType;
  final String otherEntityId;
  final String otherEntityLabel;

  const OutsidePlantTopologyNeighbor({
    required this.relationshipId,
    required this.direction,
    required this.relationshipType,
    required this.otherEntityType,
    required this.otherEntityId,
    required this.otherEntityLabel,
  });
}
