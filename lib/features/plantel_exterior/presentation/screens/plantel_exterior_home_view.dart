import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/presentation/providers/outside_plant_providers.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/presentation/widgets/outside_plant_sync_actions_card.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/presentation/widgets/outside_plant_sync_feedback_banner.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/presentation/widgets/outside_plant_sync_summary_card.dart';
import 'package:mi_ipred_plantel_exterior/shared/widgets/info_card.dart';

class PlantelExteriorHomeView extends ConsumerWidget {
  const PlantelExteriorHomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cajasAsync = ref.watch(cajasPonOntListProvider);
    final botellasAsync = ref.watch(botellasEmpalmeListProvider);
    final pendingSyncAsync = ref.watch(outsidePlantPendingSyncCountProvider);

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
                'Phase 0.4.4 consolida la baseline UX de sincronización del módulo: el trabajo sigue siendo local-first, pero ahora el estado de push/pull y los errores visibles quedan mejor comunicados para uso diario y validación controlada.',
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
                  InfoCard(
                    title: 'Pendientes de sync',
                    value: pendingSyncAsync.when(
                      data: (count) => '$count',
                      loading: () => 'Cargando...',
                      error: (_, __) => 'Error',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const OutsidePlantSyncSummaryCard(),
              const SizedBox(height: 16),
              const OutsidePlantSyncFeedbackBanner(),
              const SizedBox(height: 16),
              const OutsidePlantSyncActionsCard(),
              const SizedBox(height: 24),
              Card(
                elevation: 2,
                surfaceTintColor: theme.colorScheme.surface,
                child: Padding(
                  padding: const EdgeInsets.all(20),
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
                        'El runtime, login, sesión y backend heredado permanecen intactos.',
                      ),
                      _buildBullet(
                        context,
                        'La base local conserva ownership operativo sobre el módulo.',
                      ),
                      _buildBullet(
                        context,
                        'Cada create/update/delete del CRUD deja trazabilidad en la outbox.',
                      ),
                      _buildBullet(
                        context,
                        'La ejecución de push y pull sigue siendo manual y controlada, con feedback UX mínimo consistente.',
                      ),
                      _buildBullet(
                        context,
                        'Los wrappers vacíos de listas siguen fuera de uso y quedan documentados para una fase UX posterior.',
                      ),
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
