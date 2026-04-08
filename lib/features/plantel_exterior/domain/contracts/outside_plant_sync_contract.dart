import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/entities/outside_plant_sync_queue_item.dart';

abstract class OutsidePlantSyncContract {
  Future<void> enqueue(OutsidePlantSyncQueueItem item);

  Future<List<OutsidePlantSyncQueueItem>> getPendingItems();

  Future<int> getPendingItemsCount();

  Future<void> markProcessing(String id);

  Future<void> markError(String id, String errorMessage);

  Future<void> remove(String id);
}
