import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/entities/botella_empalme.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/entities/caja_pon_ont.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/models/outside_plant_pull_cycle_result.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/models/outside_plant_push_cycle_result.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/presentation/providers/outside_plant_providers.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/presentation/providers/outside_plant_sync_ui_provider.dart';

final saveCajaPonOntProvider =
    FutureProvider.family<void, ({CajaPonOnt caja, bool isEditMode})>(
  (ref, args) async {
    final service = ref.read(outsidePlantSyncServiceProvider);
    await service.saveCajaPonOnt(
      args.caja,
      isEditMode: args.isEditMode,
    );
    ref.invalidate(cajasPonOntListProvider);
    ref.invalidate(outsidePlantPendingSyncCountProvider);
  },
);

final saveBotellaEmpalmeProvider =
    FutureProvider.family<void, ({BotellaEmpalme botella, bool isEditMode})>(
  (ref, args) async {
    final service = ref.read(outsidePlantSyncServiceProvider);
    await service.saveBotellaEmpalme(
      args.botella,
      isEditMode: args.isEditMode,
    );
    ref.invalidate(botellasEmpalmeListProvider);
    ref.invalidate(outsidePlantPendingSyncCountProvider);
  },
);

final deleteCajaPonOntProvider =
    FutureProvider.family<void, CajaPonOnt>((ref, caja) async {
  final service = ref.read(outsidePlantSyncServiceProvider);
  await service.deleteCajaPonOnt(caja);
  ref.invalidate(cajasPonOntListProvider);
  ref.invalidate(outsidePlantPendingSyncCountProvider);
});

final deleteBotellaEmpalmeProvider =
    FutureProvider.family<void, BotellaEmpalme>((ref, botella) async {
  final service = ref.read(outsidePlantSyncServiceProvider);
  await service.deleteBotellaEmpalme(botella);
  ref.invalidate(botellasEmpalmeListProvider);
  ref.invalidate(outsidePlantPendingSyncCountProvider);
});

final runOutsidePlantPushSyncProvider =
    FutureProvider<OutsidePlantPushCycleResult>((ref) async {
  final processor = ref.read(outsidePlantPushSyncProcessorProvider);
  final result = await processor.runPushCycle();

  ref.invalidate(cajasPonOntListProvider);
  ref.invalidate(botellasEmpalmeListProvider);
  ref.invalidate(outsidePlantPendingSyncCountProvider);

  return result;
});

final runOutsidePlantPushSyncActionProvider =
    FutureProvider<String>((ref) async {
  final syncUiNotifier = ref.read(outsidePlantSyncUiProvider.notifier);
  syncUiNotifier.startPush();

  try {
    final result = await ref.refresh(runOutsidePlantPushSyncProvider.future);
    syncUiNotifier.completePush(result);
    return 'Push ejecutado. Procesados: ${result.processedCount} | OK: ${result.successCount} | Error: ${result.errorCount}';
  } catch (error) {
    syncUiNotifier.failPush(error);
    rethrow;
  }
});

final runOutsidePlantPullSyncProvider =
    FutureProvider<OutsidePlantPullCycleResult>((ref) async {
  final processor = ref.read(outsidePlantPullSyncProcessorProvider);
  final result = await processor.runPullCycle();

  ref.invalidate(cajasPonOntListProvider);
  ref.invalidate(botellasEmpalmeListProvider);

  return result;
});

final runOutsidePlantPullSyncActionProvider =
    FutureProvider<String>((ref) async {
  final syncUiNotifier = ref.read(outsidePlantSyncUiProvider.notifier);
  syncUiNotifier.startPull();

  try {
    final result = await ref.refresh(runOutsidePlantPullSyncProvider.future);
    syncUiNotifier.completePull(result);
    return 'Pull ejecutado. Remotos: ${result.fetchedCount} | Insertados: ${result.insertedCount} | Actualizados: ${result.updatedCount} | Omitidos: ${result.skippedCount}';
  } catch (error) {
    syncUiNotifier.failPull(error);
    rethrow;
  }
});
