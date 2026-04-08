import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/enums/sync_operation_type.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/enums/sync_queue_status.dart';

class OutsidePlantSyncQueueItem {
  final String id;
  final String entityType;
  final String entityId;
  final SyncOperationType operationType;
  final String payloadJson;
  final SyncQueueStatus status;
  final int attemptCount;
  final String? lastError;
  final DateTime createdAt;
  final DateTime updatedAt;

  const OutsidePlantSyncQueueItem({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.operationType,
    required this.payloadJson,
    this.status = SyncQueueStatus.pending,
    this.attemptCount = 0,
    this.lastError,
    required this.createdAt,
    required this.updatedAt,
  });

  OutsidePlantSyncQueueItem copyWith({
    String? id,
    String? entityType,
    String? entityId,
    SyncOperationType? operationType,
    String? payloadJson,
    SyncQueueStatus? status,
    int? attemptCount,
    String? lastError,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return OutsidePlantSyncQueueItem(
      id: id ?? this.id,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      operationType: operationType ?? this.operationType,
      payloadJson: payloadJson ?? this.payloadJson,
      status: status ?? this.status,
      attemptCount: attemptCount ?? this.attemptCount,
      lastError: lastError ?? this.lastError,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
