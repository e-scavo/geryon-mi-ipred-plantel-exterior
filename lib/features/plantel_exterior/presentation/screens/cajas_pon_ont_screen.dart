import 'package:flutter/material.dart';
import 'package:mi_ipred_plantel_exterior/shared/widgets/feature_empty_state.dart';

class CajasPonOntScreen extends StatelessWidget {
  const CajasPonOntScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeatureEmptyState(
      title: 'Caja PON / ONT',
      message:
          'Esta sección representa el primer skeleton real del dominio de plantel exterior. '
          'En fases posteriores se incorporarán listado, alta, edición, detalle, mapa y persistencia local real.',
      icon: Icons.settings_input_component_outlined,
    );
  }
}
