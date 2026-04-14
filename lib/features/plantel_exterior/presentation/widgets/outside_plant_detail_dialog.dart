import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/entities/botella_empalme.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/entities/caja_pon_ont.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/entities/outside_plant_relationship.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/presentation/models/outside_plant_topology_summary.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/presentation/providers/outside_plant_providers.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/presentation/widgets/outside_plant_detail_section.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/presentation/widgets/outside_plant_metadata_row.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/presentation/widgets/outside_plant_sync_status_badge.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/presentation/widgets/outside_plant_topology_summary_section.dart';

class OutsidePlantDetailDialog extends ConsumerWidget {
  final String entityType;
  final String entityId;
  final String codigo;
  final String descripcion;
  final String? codigoTecnico;
  final String? referenciaExterna;
  final String? observacionesTecnicas;
  final String? estadoOperativo;
  final int? criticidad;
  final String? zona;
  final String? sector;
  final String? tramo;
  final double? latitude;
  final double? longitude;
  final dynamic syncStatus;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const OutsidePlantDetailDialog._({
    required this.entityType,
    required this.entityId,
    required this.codigo,
    required this.descripcion,
    required this.codigoTecnico,
    required this.referenciaExterna,
    required this.observacionesTecnicas,
    required this.estadoOperativo,
    required this.criticidad,
    required this.zona,
    required this.sector,
    required this.tramo,
    required this.latitude,
    required this.longitude,
    required this.syncStatus,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OutsidePlantDetailDialog.forCaja(CajaPonOnt caja) {
    return OutsidePlantDetailDialog._(
      entityType: 'caja_pon_ont',
      entityId: caja.id.value,
      codigo: caja.codigo,
      descripcion: caja.descripcion,
      codigoTecnico: caja.codigoTecnico,
      referenciaExterna: caja.referenciaExterna,
      observacionesTecnicas: caja.observacionesTecnicas,
      estadoOperativo: caja.estadoOperativo,
      criticidad: caja.criticidad,
      zona: caja.zona,
      sector: caja.sector,
      tramo: caja.tramo,
      latitude: caja.location?.latitude,
      longitude: caja.location?.longitude,
      syncStatus: caja.syncStatus,
      createdAt: caja.createdAt,
      updatedAt: caja.updatedAt,
    );
  }

  factory OutsidePlantDetailDialog.forBotella(BotellaEmpalme botella) {
    return OutsidePlantDetailDialog._(
      entityType: 'botella_empalme',
      entityId: botella.id.value,
      codigo: botella.codigo,
      descripcion: botella.descripcion,
      codigoTecnico: botella.codigoTecnico,
      referenciaExterna: botella.referenciaExterna,
      observacionesTecnicas: botella.observacionesTecnicas,
      estadoOperativo: botella.estadoOperativo,
      criticidad: botella.criticidad,
      zona: botella.zona,
      sector: botella.sector,
      tramo: botella.tramo,
      latitude: botella.location?.latitude,
      longitude: botella.location?.longitude,
      syncStatus: botella.syncStatus,
      createdAt: botella.createdAt,
      updatedAt: botella.updatedAt,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final relationshipsAsync = ref.watch(
      outsidePlantRelationshipsByEntityProvider((
        entityType: entityType,
        entityId: entityId,
      )),
    );
    final cajasAsync = ref.watch(cajasPonOntListProvider);
    final botellasAsync = ref.watch(botellasEmpalmeListProvider);

    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 760, maxHeight: 720),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
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
                            entityType == 'caja_pon_ont'
                                ? 'Detalle de caja'
                                : 'Detalle de botella',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            codigo,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(descripcion),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        OutsidePlantSyncStatusBadge(status: syncStatus),
                        const SizedBox(height: 12),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close),
                          tooltip: 'Cerrar',
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                OutsidePlantDetailSection(
                  title: 'Estado operativo',
                  children: [
                    OutsidePlantMetadataRow(
                      label: 'Estado',
                      value: estadoOperativo ?? 'Sin dato',
                    ),
                    OutsidePlantMetadataRow(
                      label: 'Criticidad',
                      value: criticidad?.toString() ?? 'Sin dato',
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                OutsidePlantDetailSection(
                  title: 'Contexto técnico',
                  children: [
                    if (_hasValue(codigoTecnico))
                      OutsidePlantMetadataRow(
                          label: 'Código técnico', value: codigoTecnico!),
                    if (_hasValue(referenciaExterna))
                      OutsidePlantMetadataRow(
                          label: 'Referencia externa',
                          value: referenciaExterna!),
                    OutsidePlantMetadataRow(
                      label: 'Observaciones',
                      value:
                          observacionesTecnicas ?? 'Sin observaciones técnicas',
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                OutsidePlantDetailSection(
                  title: 'Ubicación operativa',
                  children: [
                    OutsidePlantMetadataRow(
                      label: 'Zona / Sector / Tramo',
                      value: _buildZoneText(zona, sector, tramo),
                    ),
                    OutsidePlantMetadataRow(
                      label: 'Ubicación',
                      value: latitude == null || longitude == null
                          ? 'Sin ubicación'
                          : '$latitude, $longitude',
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                OutsidePlantDetailSection(
                  title: 'Relaciones',
                  children: [
                    relationshipsAsync.when(
                      loading: () => const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: LinearProgressIndicator(),
                      ),
                      error: (error, _) =>
                          Text('No se pudieron cargar las relaciones. $error'),
                      data: (relationships) {
                        final cajas =
                            cajasAsync.valueOrNull ?? const <CajaPonOnt>[];
                        final botellas = botellasAsync.valueOrNull ??
                            const <BotellaEmpalme>[];
                        if (relationships.isEmpty) {
                          return const Text(
                              'No hay relaciones vinculadas a este elemento.');
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: relationships
                              .map((relationship) => Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: _ReadOnlyRelationshipTile(
                                      relationship: relationship,
                                      currentEntityType: entityType,
                                      currentEntityId: entityId,
                                      cajas: cajas,
                                      botellas: botellas,
                                    ),
                                  ))
                              .toList(),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                OutsidePlantDetailSection(
                  title: 'Conectividad',
                  children: [
                    OutsidePlantTopologySummarySection(
                      entityType: entityType,
                      entityId: entityId,
                      onOpenNeighbor: (neighbor) => _openNeighborDetail(
                        context: context,
                        cajas: cajasAsync.valueOrNull ?? const <CajaPonOnt>[],
                        botellas: botellasAsync.valueOrNull ??
                            const <BotellaEmpalme>[],
                        neighbor: neighbor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                OutsidePlantDetailSection(
                  title: 'Metadata',
                  children: [
                    OutsidePlantMetadataRow(label: 'ID', value: entityId),
                    OutsidePlantMetadataRow(
                      label: 'Creado',
                      value: createdAt?.toIso8601String() ?? 'Sin dato',
                    ),
                    OutsidePlantMetadataRow(
                      label: 'Actualizado',
                      value: updatedAt?.toIso8601String() ?? 'Sin dato',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _openNeighborDetail({
    required BuildContext context,
    required List<CajaPonOnt> cajas,
    required List<BotellaEmpalme> botellas,
    required OutsidePlantTopologyNeighbor neighbor,
  }) async {
    Navigator.of(context).pop();

    if (neighbor.otherEntityType == 'caja_pon_ont') {
      for (final caja in cajas) {
        if (caja.id.value == neighbor.otherEntityId) {
          await showDialog<void>(
            context: context,
            builder: (_) => OutsidePlantDetailDialog.forCaja(caja),
          );
          return;
        }
      }
    }

    if (neighbor.otherEntityType == 'botella_empalme') {
      for (final botella in botellas) {
        if (botella.id.value == neighbor.otherEntityId) {
          await showDialog<void>(
            context: context,
            builder: (_) => OutsidePlantDetailDialog.forBotella(botella),
          );
          return;
        }
      }
    }
  }

  static bool _hasValue(String? value) =>
      value != null && value.trim().isNotEmpty;

  static String _buildZoneText(String? zona, String? sector, String? tramo) {
    final values = [zona, sector, tramo]
        .whereType<String>()
        .map((value) => value.trim())
        .where((value) => value.isNotEmpty)
        .toList();
    return values.isEmpty ? 'Sin dato' : values.join(' / ');
  }
}

class _ReadOnlyRelationshipTile extends StatelessWidget {
  final OutsidePlantRelationship relationship;
  final String currentEntityType;
  final String currentEntityId;
  final List<CajaPonOnt> cajas;
  final List<BotellaEmpalme> botellas;

  const _ReadOnlyRelationshipTile({
    required this.relationship,
    required this.currentEntityType,
    required this.currentEntityId,
    required this.cajas,
    required this.botellas,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSource = relationship.hasSource(
      entityType: currentEntityType,
      entityId: currentEntityId,
    );
    final arrow = isSource ? '→' : '←';
    final otherType = isSource
        ? relationship.targetEntityType
        : relationship.sourceEntityType;
    final otherId =
        isSource ? relationship.targetEntityId : relationship.sourceEntityId;
    final otherLabel = _resolveEntityLabel(otherType, otherId);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor),
      ),
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
          Text('Entidad vinculada: ${_humanizeEntityType(otherType)}'),
        ],
      ),
    );
  }

  String _resolveEntityLabel(String entityType, String entityId) {
    if (entityType == 'caja_pon_ont') {
      for (final caja in cajas) {
        if (caja.id.value == entityId) return caja.codigo;
      }
      return 'Caja $entityId';
    }
    if (entityType == 'botella_empalme') {
      for (final botella in botellas) {
        if (botella.id.value == entityId) return botella.codigo;
      }
      return 'Botella $entityId';
    }
    return entityId;
  }

  String _humanizeEntityType(String entityType) {
    switch (entityType) {
      case 'caja_pon_ont':
        return 'Caja PON / ONT';
      case 'botella_empalme':
        return 'Botella de Empalme';
      default:
        return entityType;
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
}
