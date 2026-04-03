import 'package:flutter_riverpod/flutter_riverpod.dart';

enum PlantelExteriorSection {
  home,
  cajasPonOnt,
  botellasEmpalme,
}

final plantelExteriorNavigationProvider =
    StateProvider<PlantelExteriorSection>((ref) {
  return PlantelExteriorSection.home;
});
