import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/presentation/providers/outside_plant_providers.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/presentation/providers/outside_plant_sync_ui_provider.dart';

class OutsidePlantSyncSummaryCard extends ConsumerWidget {
  const OutsidePlantSyncSummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final pendingSyncAsync = ref.watch(outsidePlantPendingSyncCountProvider);
    final syncUiState = ref.watch(outsidePlantSyncUiProvider);

    return Card(
      elevation: 2,
      surfaceTintColor: theme.colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Estado de sincronización',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'El módulo sigue trabajando sobre la base local. El resumen de abajo te muestra pendientes actuales y el último resultado visible de push/pull.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _MetricBox(
                  label: 'Pendientes',
                  value: pendingSyncAsync.when(
                    data: (count) => '$count',
                    loading: () => '...',
                    error: (_, __) => 'Error',
                  ),
                  icon: Icons.pending_actions_outlined,
                ),
                _MetricBox(
                  label: 'Último push',
                  value: syncUiState.lastPushSummary ?? 'Sin ejecución reciente',
                  icon: Icons.cloud_upload_outlined,
                  isWide: true,
                ),
                _MetricBox(
                  label: 'Último pull',
                  value: syncUiState.lastPullSummary ?? 'Sin ejecución reciente',
                  icon: Icons.cloud_download_outlined,
                  isWide: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricBox extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool isWide;

  const _MetricBox({
    required this.label,
    required this.value,
    required this.icon,
    this.isWide = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      constraints: BoxConstraints(minWidth: isWide ? 260 : 180),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.4),
        border: Border.all(
          color: theme.colorScheme.outlineVariant,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 18,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
