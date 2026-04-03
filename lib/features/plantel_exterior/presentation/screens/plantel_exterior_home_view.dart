import 'package:flutter/material.dart';
import 'package:mi_ipred_plantel_exterior/shared/widgets/info_card.dart';

class PlantelExteriorHomeView extends StatelessWidget {
  const PlantelExteriorHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isCompact = MediaQuery.of(context).size.width < 700;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mi IP·RED Plantel Exterior',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Phase 0.2.2 incorpora la primera base real de dominio del producto. '
                'La app mantiene runtime, login, sesión y backend intactos, pero ahora suma entidades tipadas, '
                'value objects y contratos base para evolucionar hacia CRUD, persistencia local y offline simple.',
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: const [
                  InfoCard(
                    title: 'Entidad 1',
                    value: 'Caja PON / ONT',
                  ),
                  InfoCard(
                    title: 'Entidad 2',
                    value: 'Botella de Empalme',
                  ),
                  InfoCard(
                    title: 'Estado actual',
                    value: 'Dominio base tipado',
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Card(
                elevation: 2,
                surfaceTintColor: theme.colorScheme.surface,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Alcance real de esta pantalla',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 14),
                      _buildBullet(
                        context,
                        'El runtime, login, sesión y backend permanecen intactos.',
                      ),
                      _buildBullet(
                        context,
                        'La superficie principal sigue desacoplada del dashboard cliente heredado.',
                      ),
                      _buildBullet(
                        context,
                        'El dominio ya existe como código real y no solo como placeholders visuales.',
                      ),
                      _buildBullet(
                        context,
                        'Se preparan contratos base para persistencia y sincronización futuras.',
                      ),
                      if (isCompact) const SizedBox(height: 6),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBullet(BuildContext context, String text) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Icon(
              Icons.check_circle_outline,
              size: 18,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text),
          ),
        ],
      ),
    );
  }
}
