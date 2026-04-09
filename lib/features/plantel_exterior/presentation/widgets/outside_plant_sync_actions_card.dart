import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/presentation/providers/outside_plant_mutations_provider.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/presentation/providers/outside_plant_sync_ui_provider.dart';

class OutsidePlantSyncActionsCard extends ConsumerWidget {
  const OutsidePlantSyncActionsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final bool isCompact = MediaQuery.of(context).size.width < 700;
    final syncUiState = ref.watch(outsidePlantSyncUiProvider);
    final bool isBusy = syncUiState.isPushRunning || syncUiState.isPullRunning;

    return Card(
      elevation: 2,
      surfaceTintColor: theme.colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Acciones de sincronización',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Las acciones siguen siendo manuales y controladas. Mientras una ejecución está corriendo, la otra queda bloqueada para evitar ruido UX y resultados cruzados.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: isCompact ? WrapAlignment.start : WrapAlignment.end,
              children: [
                FilledButton.icon(
                  onPressed: isBusy
                      ? null
                      : () async {
                          final messenger = ScaffoldMessenger.of(context);
                          final result = await ref.refresh(
                            runOutsidePlantPushSyncActionProvider.future,
                          );

                          if (!context.mounted) {
                            return;
                          }

                          messenger.showSnackBar(
                            SnackBar(content: Text(result)),
                          );
                        },
                  icon: syncUiState.isPushRunning
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.cloud_upload_outlined),
                  label: Text(
                    syncUiState.isPushRunning
                        ? 'Ejecutando push...'
                        : 'Intentar push',
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: isBusy
                      ? null
                      : () async {
                          final messenger = ScaffoldMessenger.of(context);
                          final result = await ref.refresh(
                            runOutsidePlantPullSyncActionProvider.future,
                          );

                          if (!context.mounted) {
                            return;
                          }

                          messenger.showSnackBar(
                            SnackBar(content: Text(result)),
                          );
                        },
                  icon: syncUiState.isPullRunning
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.cloud_download_outlined),
                  label: Text(
                    syncUiState.isPullRunning
                        ? 'Ejecutando pull...'
                        : 'Refrescar desde servidor',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
