import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/application/providers/outside_plant_providers.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/entities/caja_pon_ont.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/enums/sync_status.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/presentation/screens/cajas/caja_form_screen.dart';

class CajasPonOntScreen extends ConsumerWidget {
  const CajasPonOntScreen({super.key});

  Future<void> _openCreateForm(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const CajaFormScreen(),
      ),
    );
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
                'Phase 0.3.1 incorpora alta real de cajas PON / ONT con formulario y persistencia directa sobre el repositorio local.',
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              cajasAsync.when(
                data: (items) {
                  if (items.isEmpty) {
                    return const _EmptyState(
                      title: 'Sin cajas registradas',
                      message:
                          'Todavía no hay cajas PON / ONT cargadas en la base local.',
                    );
                  }

                  return Column(
                    children: [
                      for (final caja in items) ...[
                        _CajaCard(caja: caja),
                        const SizedBox(height: 16),
                      ],
                    ],
                  );
                },
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (error, stack) => _ErrorState(
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

  const _CajaCard({
    required this.caja,
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
            Text(
              caja.codigo,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
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
  final String message;

  const _ErrorState({
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
            const Text(
              'No se pudieron cargar las cajas PON / ONT',
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
