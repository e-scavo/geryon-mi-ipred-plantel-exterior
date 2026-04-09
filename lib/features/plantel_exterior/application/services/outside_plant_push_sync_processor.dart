import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/contracts/outside_plant_remote_sync_contract.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/contracts/outside_plant_repository_contract.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/contracts/outside_plant_sync_contract.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/entities/outside_plant_sync_queue_item.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/enums/sync_operation_type.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/models/outside_plant_push_cycle_result.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/models/outside_plant_remote_push_result.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/value_objects/outside_plant_id.dart';

class OutsidePlantPushSyncProcessor {
  final OutsidePlantRepositoryContract repository;
  final OutsidePlantSyncContract syncRepository;
  final OutsidePlantRemoteSyncContract remoteSyncRepository;

  const OutsidePlantPushSyncProcessor({
    required this.repository,
    required this.syncRepository,
    required this.remoteSyncRepository,
  });

  Future<OutsidePlantPushCycleResult> runPushCycle() async {
    final items = await syncRepository.getPendingItems();

    var processedCount = 0;
    var successCount = 0;
    var errorCount = 0;
    var skippedCount = 0;
    final errors = <String>[];

    for (final item in items) {
      processedCount += 1;

      try {
        await syncRepository.markProcessing(item.id);
        final remoteResult = await _dispatch(item);

        if (!remoteResult.success) {
          errorCount += 1;
          errors.add(
            '${item.entityType}/${item.operationType.name}: ${remoteResult.message}',
          );
          await syncRepository.markError(item.id, remoteResult.message);
          continue;
        }

        await _markEntityAsSyncedIfNeeded(item);
        await syncRepository.remove(item.id);
        successCount += 1;
      } catch (error) {
        errorCount += 1;
        final errorMessage = error.toString();
        errors.add(
            '${item.entityType}/${item.operationType.name}: $errorMessage');
        await syncRepository.markError(item.id, errorMessage);
      }
    }

    return OutsidePlantPushCycleResult(
      processedCount: processedCount,
      successCount: successCount,
      errorCount: errorCount,
      skippedCount: skippedCount,
      errors: errors,
    );
  }

  Future<OutsidePlantRemotePushResult> _dispatch(
    OutsidePlantSyncQueueItem item,
  ) async {
    switch (item.entityType) {
      case 'caja_pon_ont':
        switch (item.operationType) {
          case SyncOperationType.create:
            return remoteSyncRepository.pushCajaPonOntCreate(item.payloadJson);
          case SyncOperationType.update:
            return remoteSyncRepository.pushCajaPonOntUpdate(item.payloadJson);
          case SyncOperationType.delete:
            return remoteSyncRepository.pushCajaPonOntDelete(item.payloadJson);
        }
      case 'botella_empalme':
        switch (item.operationType) {
          case SyncOperationType.create:
            return remoteSyncRepository.pushBotellaEmpalmeCreate(
              item.payloadJson,
            );
          case SyncOperationType.update:
            return remoteSyncRepository.pushBotellaEmpalmeUpdate(
              item.payloadJson,
            );
          case SyncOperationType.delete:
            return remoteSyncRepository.pushBotellaEmpalmeDelete(
              item.payloadJson,
            );
        }
      default:
        return OutsidePlantRemotePushResult.failure(
          'Unsupported entity type: ${item.entityType}',
        );
    }
  }

  Future<void> _markEntityAsSyncedIfNeeded(
    OutsidePlantSyncQueueItem item,
  ) async {
    if (item.operationType == SyncOperationType.delete) {
      return;
    }

    final id = OutsidePlantId(item.entityId);

    switch (item.entityType) {
      case 'caja_pon_ont':
        await repository.markCajaPonOntSynced(id);
        return;
      case 'botella_empalme':
        await repository.markBotellaEmpalmeSynced(id);
        return;
    }
  }
}
