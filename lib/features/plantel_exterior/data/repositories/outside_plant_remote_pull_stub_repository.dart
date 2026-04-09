import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/contracts/outside_plant_remote_pull_contract.dart';

class OutsidePlantRemotePullStubRepository
    implements OutsidePlantRemotePullContract {
  const OutsidePlantRemotePullStubRepository();

  @override
  Future<List<Map<String, dynamic>>> fetchBotellasEmpalme() async {
    return const [];
  }

  @override
  Future<List<Map<String, dynamic>>> fetchCajasPonOnt() async {
    return const [];
  }
}
