import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/presentation/providers/outside_plant_mutations_provider.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/presentation/providers/outside_plant_providers.dart';
import 'package:mi_ipred_plantel_exterior/shared/widgets/info_card.dart';

class PlantelExteriorHomeView extends ConsumerWidget {
  const PlantelExteriorHomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final bool isCompact = MediaQuery.of(context).size.width < 700;
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
                'Phase 0.4.3 agrega el pipeline de pull remoto→local con reconciliación básica. La base local sigue siendo la fuente operativa, la cola sigue siendo el workload de push y el refresh remoto no pisa registros locales con cambios pendientes.',
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
                        'Push sync controlado',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Este disparador ejecuta un ciclo secuencial sobre la outbox local. Mientras no exista contrato backend real, el resultado sirve para validar pipeline y manejo de errores del módulo.',
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: isCompact
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                        child: FilledButton.icon(
                          onPressed: () async {
                            ref.invalidate(runOutsidePlantPushSyncProvider);
                            final messenger = ScaffoldMessenger.of(context);
                            final result = await ref.read(
                              runOutsidePlantPushSyncProvider.future,
                            );

                            if (!context.mounted) {
                              return;
                            }

                            messenger.showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Push ejecutado. Procesados: ${result.processedCount} | OK: ${result.successCount} | Error: ${result.errorCount}',
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.sync),
                          label: const Text('Intentar push'),
                        ),
                      ),
                    ],
                  ),
                ),
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
                        'Pull refresh controlado',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Este refresco trae estado remoto controlado y reconcilia solo registros locales sincronizados. Los registros locales en estado pending o error no son pisados automáticamente.',
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: isCompact
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            ref.invalidate(runOutsidePlantPullSyncProvider);
                            final messenger = ScaffoldMessenger.of(context);
                            final result = await ref.read(
                              runOutsidePlantPullSyncProvider.future,
                            );

                            if (!context.mounted) {
                              return;
                            }

                            messenger.showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Pull ejecutado. Remotos: ${result.fetchedCount} | Insertados: ${result.insertedCount} | Actualizados: ${result.updatedCount} | Omitidos: ${result.skippedCount}',
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.cloud_download_outlined),
                          label: const Text('Refrescar desde servidor'),
                        ),
                      ),
                    ],
                  ),
                ),
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
                        'El pull solo refresca registros locales sincronizados; pending y error quedan preservados.',
                      ),
                      _buildBullet(
                        context,
                        'Los wrappers vacíos de listas siguen fuera de uso y quedan documentados para una fase UX posterior.',
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
