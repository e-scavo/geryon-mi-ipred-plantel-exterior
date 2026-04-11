import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/entities/caja_pon_ont.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/enums/sync_status.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/value_objects/geo_point.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/value_objects/outside_plant_id.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/presentation/providers/outside_plant_mutations_provider.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/presentation/widgets/outside_plant_relationships_section.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/presentation/widgets/outside_plant_sync_status_badge.dart';

class CajaFormScreen extends ConsumerStatefulWidget {
  final CajaPonOnt? caja;

  const CajaFormScreen({
    super.key,
    this.caja,
  });

  bool get isEditMode => caja != null;

  @override
  ConsumerState<CajaFormScreen> createState() => _CajaFormScreenState();
}

class _CajaFormScreenState extends ConsumerState<CajaFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _codigoController;
  late final TextEditingController _descripcionController;
  late final TextEditingController _latitudeController;
  late final TextEditingController _longitudeController;
  late final TextEditingController _codigoTecnicoController;
  late final TextEditingController _referenciaExternaController;
  late final TextEditingController _estadoOperativoController;
  late final TextEditingController _criticidadController;
  late final TextEditingController _zonaController;
  late final TextEditingController _sectorController;
  late final TextEditingController _tramoController;
  late final TextEditingController _observacionesTecnicasController;

  bool _saving = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();

    _codigoController = TextEditingController(
      text: widget.caja?.codigo ?? '',
    );
    _descripcionController = TextEditingController(
      text: widget.caja?.descripcion ?? '',
    );
    _latitudeController = TextEditingController(
      text: widget.caja?.location?.latitude.toString() ?? '',
    );
    _longitudeController = TextEditingController(
      text: widget.caja?.location?.longitude.toString() ?? '',
    );
    _codigoTecnicoController = TextEditingController(
      text: widget.caja?.codigoTecnico ?? '',
    );
    _referenciaExternaController = TextEditingController(
      text: widget.caja?.referenciaExterna ?? '',
    );
    _estadoOperativoController = TextEditingController(
      text: widget.caja?.estadoOperativo ?? '',
    );
    _criticidadController = TextEditingController(
      text: widget.caja?.criticidad?.toString() ?? '',
    );
    _zonaController = TextEditingController(
      text: widget.caja?.zona ?? '',
    );
    _sectorController = TextEditingController(
      text: widget.caja?.sector ?? '',
    );
    _tramoController = TextEditingController(
      text: widget.caja?.tramo ?? '',
    );
    _observacionesTecnicasController = TextEditingController(
      text: widget.caja?.observacionesTecnicas ?? '',
    );
  }

  @override
  void dispose() {
    _codigoController.dispose();
    _descripcionController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    _codigoTecnicoController.dispose();
    _referenciaExternaController.dispose();
    _estadoOperativoController.dispose();
    _criticidadController.dispose();
    _zonaController.dispose();
    _sectorController.dispose();
    _tramoController.dispose();
    _observacionesTecnicasController.dispose();
    super.dispose();
  }

  String? _validateCodigo(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return 'El código es obligatorio.';
    }
    if (text.length < 3) {
      return 'El código debe tener al menos 3 caracteres.';
    }
    return null;
  }

  String? _validateDescripcion(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return 'La descripción es obligatoria.';
    }
    if (text.length < 5) {
      return 'La descripción debe tener al menos 5 caracteres.';
    }
    return null;
  }

  String? _validateCriticidad(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return null;
    }

    final criticidad = int.tryParse(text);
    if (criticidad == null) {
      return 'La criticidad debe ser un número entero entre 1 y 5.';
    }
    if (criticidad < 1 || criticidad > 5) {
      return 'La criticidad debe estar entre 1 y 5.';
    }
    return null;
  }

  double? _tryParseCoordinate(String text) {
    final normalized = text.trim().replaceAll(',', '.');
    if (normalized.isEmpty) {
      return null;
    }
    return double.tryParse(normalized);
  }

  String? _normalizedText(TextEditingController controller) {
    final text = controller.text.trim();
    return text.isEmpty ? null : text;
  }

  Future<void> _handleSave() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final latText = _latitudeController.text.trim();
    final lngText = _longitudeController.text.trim();

    final latitude = _tryParseCoordinate(latText);
    final longitude = _tryParseCoordinate(lngText);

    final hasAnyCoordinate = latText.isNotEmpty || lngText.isNotEmpty;
    final hasBothCoordinates = latText.isNotEmpty && lngText.isNotEmpty;

    if (hasAnyCoordinate && !hasBothCoordinates) {
      setState(() {
        _errorText =
            'Si informás ubicación, debés completar latitud y longitud.';
      });
      return;
    }

    if (hasBothCoordinates && (latitude == null || longitude == null)) {
      setState(() {
        _errorText = 'Latitud y longitud deben ser números válidos.';
      });
      return;
    }

    if (latitude != null && (latitude < -90 || latitude > 90)) {
      setState(() {
        _errorText = 'La latitud debe estar entre -90 y 90.';
      });
      return;
    }

    if (longitude != null && (longitude < -180 || longitude > 180)) {
      setState(() {
        _errorText = 'La longitud debe estar entre -180 y 180.';
      });
      return;
    }

    final criticidadText = _criticidadController.text.trim();
    final criticidad =
        criticidadText.isEmpty ? null : int.tryParse(criticidadText);

    if (criticidadText.isNotEmpty && criticidad == null) {
      setState(() {
        _errorText = 'La criticidad debe ser un número entero válido.';
      });
      return;
    }

    setState(() {
      _saving = true;
      _errorText = null;
    });

    try {
      final now = DateTime.now();
      final location = latitude != null && longitude != null
          ? GeoPoint(latitude: latitude, longitude: longitude)
          : null;

      final entity = widget.isEditMode
          ? CajaPonOnt(
              id: widget.caja!.id,
              codigo: _codigoController.text.trim(),
              descripcion: _descripcionController.text.trim(),
              location: location,
              codigoTecnico: _normalizedText(_codigoTecnicoController),
              referenciaExterna: _normalizedText(_referenciaExternaController),
              observacionesTecnicas:
                  _normalizedText(_observacionesTecnicasController),
              estadoOperativo: _normalizedText(_estadoOperativoController),
              criticidad: criticidad,
              zona: _normalizedText(_zonaController),
              sector: _normalizedText(_sectorController),
              tramo: _normalizedText(_tramoController),
              syncStatus: SyncStatus.pending,
              createdAt: widget.caja!.createdAt,
              updatedAt: now,
            )
          : CajaPonOnt(
              id: OutsidePlantId(
                'caja-${now.microsecondsSinceEpoch}',
              ),
              codigo: _codigoController.text.trim(),
              descripcion: _descripcionController.text.trim(),
              location: location,
              codigoTecnico: _normalizedText(_codigoTecnicoController),
              referenciaExterna: _normalizedText(_referenciaExternaController),
              observacionesTecnicas:
                  _normalizedText(_observacionesTecnicasController),
              estadoOperativo: _normalizedText(_estadoOperativoController),
              criticidad: criticidad,
              zona: _normalizedText(_zonaController),
              sector: _normalizedText(_sectorController),
              tramo: _normalizedText(_tramoController),
              syncStatus: SyncStatus.pending,
              createdAt: now,
              updatedAt: now,
            );

      await ref.read(
        saveCajaPonOntProvider((
          caja: entity,
          isEditMode: widget.isEditMode,
        )).future,
      );

      if (!mounted) {
        return;
      }

      Navigator.of(context).pop(
        widget.isEditMode
            ? 'Caja actualizada correctamente.'
            : 'Caja creada correctamente.',
      );
    } catch (e) {
      setState(() {
        _errorText = 'No se pudo guardar la caja. ${e.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEditMode = widget.isEditMode;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditMode ? 'Editar Caja PON / ONT' : 'Nueva Caja PON / ONT',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Card(
              elevation: 2,
              surfaceTintColor: theme.colorScheme.surface,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isEditMode && widget.caja != null) ...[
                        Row(
                          children: [
                            const Text('Estado actual:'),
                            const SizedBox(width: 10),
                            OutsidePlantSyncStatusBadge(
                              status: widget.caja!.syncStatus,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer
                                .withOpacity(0.45),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color:
                                  theme.colorScheme.primary.withOpacity(0.18),
                            ),
                          ),
                          child: Text(
                            'Al guardar cambios, este registro vuelve a estado pendiente hasta que un push lo converja de nuevo. La edición sigue trabajando primero contra la base local.',
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                      Text(
                        isEditMode
                            ? 'Edición de Caja PON / ONT'
                            : 'Alta de Caja PON / ONT',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isEditMode
                            ? 'Modificá los datos necesarios y guardá los cambios.'
                            : 'Completá los datos mínimos para crear una nueva caja.',
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 20),
                      _SectionTitle(title: 'Identificación base'),
                      TextFormField(
                        controller: _codigoController,
                        enabled: !_saving,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'Código',
                          border: OutlineInputBorder(),
                        ),
                        validator: _validateCodigo,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _descripcionController,
                        enabled: !_saving,
                        maxLines: 3,
                        textInputAction: TextInputAction.newline,
                        decoration: const InputDecoration(
                          labelText: 'Descripción',
                          border: OutlineInputBorder(),
                        ),
                        validator: _validateDescripcion,
                      ),
                      const SizedBox(height: 24),
                      _SectionTitle(title: 'Campos operativos'),
                      TextFormField(
                        controller: _codigoTecnicoController,
                        enabled: !_saving,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'Código técnico (opcional)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _referenciaExternaController,
                        enabled: !_saving,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'Referencia externa (opcional)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _estadoOperativoController,
                              enabled: !_saving,
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                labelText: 'Estado operativo (opcional)',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _criticidadController,
                              enabled: !_saving,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                labelText: 'Criticidad 1-5 (opcional)',
                                border: OutlineInputBorder(),
                              ),
                              validator: _validateCriticidad,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _SectionTitle(title: 'Ubicación operativa'),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _zonaController,
                              enabled: !_saving,
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                labelText: 'Zona (opcional)',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _sectorController,
                              enabled: !_saving,
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                labelText: 'Sector (opcional)',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _tramoController,
                        enabled: !_saving,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'Tramo (opcional)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 24),
                      _SectionTitle(title: 'Coordenadas'),
                      TextFormField(
                        controller: _latitudeController,
                        enabled: !_saving,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                          signed: true,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Latitud (opcional)',
                          border: OutlineInputBorder(),
                          hintText: '-32.9442',
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _longitudeController,
                        enabled: !_saving,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                          signed: true,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Longitud (opcional)',
                          border: OutlineInputBorder(),
                          hintText: '-60.6505',
                        ),
                      ),
                      const SizedBox(height: 24),
                      _SectionTitle(title: 'Observaciones'),
                      TextFormField(
                        controller: _observacionesTecnicasController,
                        enabled: !_saving,
                        maxLines: 4,
                        textInputAction: TextInputAction.newline,
                        decoration: const InputDecoration(
                          labelText: 'Observaciones técnicas (opcional)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 24),
                      _SectionTitle(title: 'Relaciones'),
                      if (!isEditMode || widget.caja == null)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Las relaciones estarán disponibles una vez que el elemento haya sido guardado.',
                          ),
                        )
                      else
                        OutsidePlantRelationshipsSection(
                          sourceEntityType: 'caja_pon_ont',
                          sourceEntityId: widget.caja!.id.value,
                          sourceEntityLabel: widget.caja!.codigo,
                        ),
                      if (_errorText != null) ...[
                        const SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.errorContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _errorText!,
                            style: TextStyle(
                              color: theme.colorScheme.onErrorContainer,
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          OutlinedButton(
                            onPressed: _saving
                                ? null
                                : () => Navigator.of(context).pop(),
                            child: const Text('Cancelar'),
                          ),
                          FilledButton.icon(
                            onPressed: _saving ? null : _handleSave,
                            icon: _saving
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Icon(
                                    isEditMode
                                        ? Icons.save_outlined
                                        : Icons.add_circle_outline,
                                  ),
                            label: Text(
                              _saving
                                  ? (isEditMode
                                      ? 'Actualizando...'
                                      : 'Guardando...')
                                  : (isEditMode ? 'Actualizar' : 'Guardar'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
