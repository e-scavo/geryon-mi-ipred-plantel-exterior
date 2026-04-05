import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/application/providers/outside_plant_providers.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/entities/caja_pon_ont.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/enums/sync_status.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/value_objects/geo_point.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/value_objects/outside_plant_id.dart';

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
  }

  @override
  void dispose() {
    _codigoController.dispose();
    _descripcionController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final latText = _latitudeController.text.trim();
    final lngText = _longitudeController.text.trim();

    double? latitude;
    double? longitude;

    if (latText.isNotEmpty || lngText.isNotEmpty) {
      latitude = double.tryParse(latText);
      longitude = double.tryParse(lngText);

      if (latitude == null || longitude == null) {
        setState(() {
          _errorText = 'Latitud y longitud deben ser números válidos.';
        });
        return;
      }
    }

    setState(() {
      _saving = true;
      _errorText = null;
    });

    try {
      final now = DateTime.now();

      final entity = widget.isEditMode
          ? CajaPonOnt(
              id: widget.caja!.id,
              codigo: _codigoController.text.trim(),
              descripcion: _descripcionController.text.trim(),
              location: latitude != null && longitude != null
                  ? GeoPoint(latitude: latitude, longitude: longitude)
                  : null,
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
              location: latitude != null && longitude != null
                  ? GeoPoint(latitude: latitude, longitude: longitude)
                  : null,
              syncStatus: SyncStatus.pending,
              createdAt: now,
              updatedAt: now,
            );

      final repository = ref.read(outsidePlantRepositoryProvider);
      await repository.saveCajaPonOnt(entity);
      ref.invalidate(cajasPonOntListProvider);

      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      setState(() {
        _errorText = e.toString();
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
                      Text(
                        isEditMode
                            ? 'Edición de Caja PON / ONT'
                            : 'Alta de Caja PON / ONT',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _codigoController,
                        decoration: const InputDecoration(
                          labelText: 'Código',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'El código es obligatorio.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _descripcionController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Descripción',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'La descripción es obligatoria.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _latitudeController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                          signed: true,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Latitud (opcional)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _longitudeController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                          signed: true,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Longitud (opcional)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      if (_errorText != null) ...[
                        const SizedBox(height: 16),
                        Text(
                          _errorText!,
                          style: TextStyle(
                            color: theme.colorScheme.error,
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          OutlinedButton(
                            onPressed: _saving
                                ? null
                                : () => Navigator.of(context).pop(false),
                            child: const Text('Cancelar'),
                          ),
                          const SizedBox(width: 12),
                          FilledButton(
                            onPressed: _saving ? null : _handleSave,
                            child: _saving
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(isEditMode ? 'Actualizar' : 'Guardar'),
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
