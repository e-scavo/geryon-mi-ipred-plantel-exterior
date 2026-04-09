import 'package:flutter/material.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/enums/sync_status.dart';

class OutsidePlantSyncStatusBadge extends StatelessWidget {
  final SyncStatus status;

  const OutsidePlantSyncStatusBadge({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final config = _resolveConfig(theme, status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: config.backgroundColor,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: config.borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            config.icon,
            size: 16,
            color: config.foregroundColor,
          ),
          const SizedBox(width: 6),
          Text(
            config.label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: config.foregroundColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  _SyncBadgeConfig _resolveConfig(ThemeData theme, SyncStatus status) {
    switch (status) {
      case SyncStatus.pending:
        return _SyncBadgeConfig(
          label: 'Pendiente',
          icon: Icons.schedule,
          foregroundColor: theme.colorScheme.primary,
          backgroundColor: theme.colorScheme.primary.withOpacity(0.10),
          borderColor: theme.colorScheme.primary.withOpacity(0.22),
        );
      case SyncStatus.synced:
        return _SyncBadgeConfig(
          label: 'Sincronizado',
          icon: Icons.cloud_done_outlined,
          foregroundColor: Colors.green.shade700,
          backgroundColor: Colors.green.shade50,
          borderColor: Colors.green.shade200,
        );
      case SyncStatus.error:
        return _SyncBadgeConfig(
          label: 'Error',
          icon: Icons.error_outline,
          foregroundColor: theme.colorScheme.error,
          backgroundColor: theme.colorScheme.error.withOpacity(0.08),
          borderColor: theme.colorScheme.error.withOpacity(0.22),
        );
    }
  }
}

class _SyncBadgeConfig {
  final String label;
  final IconData icon;
  final Color foregroundColor;
  final Color backgroundColor;
  final Color borderColor;

  const _SyncBadgeConfig({
    required this.label,
    required this.icon,
    required this.foregroundColor,
    required this.backgroundColor,
    required this.borderColor,
  });
}
