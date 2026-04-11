import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/entities/caja_pon_ont.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/presentation/providers/outside_plant_mutations_provider.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/presentation/providers/outside_plant_providers.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/presentation/state/outside_plant_search_filters.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/presentation/widgets/outside_plant_search_filter_bar.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/presentation/screens/cajas/caja_form_screen.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/presentation/widgets/outside_plant_sync_status_badge.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/presentation/widgets/outside_plant_detail_dialog.dart';

class CajasPonOntScreen extends ConsumerWidget {
  const CajasPonOntScreen({super.key});

  static const OutsidePlantSearchFilters _emptyFilters =
      OutsidePlantSearchFilters.empty;

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

  Future<void> _openDetail(
    BuildContext context,
    CajaPonOnt caja,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (_) => OutsidePlantDetailDialog.forCaja(caja),
    );
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
    final cajasAsync = ref.watch(filteredCajasPonOntProvider);
    final filters = ref.watch(cajasSearchFiltersProvider);
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
                'Phase 0.5.1 amplía el valor operativo del listado: cada registro mantiene el estado de sync visible y suma contexto técnico local como estado operativo, criticidad y ubicación lógica.',
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              OutsidePlantSearchFilterBar(
                filters: filters,
                onQueryChanged: (value) {
                  ref.read(cajasSearchFiltersProvider.notifier).state =
                      filters.copyWith(query: value);
                },
                onOperationalStatusChanged: (value) {
                  ref.read(cajasSearchFiltersProvider.notifier).state =
                      filters.copyWith(operationalStatus: value);
                },
                onCriticalityChanged: (value) {
                  ref.read(cajasSearchFiltersProvider.notifier).state =
                      filters.copyWith(criticality: value);
                },
                onSyncStatusChanged: (value) {
                  ref.read(cajasSearchFiltersProvider.notifier).state =
                      filters.copyWith(syncStatus: value);
                },
                onClear: () {
                  ref.read(cajasSearchFiltersProvider.notifier).state =
                      _emptyFilters;
                },
              ),
              const SizedBox(height: 20),
              cajasAsync.when(
                data: (items) {
                  if (items.isEmpty) {
                    return _EmptyState(
                      title: filters.hasActiveFilters
                          ? 'Sin resultados para los filtros actuales'
                          : 'Sin cajas registradas',
                      message: filters.hasActiveFilters
                          ? 'No se encontraron cajas con los criterios seleccionados. Podés ajustar o limpiar los filtros.'
                          : 'Todavía no hay cajas PON / ONT cargadas en la base local. Usá "Nueva caja" para crear la primera.',
                    );
                  }

                  return Column(
                    children: [
                      for (final caja in items) ...[
                        _CajaCard(
                          caja: caja,
                          onInspect: () => _openDetail(context, caja),
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
  final VoidCallback onInspect;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _CajaCard({
    required this.caja,
    required this.onInspect,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final operationalSummary = _buildOperationalSummary(caja);

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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        caja.codigo,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (operationalSummary.isNotEmpty)
                        Text(
                          operationalSummary,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    OutsidePlantSyncStatusBadge(status: caja.syncStatus),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        OutlinedButton.icon(
                          onPressed: onInspect,
                          icon: const Icon(Icons.visibility_outlined),
                          label: const Text('Ver detalle'),
                        ),
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
              ],
            ),
            const SizedBox(height: 14),
            _InfoRow(label: 'ID', value: caja.id.value),
            _InfoRow(label: 'Descripción', value: caja.descripcion),
            if (_hasValue(caja.codigoTecnico))
              _InfoRow(label: 'Código técnico', value: caja.codigoTecnico!),
            if (_hasValue(caja.referenciaExterna))
              _InfoRow(
                label: 'Referencia externa',
                value: caja.referenciaExterna!,
              ),
            _InfoRow(
              label: 'Estado operativo',
              value: caja.estadoOperativo ?? 'Sin dato',
            ),
            _InfoRow(
              label: 'Criticidad',
              value: caja.criticidad?.toString() ?? 'Sin dato',
            ),
            _InfoRow(
              label: 'Zona / Sector / Tramo',
              value: _buildZoneText(caja.zona, caja.sector, caja.tramo),
            ),
            if (_hasValue(caja.observacionesTecnicas))
              _InfoRow(
                label: 'Observaciones técnicas',
                value: caja.observacionesTecnicas!,
              ),
            _InfoRow(
              label: 'Ubicación',
              value: caja.location == null
                  ? 'Sin ubicación'
                  : '${caja.location!.latitude}, ${caja.location!.longitude}',
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
}

String _buildOperationalSummary(CajaPonOnt caja) {
  final parts = <String>[];

  if (_hasValue(caja.estadoOperativo)) {
    parts.add(caja.estadoOperativo!);
  }
  if (caja.criticidad != null) {
    parts.add('Criticidad ${caja.criticidad}');
  }

  final zoneText = _buildZoneText(caja.zona, caja.sector, caja.tramo);
  if (zoneText != 'Sin dato') {
    parts.add(zoneText);
  }

  if (_hasValue(caja.codigoTecnico)) {
    parts.add('Técnico ${caja.codigoTecnico}');
  }

  return parts.join(' • ');
}

bool _hasValue(String? value) => value != null && value.trim().isNotEmpty;

String _buildZoneText(String? zona, String? sector, String? tramo) {
  final parts = [zona, sector, tramo]
      .where((item) => item != null && item.trim().isNotEmpty)
      .cast<String>()
      .toList();

  if (parts.isEmpty) {
    return 'Sin dato';
  }

  return parts.join(' / ');
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
