import 'package:flutter/material.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/entities/botella_empalme.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/enums/sync_status.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/value_objects/geo_point.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/value_objects/outside_plant_id.dart';

class BotellasEmpalmeScreen extends StatelessWidget {
  const BotellasEmpalmeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const botella = BotellaEmpalme(
      id: OutsidePlantId('botella-empalme-001'),
      codigo: 'BE-001',
      descripcion: 'Botella de empalme troncal del sector inicial',
      location: GeoPoint(
        latitude: -32.9470,
        longitude: -60.6401,
      ),
      syncStatus: SyncStatus.synced,
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
                'Botella de Empalme',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Phase 0.2.2 incorpora la segunda entidad principal del dominio con un modelo real, '
                'evitando que la arquitectura quede sesgada solamente hacia Caja PON / ONT.',
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
                        value: botella.id.value,
                      ),
                      _InfoRow(
                        label: 'Código',
                        value: botella.codigo,
                      ),
                      _InfoRow(
                        label: 'Descripción',
                        value: botella.descripcion,
                      ),
                      _InfoRow(
                        label: 'Ubicación',
                        value: botella.location == null
                            ? 'Sin ubicación'
                            : '${botella.location!.latitude}, ${botella.location!.longitude}',
                      ),
                      _InfoRow(
                        label: 'Estado offline/sync',
                        value: _syncStatusLabel(botella.syncStatus),
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
                        'modelo real del dominio para Botella de Empalme',
                      ),
                      const _BulletText(
                        'contratos compartidos para repositorio futuro',
                      ),
                      const _BulletText(
                        'base común para offline y sync simple',
                      ),
                      const _BulletText(
                        'presencia real de ambas entidades del dominio desde la capa de código',
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
