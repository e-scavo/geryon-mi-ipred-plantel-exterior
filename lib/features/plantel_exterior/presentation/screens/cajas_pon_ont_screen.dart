import 'package:flutter/material.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/entities/caja_pon_ont.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/enums/sync_status.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/value_objects/geo_point.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/value_objects/outside_plant_id.dart';

class CajasPonOntScreen extends StatelessWidget {
  const CajasPonOntScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const caja = CajaPonOnt(
      id: OutsidePlantId('caja-pon-ont-001'),
      codigo: 'CP-001',
      descripcion: 'Caja PON / ONT principal del sector inicial',
      location: GeoPoint(
        latitude: -32.9442,
        longitude: -60.6505,
      ),
      syncStatus: SyncStatus.pending,
    );

    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Caja PON / ONT',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Phase 0.2.2 reemplaza el placeholder puro por una pantalla apoyada en una entidad real del dominio. '
                'Todavía no existe CRUD ni persistencia, pero el dominio ya está tipado y conectado a la UI.',
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              Card(
                elevation: 2,
                surfaceTintColor: theme.colorScheme.surface,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ejemplo de entidad real',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _InfoRow(
                        label: 'ID',
                        value: caja.id.value,
                      ),
                      _InfoRow(
                        label: 'Código',
                        value: caja.codigo,
                      ),
                      _InfoRow(
                        label: 'Descripción',
                        value: caja.descripcion,
                      ),
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
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 1,
                surfaceTintColor: theme.colorScheme.surface,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Qué habilita esta subfase',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 14),
                      const _BulletText(
                        'modelo real del dominio para Caja PON / ONT',
                      ),
                      const _BulletText(
                        'base para persistencia local futura',
                      ),
                      const _BulletText(
                        'base para sincronización futura',
                      ),
                      const _BulletText(
                        'pantalla ya apoyada en una entidad tipada y no solo en texto estático',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
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

class _BulletText extends StatelessWidget {
  final String text;

  const _BulletText(this.text);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Icon(
              Icons.check_circle_outline,
              size: 18,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text),
          ),
        ],
      ),
    );
  }
}
