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
                'Superficie inicial del nuevo producto para gestión técnica de infraestructura pasiva FTTH. '
                'En esta fase se reemplaza el dashboard cliente heredado como pantalla principal '
                'y se prepara una navegación base escalable para futuras etapas.',
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
                    value: 'Skeleton funcional',
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
                        'La app deja de mostrar el dashboard cliente como superficie principal.',
                      ),
                      _buildBullet(
                        context,
                        'Se incorpora una navegación base preparada para crecer.',
                      ),
                      _buildBullet(
                        context,
                        'Las entidades del dominio ya existen visualmente como secciones reales.',
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
