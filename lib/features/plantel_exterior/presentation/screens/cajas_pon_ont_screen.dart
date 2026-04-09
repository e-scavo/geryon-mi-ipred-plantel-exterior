import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/entities/caja_pon_ont.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/enums/sync_status.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/presentation/providers/outside_plant_mutations_provider.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/presentation/providers/outside_plant_providers.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/presentation/screens/cajas/caja_form_screen.dart';

class CajasPonOntScreen extends ConsumerWidget {
  const CajasPonOntScreen({super.key});

  Future<void> _openCreateForm(BuildContext context) async {
    final message = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (_) => const CajaFormScreen(),
      ),
    );

    if (message != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  Future<void> _openEditForm(
    BuildContext context,
    CajaPonOnt caja,
  ) async {
    final message = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (_) => CajaFormScreen(caja: caja),
      ),
    );

    if (message != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    CajaPonOnt caja,
  ) async {
    final confirmed = await showDialog<bool>(
          context: context,
          builder: (dialogContext) {
            return AlertDialog(
              title: const Text('Eliminar caja'),
              content: Text(
                '¿Querés eliminar la caja "${caja.codigo}"?\n\nEsta acción no se puede deshacer.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  child: const Text('Cancelar'),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                  child: const Text('Eliminar'),
                ),
              ],
            );
          },
        ) ??
        false;

    if (!confirmed) {
      return;
    }

    try {
      await ref.read(deleteCajaPonOntProvider(caja).future);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Caja "${caja.codigo}" eliminada correctamente.'),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'No se pudo eliminar la caja "${caja.codigo}". ${e.toString()}',
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cajasAsync = ref.watch(cajasPonOntListProvider);
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      'Cajas PON / ONT',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  FilledButton.icon(
                    onPressed: () => _openCreateForm(context),
                    icon: const Icon(Icons.add),
                    label: const Text('Nueva caja'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'Phase 0.3.4 mejora la experiencia de uso del CRUD con feedback visual más claro, validaciones más sólidas y acciones mejor comunicadas.',
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              cajasAsync.when(
                data: (items) {
                  if (items.isEmpty) {
                    return const _EmptyState(
                      title: 'Sin cajas registradas',
                      message:
                          'Todavía no hay cajas PON / ONT cargadas en la base local. Usá "Nueva caja" para crear la primera.',
                    );
                  }

                  return Column(
                    children: [
                      for (final caja in items) ...[
                        _CajaCard(
                          caja: caja,
                          onEdit: () => _openEditForm(context, caja),
                          onDelete: () => _confirmDelete(context, ref, caja),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ],
                  );
                },
                loading: () => const _LoadingState(
                  label: 'Cargando cajas PON / ONT...',
                ),
                error: (error, stack) => _ErrorState(
                  title: 'No se pudieron cargar las cajas PON / ONT',
                  message: error.toString(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CajaCard extends StatelessWidget {
  final CajaPonOnt caja;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _CajaCard({
    required this.caja,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      surfaceTintColor: theme.colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    caja.codigo,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    OutlinedButton.icon(
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit_outlined),
                      label: const Text('Editar'),
                    ),
                    OutlinedButton.icon(
                      onPressed: onDelete,
                      icon: const Icon(Icons.delete_outline),
                      label: const Text('Eliminar'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 14),
            _InfoRow(label: 'ID', value: caja.id.value),
            _InfoRow(label: 'Descripción', value: caja.descripcion),
            _InfoRow(
              label: 'Ubicación',
              value: caja.location == null
                  ? 'Sin ubicación'
                  : '${caja.location!.latitude}, ${caja.location!.longitude}',
            ),
            _InfoRow(
              label: 'Estado offline/sync',
              value: _syncStatusLabel(caja.syncStatus),
            ),
            _InfoRow(
              label: 'Creado',
              value: caja.createdAt?.toIso8601String() ?? 'Sin dato',
            ),
            _InfoRow(
              label: 'Actualizado',
              value: caja.updatedAt?.toIso8601String() ?? 'Sin dato',
            ),
          ],
        ),
      ),
    );
  }

  String _syncStatusLabel(SyncStatus status) {
    switch (status) {
      case SyncStatus.pending:
        return 'Pendiente';
      case SyncStatus.synced:
        return 'Sincronizado';
      case SyncStatus.error:
        return 'Error';
    }
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 170,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  final String label;

  const _LoadingState({
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(),
            ),
            const SizedBox(height: 16),
            Text(
              label,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String title;
  final String message;

  const _EmptyState({
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(Icons.inbox_outlined, size: 42),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String title;
  final String message;

  const _ErrorState({
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(Icons.error_outline, size: 42),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
