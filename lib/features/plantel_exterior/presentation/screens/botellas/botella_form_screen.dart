import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/application/providers/outside_plant_providers.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/entities/botella_empalme.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/enums/sync_status.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/value_objects/geo_point.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/value_objects/outside_plant_id.dart';

class BotellaFormScreen extends ConsumerStatefulWidget {
  const BotellaFormScreen({super.key});

  @override
  ConsumerState<BotellaFormScreen> createState() => _BotellaFormScreenState();
}

class _BotellaFormScreenState extends ConsumerState<BotellaFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _codigoController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();

  bool _saving = false;
  String? _errorText;

  @override
  void dispose() {
    _codigoController.dispose();
    _descripcionController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
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

      final entity = BotellaEmpalme(
        id: OutsidePlantId(
          'botella-${now.microsecondsSinceEpoch}',
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
      await repository.saveBotellaEmpalme(entity);
      ref.invalidate(botellasEmpalmeListProvider);

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva Botella de Empalme'),
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
                        'Alta de Botella de Empalme',
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
                            onPressed: _saving ? null : _submit,
                            child: _saving
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text('Guardar'),
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
