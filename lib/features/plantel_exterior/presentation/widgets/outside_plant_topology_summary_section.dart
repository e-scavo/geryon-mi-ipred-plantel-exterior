import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/presentation/models/outside_plant_topology_summary.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/presentation/providers/outside_plant_providers.dart';

class OutsidePlantTopologySummarySection extends ConsumerWidget {
  final String entityType;
  final String entityId;
  final Future<void> Function(OutsidePlantTopologyNeighbor neighbor)? onOpenNeighbor;

  const OutsidePlantTopologySummarySection({
    super.key,
    required this.entityType,
    required this.entityId,
    this.onOpenNeighbor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topologyAsync = ref.watch(
      outsidePlantTopologySummaryProvider(
        (entityType: entityType, entityId: entityId),
      ),
    );
    final theme = Theme.of(context);

    return topologyAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: LinearProgressIndicator(),
      ),
      error: (error, _) => Text('No se pudo construir el resumen topológico. $error'),
      data: (topology) {
        if (topology.totalRelationships == 0) {
          return const Text('No hay conectividad registrada para este elemento.');
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _TopologyChip(label: 'Totales', value: topology.totalRelationships.toString()),
                _TopologyChip(label: 'Entrantes', value: topology.incomingCount.toString()),
                _TopologyChip(label: 'Salientes', value: topology.outgoingCount.toString()),
                _TopologyChip(label: 'Cajas', value: topology.connectedCajasCount.toString()),
                _TopologyChip(label: 'Botellas', value: topology.connectedBotellasCount.toString()),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Tipos de vínculo',
              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: topology.relationshipTypeCounts.entries
                  .map(
                    (entry) => Chip(
                      label: Text('${_humanizeRelationshipType(entry.key)}: ${entry.value}'),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 16),
            Text(
              'Vecinos inmediatos',
              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            ...topology.neighbors.map(
              (neighbor) => Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  title: Text(
                    '${neighbor.direction == 'outgoing' ? '→' : '←'} ${_humanizeRelationshipType(neighbor.relationshipType)}',
                  ),
                  subtitle: Text(neighbor.otherEntityLabel),
                  trailing: onOpenNeighbor == null
                      ? null
                      : TextButton(
                          onPressed: () => onOpenNeighbor!(neighbor),
                          child: const Text('Ver'),
                        ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _TopologyChip extends StatelessWidget {
  final String label;
  final String value;

  const _TopologyChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.textTheme.labelMedium),
          const SizedBox(height: 2),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

String _humanizeRelationshipType(String relationshipType) {
  switch (relationshipType) {
    case 'asociacion':
      return 'Asociación';
    case 'dependencia':
      return 'Dependencia';
    case 'derivacion':
      return 'Derivación';
    case 'continuidad':
      return 'Continuidad';
    case 'referencia':
      return 'Referencia';
    default:
      return relationshipType;
  }
}
