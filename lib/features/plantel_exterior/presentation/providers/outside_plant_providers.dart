import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/application/services/outside_plant_push_sync_processor.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/application/services/outside_plant_sync_service.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/data/local/app_database.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/data/repositories/drift_outside_plant_repository.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/data/repositories/drift_outside_plant_sync_repository.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/data/repositories/outside_plant_remote_sync_stub_repository.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/contracts/outside_plant_remote_sync_contract.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/entities/botella_empalme.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/entities/caja_pon_ont.dart';

final plantelExteriorDatabaseProvider =
    Provider<PlantelExteriorDatabase>((ref) {
  final database = PlantelExteriorDatabase();

  ref.onDispose(() {
    database.close();
  });

  return database;
});

final outsidePlantRepositoryProvider =
    Provider<DriftOutsidePlantRepository>((ref) {
  final database = ref.watch(plantelExteriorDatabaseProvider);
  return DriftOutsidePlantRepository(database);
});

final outsidePlantSyncRepositoryProvider =
    Provider<DriftOutsidePlantSyncRepository>((ref) {
  final database = ref.watch(plantelExteriorDatabaseProvider);
  return DriftOutsidePlantSyncRepository(database);
});

final outsidePlantRemoteSyncRepositoryProvider =
    Provider<OutsidePlantRemoteSyncContract>((ref) {
  return const OutsidePlantRemoteSyncStubRepository();
});

final outsidePlantSyncServiceProvider =
    Provider<OutsidePlantSyncService>((ref) {
  final database = ref.watch(plantelExteriorDatabaseProvider);
  final repository = ref.watch(outsidePlantRepositoryProvider);
  final syncRepository = ref.watch(outsidePlantSyncRepositoryProvider);

  return OutsidePlantSyncService(
    db: database,
    repository: repository,
    syncRepository: syncRepository,
  );
});

final outsidePlantPushSyncProcessorProvider =
    Provider<OutsidePlantPushSyncProcessor>((ref) {
  final repository = ref.watch(outsidePlantRepositoryProvider);
  final syncRepository = ref.watch(outsidePlantSyncRepositoryProvider);
  final remoteSyncRepository = ref.watch(
    outsidePlantRemoteSyncRepositoryProvider,
  );

  return OutsidePlantPushSyncProcessor(
    repository: repository,
    syncRepository: syncRepository,
    remoteSyncRepository: remoteSyncRepository,
  );
});

final cajasPonOntListProvider = FutureProvider<List<CajaPonOnt>>((ref) async {
  final repository = ref.watch(outsidePlantRepositoryProvider);
  await repository.ensureSeedData();
  return repository.getCajasPonOnt();
});

final botellasEmpalmeListProvider =
    FutureProvider<List<BotellaEmpalme>>((ref) async {
  final repository = ref.watch(outsidePlantRepositoryProvider);
  await repository.ensureSeedData();
  return repository.getBotellasEmpalme();
});

final outsidePlantPendingSyncCountProvider = FutureProvider<int>((ref) async {
  final repository = ref.watch(outsidePlantSyncRepositoryProvider);
  return repository.getPendingItemsCount();
});
