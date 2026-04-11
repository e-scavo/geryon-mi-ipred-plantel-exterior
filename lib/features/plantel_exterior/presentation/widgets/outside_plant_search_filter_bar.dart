import 'package:flutter/material.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/presentation/state/outside_plant_search_filters.dart';

class OutsidePlantSearchFilterBar extends StatelessWidget {
  final OutsidePlantSearchFilters filters;
  final ValueChanged<String> onQueryChanged;
  final ValueChanged<String?> onOperationalStatusChanged;
  final ValueChanged<int?> onCriticalityChanged;
  final ValueChanged<String?> onSyncStatusChanged;
  final VoidCallback onClear;

  const OutsidePlantSearchFilterBar({
    super.key,
    required this.filters,
    required this.onQueryChanged,
    required this.onOperationalStatusChanged,
    required this.onCriticalityChanged,
    required this.onSyncStatusChanged,
    required this.onClear,
  });

  static const List<String> operationalStatusOptions = <String>[
    'activo',
    'pendiente',
    'en revisión',
    'dañado',
    'fuera de servicio',
  ];

  static const List<int> criticalityOptions = <int>[1, 2, 3, 4, 5];

  static const List<_SyncStatusOption> syncStatusOptions = <_SyncStatusOption>[
    _SyncStatusOption(value: 'pending', label: 'Pendiente'),
    _SyncStatusOption(value: 'synced', label: 'Sincronizado'),
    _SyncStatusOption(value: 'error', label: 'Error'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerLowest,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: TextEditingController(text: filters.query)
                ..selection = TextSelection.fromPosition(
                  TextPosition(offset: filters.query.length),
                ),
              onChanged: onQueryChanged,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Buscar por código, descripción, zona o referencia',
                border: const OutlineInputBorder(),
                isDense: true,
                suffixIcon: filters.query.trim().isEmpty
                    ? null
                    : IconButton(
                        onPressed: () => onQueryChanged(''),
                        icon: const Icon(Icons.clear),
                        tooltip: 'Limpiar búsqueda',
                      ),
              ),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SizedBox(
                  width: 220,
                  child: DropdownButtonFormField<String?>(
                    value: filters.operationalStatus,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: 'Estado operativo',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    items: const [
                      DropdownMenuItem<String?>(
                        value: null,
                        child: Text('Todos'),
                      ),
                      ...[
                        DropdownMenuItem<String?>(
                          value: 'activo',
                          child: Text('Activo'),
                        ),
                        DropdownMenuItem<String?>(
                          value: 'pendiente',
                          child: Text('Pendiente'),
                        ),
                        DropdownMenuItem<String?>(
                          value: 'en revisión',
                          child: Text('En revisión'),
                        ),
                        DropdownMenuItem<String?>(
                          value: 'dañado',
                          child: Text('Dañado'),
                        ),
                        DropdownMenuItem<String?>(
                          value: 'fuera de servicio',
                          child: Text('Fuera de servicio'),
                        ),
                      ],
                    ],
                    onChanged: onOperationalStatusChanged,
                  ),
                ),
                SizedBox(
                  width: 170,
                  child: DropdownButtonFormField<int?>(
                    value: filters.criticality,
                    decoration: const InputDecoration(
                      labelText: 'Criticidad',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    items: const [
                      DropdownMenuItem<int?>(
                        value: null,
                        child: Text('Todas'),
                      ),
                      DropdownMenuItem<int?>(value: 1, child: Text('1')),
                      DropdownMenuItem<int?>(value: 2, child: Text('2')),
                      DropdownMenuItem<int?>(value: 3, child: Text('3')),
                      DropdownMenuItem<int?>(value: 4, child: Text('4')),
                      DropdownMenuItem<int?>(value: 5, child: Text('5')),
                    ],
                    onChanged: onCriticalityChanged,
                  ),
                ),
                SizedBox(
                  width: 180,
                  child: DropdownButtonFormField<String?>(
                    value: filters.syncStatus,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: 'Estado sync',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    items: const [
                      DropdownMenuItem<String?>(
                        value: null,
                        child: Text('Todos'),
                      ),
                      DropdownMenuItem<String?>(
                        value: 'pending',
                        child: Text('Pendiente'),
                      ),
                      DropdownMenuItem<String?>(
                        value: 'synced',
                        child: Text('Sincronizado'),
                      ),
                      DropdownMenuItem<String?>(
                        value: 'error',
                        child: Text('Error'),
                      ),
                    ],
                    onChanged: onSyncStatusChanged,
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: onClear,
                  icon: const Icon(Icons.filter_alt_off_outlined),
                  label: const Text('Limpiar filtros'),
                ),
              ],
            ),
            if (filters.hasActiveFilters) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (filters.query.trim().isNotEmpty)
                    _ActiveFilterChip(label: 'Texto: ${filters.query.trim()}'),
                  if (filters.operationalStatus != null)
                    _ActiveFilterChip(
                      label: 'Estado: ${filters.operationalStatus}',
                    ),
                  if (filters.criticality != null)
                    _ActiveFilterChip(
                      label: 'Criticidad: ${filters.criticality}',
                    ),
                  if (filters.syncStatus != null)
                    _ActiveFilterChip(
                      label:
                          'Sync: ${_labelForSyncStatus(filters.syncStatus!)}',
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _labelForSyncStatus(String value) {
    for (final option in syncStatusOptions) {
      if (option.value == value) {
        return option.label;
      }
    }
    return value;
  }
}

class _ActiveFilterChip extends StatelessWidget {
  final String label;

  const _ActiveFilterChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Chip(label: Text(label));
  }
}

class _SyncStatusOption {
  final String value;
  final String label;

  const _SyncStatusOption({required this.value, required this.label});
}
