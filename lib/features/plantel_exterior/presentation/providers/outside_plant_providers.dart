import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/application/services/outside_plant_pull_sync_processor.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/application/services/outside_plant_push_sync_processor.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/application/services/outside_plant_sync_service.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/data/local/app_database.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/data/repositories/drift_outside_plant_repository.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/data/repositories/drift_outside_plant_sync_repository.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/data/repositories/outside_plant_remote_pull_stub_repository.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/data/repositories/outside_plant_remote_sync_stub_repository.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/contracts/outside_plant_remote_pull_contract.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/contracts/outside_plant_remote_sync_contract.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/entities/botella_empalme.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/entities/caja_pon_ont.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/entities/outside_plant_relationship.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/enums/sync_status.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/value_objects/outside_plant_id.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/presentation/state/outside_plant_search_filters.dart';

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

final outsidePlantRemotePullRepositoryProvider =
    Provider<OutsidePlantRemotePullContract>((ref) {
  return const OutsidePlantRemotePullStubRepository();
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

final outsidePlantPullSyncProcessorProvider =
    Provider<OutsidePlantPullSyncProcessor>((ref) {
  final repository = ref.watch(outsidePlantRepositoryProvider);
  final remotePullRepository = ref.watch(
    outsidePlantRemotePullRepositoryProvider,
  );

  return OutsidePlantPullSyncProcessor(
    repository: repository,
    remotePullRepository: remotePullRepository,
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

final outsidePlantRelationshipsListProvider =
    FutureProvider<List<OutsidePlantRelationship>>((ref) async {
  final repository = ref.watch(outsidePlantRepositoryProvider);
  await repository.ensureSeedData();
  return repository.getRelationships();
});

final outsidePlantRelationshipsByEntityProvider = FutureProvider.family<
    List<OutsidePlantRelationship>,
    ({String entityType, String entityId})>((ref, args) async {
  final repository = ref.watch(outsidePlantRepositoryProvider);
  await repository.ensureSeedData();
  return repository.getRelationshipsByEntity(
    entityType: args.entityType,
    entityId: OutsidePlantId(args.entityId),
  );
});

final outsidePlantPendingSyncCountProvider = FutureProvider<int>((ref) async {
  final repository = ref.watch(outsidePlantSyncRepositoryProvider);
  return repository.getPendingItemsCount();
});

final cajasSearchFiltersProvider =
    StateProvider<OutsidePlantSearchFilters>((ref) {
  return OutsidePlantSearchFilters.empty;
});

final botellasSearchFiltersProvider =
    StateProvider<OutsidePlantSearchFilters>((ref) {
  return OutsidePlantSearchFilters.empty;
});

final filteredCajasPonOntProvider =
    FutureProvider<List<CajaPonOnt>>((ref) async {
  final items = await ref.watch(cajasPonOntListProvider.future);
  final filters = ref.watch(cajasSearchFiltersProvider);
  return items.where((item) => _matchesCajaFilters(item, filters)).toList();
});

final filteredBotellasEmpalmeProvider =
    FutureProvider<List<BotellaEmpalme>>((ref) async {
  final items = await ref.watch(botellasEmpalmeListProvider.future);
  final filters = ref.watch(botellasSearchFiltersProvider);
  return items.where((item) => _matchesBotellaFilters(item, filters)).toList();
});

bool _matchesCajaFilters(CajaPonOnt item, OutsidePlantSearchFilters filters) {
  if (!_matchesTextQuery(
    filters.query,
    [
      item.codigo,
      item.descripcion,
      item.codigoTecnico,
      item.referenciaExterna,
      item.observacionesTecnicas,
      item.zona,
      item.sector,
      item.tramo,
    ],
  )) {
    return false;
  }

  if (!_matchesOperationalStatus(
      item.estadoOperativo, filters.operationalStatus)) {
    return false;
  }

  if (filters.criticality != null && item.criticidad != filters.criticality) {
    return false;
  }

  if (!_matchesSyncStatus(item.syncStatus, filters.syncStatus)) {
    return false;
  }

  return true;
}

bool _matchesBotellaFilters(
  BotellaEmpalme item,
  OutsidePlantSearchFilters filters,
) {
  if (!_matchesTextQuery(
    filters.query,
    [
      item.codigo,
      item.descripcion,
      item.codigoTecnico,
      item.referenciaExterna,
      item.observacionesTecnicas,
      item.zona,
      item.sector,
      item.tramo,
    ],
  )) {
    return false;
  }

  if (!_matchesOperationalStatus(
      item.estadoOperativo, filters.operationalStatus)) {
    return false;
  }

  if (filters.criticality != null && item.criticidad != filters.criticality) {
    return false;
  }

  if (!_matchesSyncStatus(item.syncStatus, filters.syncStatus)) {
    return false;
  }

  return true;
}

bool _matchesTextQuery(String query, List<String?> fields) {
  final normalizedQuery = query.trim().toLowerCase();

  if (normalizedQuery.isEmpty) {
    return true;
  }

  for (final field in fields) {
    if (field != null && field.trim().toLowerCase().contains(normalizedQuery)) {
      return true;
    }
  }

  return false;
}

bool _matchesOperationalStatus(String? itemValue, String? filterValue) {
  if (filterValue == null || filterValue.trim().isEmpty) {
    return true;
  }

  return (itemValue ?? '').trim().toLowerCase() ==
      filterValue.trim().toLowerCase();
}

bool _matchesSyncStatus(SyncStatus itemStatus, String? filterValue) {
  if (filterValue == null || filterValue.trim().isEmpty) {
    return true;
  }

  return itemStatus.name == filterValue;
}
