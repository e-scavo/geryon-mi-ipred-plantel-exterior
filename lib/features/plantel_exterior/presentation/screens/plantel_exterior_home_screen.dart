import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/presentation/providers/plantel_navigation_provider.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/presentation/screens/botellas_empalme_screen.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/presentation/screens/cajas_pon_ont_screen.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/presentation/screens/plantel_exterior_home_view.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/presentation/widgets/plantel_exterior_drawer.dart';

class PlantelExteriorHomeScreen extends ConsumerWidget {
  const PlantelExteriorHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSection = ref.watch(plantelExteriorNavigationProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(_resolveTitle(currentSection)),
      ),
      drawer: const PlantelExteriorDrawer(),
      body: _buildBody(currentSection),
    );
  }

  String _resolveTitle(PlantelExteriorSection section) {
    switch (section) {
      case PlantelExteriorSection.home:
        return 'Plantel Exterior';
      case PlantelExteriorSection.cajasPonOnt:
        return 'Cajas PON / ONT';
      case PlantelExteriorSection.botellasEmpalme:
        return 'Botellas de Empalme';
    }
  }

  Widget _buildBody(PlantelExteriorSection section) {
    switch (section) {
      case PlantelExteriorSection.home:
        return const PlantelExteriorHomeView();
      case PlantelExteriorSection.cajasPonOnt:
        return const CajasPonOntScreen();
      case PlantelExteriorSection.botellasEmpalme:
        return const BotellasEmpalmeScreen();
    }
  }
}
