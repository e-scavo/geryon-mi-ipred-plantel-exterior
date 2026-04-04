import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/data/local/app_database.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/data/repositories/drift_outside_plant_repository.dart';
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
