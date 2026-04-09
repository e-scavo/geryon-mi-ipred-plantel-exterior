import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/entities/botella_empalme.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/entities/caja_pon_ont.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/value_objects/outside_plant_id.dart';

abstract class OutsidePlantRepositoryContract {
  Future<void> ensureSeedData();

  Future<List<CajaPonOnt>> getCajasPonOnt();

  Future<List<BotellaEmpalme>> getBotellasEmpalme();

  Future<void> saveCajaPonOnt(CajaPonOnt caja);

  Future<void> saveBotellaEmpalme(BotellaEmpalme botella);

  Future<void> deleteCajaPonOnt(OutsidePlantId id);

  Future<void> deleteBotellaEmpalme(OutsidePlantId id);

  Future<void> markCajaPonOntSynced(OutsidePlantId id);

  Future<void> markBotellaEmpalmeSynced(OutsidePlantId id);
}
