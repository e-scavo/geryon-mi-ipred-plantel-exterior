import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/entities/botella_empalme.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/entities/caja_pon_ont.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/entities/outside_plant_relationship.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/presentation/providers/outside_plant_mutations_provider.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/presentation/providers/outside_plant_providers.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/presentation/widgets/outside_plant_relationship_editor_dialog.dart';

class OutsidePlantRelationshipsSection extends ConsumerWidget {
  final String sourceEntityType;
  final String sourceEntityId;
  final String sourceEntityLabel;

  const OutsidePlantRelationshipsSection({
    super.key,
    required this.sourceEntityType,
    required this.sourceEntityId,
    required this.sourceEntityLabel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final relationshipsAsync = ref.watch(
      outsidePlantRelationshipsByEntityProvider((
        entityType: sourceEntityType,
        entityId: sourceEntityId,
      )),
    );
    final cajasAsync = ref.watch(cajasPonOntListProvider);
    final botellasAsync = ref.watch(botellasEmpalmeListProvider);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Relaciones',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            FilledButton.icon(
              onPressed: () async {
                final created = await showDialog<bool>(
                  context: context,
                  builder: (context) => OutsidePlantRelationshipEditorDialog(
                    sourceEntityType: sourceEntityType,
                    sourceEntityId: sourceEntityId,
                    sourceEntityLabel: sourceEntityLabel,
                  ),
                );

                if (created == true && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Relación creada correctamente.'),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.link_outlined),
              label: const Text('Agregar relación'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        relationshipsAsync.when(
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: LinearProgressIndicator(),
          ),
          error: (error, _) => Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'No se pudieron cargar las relaciones. ${error.toString()}',
              style: TextStyle(
                color: theme.colorScheme.onErrorContainer,
              ),
            ),
          ),
          data: (relationships) {
            if (relationships.isEmpty) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Todavía no hay relaciones vinculadas a este elemento.',
                ),
              );
            }

            return Column(
              children: relationships
                  .map(
                    (relationship) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _RelationshipTile(
                        relationship: relationship,
                        sourceEntityType: sourceEntityType,
                        sourceEntityId: sourceEntityId,
                        cajas: cajasAsync.valueOrNull ?? const <CajaPonOnt>[],
                        botellas: botellasAsync.valueOrNull ??
                            const <BotellaEmpalme>[],
                      ),
                    ),
                  )
                  .toList(),
            );
          },
        ),
      ],
    );
  }
}

class _RelationshipTile extends ConsumerStatefulWidget {
  final OutsidePlantRelationship relationship;
  final String sourceEntityType;
  final String sourceEntityId;
  final List<CajaPonOnt> cajas;
  final List<BotellaEmpalme> botellas;

  const _RelationshipTile({
    required this.relationship,
    required this.sourceEntityType,
    required this.sourceEntityId,
    required this.cajas,
    required this.botellas,
  });

  @override
  ConsumerState<_RelationshipTile> createState() => _RelationshipTileState();
}

class _RelationshipTileState extends ConsumerState<_RelationshipTile> {
  bool _deleting = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final relationship = widget.relationship;
    final isSource = relationship.hasSource(
      entityType: widget.sourceEntityType,
      entityId: widget.sourceEntityId,
    );
    final otherType = isSource
        ? relationship.targetEntityType
        : relationship.sourceEntityType;
    final otherId = isSource
        ? relationship.targetEntityId
        : relationship.sourceEntityId;
    final arrow = isSource ? '→' : '←';
    final otherLabel = _resolveEntityLabel(
      entityType: otherType,
      entityId: otherId,
      cajas: widget.cajas,
      botellas: widget.botellas,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_humanizeRelationshipType(relationship.relationshipType)} $arrow $otherLabel',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Tipo destino: ${_humanizeEntityType(otherType)}',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Eliminar relación',
            onPressed: _deleting ? null : _handleDelete,
            icon: _deleting
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.delete_outline),
          ),
        ],
      ),
    );
  }

  String _resolveEntityLabel({
    required String entityType,
    required String entityId,
    required List<CajaPonOnt> cajas,
    required List<BotellaEmpalme> botellas,
  }) {
    if (entityType == 'caja_pon_ont') {
      for (final caja in cajas) {
        if (caja.id.value == entityId) {
          return 'Caja ${caja.codigo}';
        }
      }
      return 'Caja $entityId';
    }

    if (entityType == 'botella_empalme') {
      for (final botella in botellas) {
        if (botella.id.value == entityId) {
          return 'Botella ${botella.codigo}';
        }
      }
      return 'Botella $entityId';
    }

    return entityId;
  }

  String _humanizeRelationshipType(String value) {
    switch (value) {
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
        return value;
    }
  }

  String _humanizeEntityType(String value) {
    switch (value) {
      case 'caja_pon_ont':
        return 'Caja PON / ONT';
      case 'botella_empalme':
        return 'Botella de Empalme';
      default:
        return value;
    }
  }

  Future<void> _handleDelete() async {
    final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Eliminar relación'),
            content: const Text('¿Eliminar esta relación?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancelar'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Eliminar'),
              ),
            ],
          ),
        ) ??
        false;

    if (!confirmed) {
      return;
    }

    setState(() {
      _deleting = true;
    });

    try {
      await ref.read(
        deleteOutsidePlantRelationshipProvider(widget.relationship).future,
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Relación eliminada correctamente.'),
        ),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'No se pudo eliminar la relación. ${error.toString()}',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _deleting = false;
        });
      }
    }
  }
}
