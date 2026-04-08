import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/entities/botella_empalme.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/entities/caja_pon_ont.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/presentation/providers/outside_plant_providers.dart';

final createCajaPonOntProvider =
    FutureProvider.family<void, CajaPonOnt>((ref, caja) async {
  final repository = ref.read(outsidePlantRepositoryProvider);
  await repository.saveCajaPonOnt(caja);
  ref.invalidate(cajasPonOntListProvider);
});

final createBotellaEmpalmeProvider =
    FutureProvider.family<void, BotellaEmpalme>((ref, botella) async {
  final repository = ref.read(outsidePlantRepositoryProvider);
  await repository.saveBotellaEmpalme(botella);
  ref.invalidate(botellasEmpalmeListProvider);
});
