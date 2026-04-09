import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/models/outside_plant_pull_cycle_result.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/models/outside_plant_push_cycle_result.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/presentation/providers/outside_plant_mutations_provider.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/presentation/providers/outside_plant_sync_ui_provider.dart';

class OutsidePlantSyncActionsCard extends ConsumerWidget {
  const OutsidePlantSyncActionsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final bool isCompact = MediaQuery.of(context).size.width < 700;
    final syncUiState = ref.watch(outsidePlantSyncUiProvider);
    final bool isBusy = syncUiState.isBusy;

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
                  onPressed: isBusy ? null : () => _runPush(context, ref),
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
                  onPressed: isBusy ? null : () => _runPull(context, ref),
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

  Future<void> _runPush(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    final syncUiNotifier = ref.read(outsidePlantSyncUiProvider.notifier);

    if (!syncUiNotifier.startPush()) {
      _showSnackBar(
        messenger,
        'Ya existe una sincronización en curso. Esperá a que termine antes de ejecutar un push.',
      );
      return;
    }

    try {
      final OutsidePlantPushCycleResult result =
          await ref.refresh(runOutsidePlantPushSyncProvider.future);
      syncUiNotifier.completePush(result);

      if (!context.mounted) {
        return;
      }

      _showSnackBar(
        messenger,
        'Push ejecutado. Procesados: ${result.processedCount} | OK: ${result.successCount} | Error: ${result.errorCount}',
      );
    } catch (error) {
      syncUiNotifier.failPush(error);

      if (!context.mounted) {
        return;
      }

      _showSnackBar(
        messenger,
        'Push falló. ${error.toString()}',
      );
    }
  }

  Future<void> _runPull(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    final syncUiNotifier = ref.read(outsidePlantSyncUiProvider.notifier);

    if (!syncUiNotifier.startPull()) {
      _showSnackBar(
        messenger,
        'Ya existe una sincronización en curso. Esperá a que termine antes de ejecutar un pull.',
      );
      return;
    }

    try {
      final OutsidePlantPullCycleResult result =
          await ref.refresh(runOutsidePlantPullSyncProvider.future);
      syncUiNotifier.completePull(result);

      if (!context.mounted) {
        return;
      }

      _showSnackBar(
        messenger,
        'Pull ejecutado. Remotos: ${result.fetchedCount} | Insertados: ${result.insertedCount} | Actualizados: ${result.updatedCount} | Omitidos: ${result.skippedCount}',
      );
    } catch (error) {
      syncUiNotifier.failPull(error);

      if (!context.mounted) {
        return;
      }

      _showSnackBar(
        messenger,
        'Pull falló. ${error.toString()}',
      );
    }
  }

  void _showSnackBar(ScaffoldMessengerState messenger, String message) {
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
  }
}
