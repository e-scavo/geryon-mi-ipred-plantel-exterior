import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/presentation/providers/outside_plant_sync_ui_provider.dart';

class OutsidePlantSyncFeedbackBanner extends ConsumerWidget {
  const OutsidePlantSyncFeedbackBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final syncUiState = ref.watch(outsidePlantSyncUiProvider);

    if (syncUiState.lastErrorMessage == null &&
        syncUiState.lastPushSummary == null &&
        syncUiState.lastPullSummary == null) {
      return const SizedBox.shrink();
    }

    final bool hasError = syncUiState.lastErrorMessage != null;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: hasError
            ? theme.colorScheme.errorContainer.withOpacity(0.55)
            : theme.colorScheme.primaryContainer.withOpacity(0.55),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: hasError
              ? theme.colorScheme.error.withOpacity(0.22)
              : theme.colorScheme.primary.withOpacity(0.20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                hasError ? Icons.error_outline : Icons.info_outline,
                color: hasError
                    ? theme.colorScheme.error
                    : theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                hasError ? 'Último resultado con observaciones' : 'Resumen reciente',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          if (syncUiState.lastPushSummary != null) ...[
            const SizedBox(height: 10),
            Text(syncUiState.lastPushSummary!),
          ],
          if (syncUiState.lastPullSummary != null) ...[
            const SizedBox(height: 6),
            Text(syncUiState.lastPullSummary!),
          ],
          if (syncUiState.lastErrorMessage != null) ...[
            const SizedBox(height: 10),
            Text(
              syncUiState.lastErrorMessage!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
