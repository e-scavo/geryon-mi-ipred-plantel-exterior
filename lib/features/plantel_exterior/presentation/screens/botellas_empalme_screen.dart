import 'package:flutter/material.dart';
import 'package:mi_ipred_plantel_exterior/shared/widgets/feature_empty_state.dart';

class BotellasEmpalmeScreen extends StatelessWidget {
  const BotellasEmpalmeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeatureEmptyState(
      title: 'Botella de Empalme',
      message:
          'Esta sección incorpora desde el inicio la segunda entidad principal del dominio. '
          'En fases posteriores se agregarán operaciones reales, relaciones con troncales y soporte offline simple.',
      icon: Icons.hub_outlined,
    );
  }
}
