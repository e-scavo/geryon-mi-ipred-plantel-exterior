import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/contracts/outside_plant_remote_sync_contract.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/models/outside_plant_remote_push_result.dart';

class OutsidePlantRemoteSyncStubRepository
    implements OutsidePlantRemoteSyncContract {
  const OutsidePlantRemoteSyncStubRepository();

  @override
  Future<OutsidePlantRemotePushResult> pushBotellaEmpalmeCreate(
    String payloadJson,
  ) async {
    return _unavailable();
  }

  @override
  Future<OutsidePlantRemotePushResult> pushBotellaEmpalmeDelete(
    String payloadJson,
  ) async {
    return _unavailable();
  }

  @override
  Future<OutsidePlantRemotePushResult> pushBotellaEmpalmeUpdate(
    String payloadJson,
  ) async {
    return _unavailable();
  }

  @override
  Future<OutsidePlantRemotePushResult> pushCajaPonOntCreate(
    String payloadJson,
  ) async {
    return _unavailable();
  }

  @override
  Future<OutsidePlantRemotePushResult> pushCajaPonOntDelete(
    String payloadJson,
  ) async {
    return _unavailable();
  }

  @override
  Future<OutsidePlantRemotePushResult> pushCajaPonOntUpdate(
    String payloadJson,
  ) async {
    return _unavailable();
  }

  @override
  Future<OutsidePlantRemotePushResult> pushRelationshipCreate(
    String payloadJson,
  ) async {
    return _unavailable();
  }

  @override
  Future<OutsidePlantRemotePushResult> pushRelationshipDelete(
    String payloadJson,
  ) async {
    return _unavailable();
  }

  @override
  Future<OutsidePlantRemotePushResult> pushRelationshipUpdate(
    String payloadJson,
  ) async {
    return _unavailable();
  }

  OutsidePlantRemotePushResult _unavailable() {
    return OutsidePlantRemotePushResult.failure(
      'Remote sync contract not wired yet. Waiting for real Go structs/tables and backend mapping.',
    );
  }
}
