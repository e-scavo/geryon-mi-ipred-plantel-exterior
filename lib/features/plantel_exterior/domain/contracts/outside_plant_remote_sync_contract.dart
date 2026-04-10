import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/models/outside_plant_remote_push_result.dart';

abstract class OutsidePlantRemoteSyncContract {
  Future<OutsidePlantRemotePushResult> pushCajaPonOntCreate(String payloadJson);

  Future<OutsidePlantRemotePushResult> pushCajaPonOntUpdate(String payloadJson);

  Future<OutsidePlantRemotePushResult> pushCajaPonOntDelete(String payloadJson);

  Future<OutsidePlantRemotePushResult> pushBotellaEmpalmeCreate(
      String payloadJson);

  Future<OutsidePlantRemotePushResult> pushBotellaEmpalmeUpdate(
      String payloadJson);

  Future<OutsidePlantRemotePushResult> pushBotellaEmpalmeDelete(
      String payloadJson);

  Future<OutsidePlantRemotePushResult> pushRelationshipCreate(
      String payloadJson);

  Future<OutsidePlantRemotePushResult> pushRelationshipUpdate(
      String payloadJson);

  Future<OutsidePlantRemotePushResult> pushRelationshipDelete(
      String payloadJson);
}
