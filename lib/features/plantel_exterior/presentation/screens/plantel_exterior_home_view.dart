import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/application/providers/outside_plant_providers.dart';
import 'package:mi_ipred_plantel_exterior/shared/widgets/info_card.dart';

class PlantelExteriorHomeView extends ConsumerWidget {
  const PlantelExteriorHomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final bool isCompact = MediaQuery.of(context).size.width < 700;
    final cajasAsync = ref.watch(cajasPonOntListProvider);
    final botellasAsync = ref.watch(botellasEmpalmeListProvider);

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
                'Phase 0.2.3 agrega persistencia local real para Web + Android. '
                'La home ya resume información almacenada en base local del módulo y deja listo el camino para CRUD, offline simple y sincronización futura.',
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  InfoCard(
                    title: 'Cajas PON / ONT',
                    value: cajasAsync.when(
                      data: (items) => '${items.length}',
                      loading: () => 'Cargando...',
                      error: (_, __) => 'Error',
                    ),
                  ),
                  InfoCard(
                    title: 'Botellas de Empalme',
                    value: botellasAsync.when(
                      data: (items) => '${items.length}',
                      loading: () => 'Cargando...',
                      error: (_, __) => 'Error',
                    ),
                  ),
                  const InfoCard(
                    title: 'Persistencia local',
                    value: 'Drift activa',
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
                        'La UI ya no depende de entidades hardcodeadas dentro de los widgets.',
                      ),
                      _buildBullet(
                        context,
                        'Las secciones del dominio leen datos desde un repositorio local concreto.',
                      ),
                      _buildBullet(
                        context,
                        'La base queda preparada para formularios, CRUD y sync posterior.',
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
