import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/entities/botella_empalme.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/entities/caja_pon_ont.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/entities/outside_plant_relationship.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/value_objects/outside_plant_id.dart';

abstract class OutsidePlantRepositoryContract {
  Future<void> ensureSeedData();

  Future<List<CajaPonOnt>> getCajasPonOnt();

  Future<List<BotellaEmpalme>> getBotellasEmpalme();

  Future<List<OutsidePlantRelationship>> getRelationships();

  Future<List<OutsidePlantRelationship>> getRelationshipsByEntity({
    required String entityType,
    required OutsidePlantId entityId,
  });

  Future<void> saveCajaPonOnt(CajaPonOnt caja);

  Future<void> saveBotellaEmpalme(BotellaEmpalme botella);

  Future<void> saveRelationship(OutsidePlantRelationship relationship);

  Future<void> deleteCajaPonOnt(OutsidePlantId id);

  Future<void> deleteBotellaEmpalme(OutsidePlantId id);

  Future<void> deleteRelationship(String relationshipId);

  Future<void> markCajaPonOntSynced(OutsidePlantId id);

  Future<void> markBotellaEmpalmeSynced(OutsidePlantId id);

  Future<void> markRelationshipSynced(String relationshipId);

  Future<bool> relationshipExists({
    required String sourceEntityType,
    required String sourceEntityId,
    required String targetEntityType,
    required String targetEntityId,
    required String relationshipType,
  });
}
