import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/entities/botella_empalme.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/entities/caja_pon_ont.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/entities/outside_plant_relationship.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/enums/sync_status.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/presentation/providers/outside_plant_mutations_provider.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/presentation/providers/outside_plant_providers.dart';

class OutsidePlantRelationshipEditorDialog extends ConsumerStatefulWidget {
  final String sourceEntityType;
  final String sourceEntityId;
  final String sourceEntityLabel;

  const OutsidePlantRelationshipEditorDialog({
    super.key,
    required this.sourceEntityType,
    required this.sourceEntityId,
    required this.sourceEntityLabel,
  });

  @override
  ConsumerState<OutsidePlantRelationshipEditorDialog> createState() =>
      _OutsidePlantRelationshipEditorDialogState();
}

class _OutsidePlantRelationshipEditorDialogState
    extends ConsumerState<OutsidePlantRelationshipEditorDialog> {
  static const List<_RelationshipTypeOption> _relationshipTypes = [
    _RelationshipTypeOption(value: 'asociacion', label: 'Asociación'),
    _RelationshipTypeOption(value: 'dependencia', label: 'Dependencia'),
    _RelationshipTypeOption(value: 'derivacion', label: 'Derivación'),
    _RelationshipTypeOption(value: 'continuidad', label: 'Continuidad'),
    _RelationshipTypeOption(value: 'referencia', label: 'Referencia'),
  ];

  final _formKey = GlobalKey<FormState>();

  String _targetEntityType = 'caja_pon_ont';
  String? _targetEntityId;
  String? _relationshipType;
  bool _saving = false;
  String? _errorText;

  @override
  Widget build(BuildContext context) {
    final cajasAsync = ref.watch(cajasPonOntListProvider);
    final botellasAsync = ref.watch(botellasEmpalmeListProvider);
    final targetOptions = _resolveTargetOptions(
      cajasAsync: cajasAsync,
      botellasAsync: botellasAsync,
    );

    if (_targetEntityId != null &&
        targetOptions.every((option) => option.id != _targetEntityId)) {
      _targetEntityId = null;
    }

    return AlertDialog(
      title: const Text('Agregar relación'),
      content: SizedBox(
        width: 520,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Origen: ${widget.sourceEntityLabel}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _targetEntityType,
                decoration: const InputDecoration(
                  labelText: 'Tipo de entidad destino',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'caja_pon_ont',
                    child: Text('Caja PON / ONT'),
                  ),
                  DropdownMenuItem(
                    value: 'botella_empalme',
                    child: Text('Botella de Empalme'),
                  ),
                ],
                onChanged: _saving
                    ? null
                    : (value) {
                        if (value == null) {
                          return;
                        }
                        setState(() {
                          _targetEntityType = value;
                          _targetEntityId = null;
                          _errorText = null;
                        });
                      },
              ),
              const SizedBox(height: 16),
              if (targetOptions.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  ),
                  child: const Text(
                    'No hay entidades disponibles para ese tipo de destino.',
                  ),
                )
              else
                DropdownButtonFormField<String>(
                  value: _targetEntityId,
                  decoration: const InputDecoration(
                    labelText: 'Entidad destino',
                    border: OutlineInputBorder(),
                  ),
                  items: targetOptions
                      .map(
                        (option) => DropdownMenuItem<String>(
                          value: option.id,
                          child: Text(option.label),
                        ),
                      )
                      .toList(),
                  onChanged: _saving
                      ? null
                      : (value) {
                          setState(() {
                            _targetEntityId = value;
                            _errorText = null;
                          });
                        },
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Seleccioná una entidad destino.';
                    }
                    return null;
                  },
                ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _relationshipType,
                decoration: const InputDecoration(
                  labelText: 'Tipo de relación',
                  border: OutlineInputBorder(),
                ),
                items: _relationshipTypes
                    .map(
                      (option) => DropdownMenuItem<String>(
                        value: option.value,
                        child: Text(option.label),
                      ),
                    )
                    .toList(),
                onChanged: _saving
                    ? null
                    : (value) {
                        setState(() {
                          _relationshipType = value;
                          _errorText = null;
                        });
                      },
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Seleccioná un tipo de relación.';
                  }
                  return null;
                },
              ),
              if (_errorText != null) ...[
                const SizedBox(height: 16),
                Text(
                  _errorText!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: _saving || targetOptions.isEmpty ? null : _handleSave,
          child: _saving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Guardar relación'),
        ),
      ],
    );
  }

  List<_TargetOption> _resolveTargetOptions({
    required AsyncValue<List<CajaPonOnt>> cajasAsync,
    required AsyncValue<List<BotellaEmpalme>> botellasAsync,
  }) {
    if (_targetEntityType == 'caja_pon_ont') {
      final cajas = cajasAsync.valueOrNull ?? const <CajaPonOnt>[];
      return cajas
          .map(
            (caja) => _TargetOption(
              id: caja.id.value,
              label: 'Caja ${caja.codigo}',
            ),
          )
          .toList();
    }

    final botellas = botellasAsync.valueOrNull ?? const <BotellaEmpalme>[];
    return botellas
        .map(
          (botella) => _TargetOption(
            id: botella.id.value,
            label: 'Botella ${botella.codigo}',
          ),
        )
        .toList();
  }

  Future<void> _handleSave() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_targetEntityId == null || _relationshipType == null) {
      return;
    }

    if (widget.sourceEntityType == _targetEntityType &&
        widget.sourceEntityId == _targetEntityId) {
      setState(() {
        _errorText = 'No se puede crear una autorrelación.';
      });
      return;
    }

    setState(() {
      _saving = true;
      _errorText = null;
    });

    try {
      final now = DateTime.now();
      final relationship = OutsidePlantRelationship(
        id: 'relationship-${now.microsecondsSinceEpoch}',
        sourceEntityType: widget.sourceEntityType,
        sourceEntityId: widget.sourceEntityId,
        targetEntityType: _targetEntityType,
        targetEntityId: _targetEntityId!,
        relationshipType: _relationshipType!,
        syncStatus: SyncStatus.pending,
        createdAt: now,
        updatedAt: now,
      );

      await ref.read(
        saveOutsidePlantRelationshipProvider((
          relationship: relationship,
          isEditMode: false,
        )).future,
      );

      if (!mounted) {
        return;
      }

      Navigator.of(context).pop(true);
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _errorText = 'No se pudo guardar la relación. ${error.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }
}

class _TargetOption {
  final String id;
  final String label;

  const _TargetOption({
    required this.id,
    required this.label,
  });
}

class _RelationshipTypeOption {
  final String value;
  final String label;

  const _RelationshipTypeOption({
    required this.value,
    required this.label,
  });
}
