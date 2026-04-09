import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/contracts/outside_plant_remote_pull_contract.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/contracts/outside_plant_repository_contract.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/entities/botella_empalme.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/entities/caja_pon_ont.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/enums/sync_status.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/models/outside_plant_pull_cycle_result.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/value_objects/geo_point.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/value_objects/outside_plant_id.dart';

class OutsidePlantPullSyncProcessor {
  final OutsidePlantRepositoryContract repository;
  final OutsidePlantRemotePullContract remotePullRepository;

  const OutsidePlantPullSyncProcessor({
    required this.repository,
    required this.remotePullRepository,
  });

  Future<OutsidePlantPullCycleResult> runPullCycle() async {
    final localCajas = await repository.getCajasPonOnt();
    final localBotellas = await repository.getBotellasEmpalme();
    final remoteCajas = await remotePullRepository.fetchCajasPonOnt();
    final remoteBotellas = await remotePullRepository.fetchBotellasEmpalme();

    final localCajasById = {
      for (final item in localCajas) item.id.value: item,
    };
    final localBotellasById = {
      for (final item in localBotellas) item.id.value: item,
    };

    var insertedCount = 0;
    var updatedCount = 0;
    var skippedCount = 0;
    final errors = <String>[];

    for (final rawCaja in remoteCajas) {
      try {
        final incoming = _mapCaja(rawCaja);
        final local = localCajasById[incoming.id.value];

        if (local == null) {
          await repository.saveCajaPonOnt(incoming);
          insertedCount += 1;
          continue;
        }

        if (local.syncStatus != SyncStatus.synced) {
          skippedCount += 1;
          continue;
        }

        await repository.saveCajaPonOnt(
          incoming.copyWith(
            createdAt: local.createdAt ?? incoming.createdAt,
          ),
        );
        updatedCount += 1;
      } catch (error) {
        skippedCount += 1;
        errors.add('caja_pon_ont: ${error.toString()}');
      }
    }

    for (final rawBotella in remoteBotellas) {
      try {
        final incoming = _mapBotella(rawBotella);
        final local = localBotellasById[incoming.id.value];

        if (local == null) {
          await repository.saveBotellaEmpalme(incoming);
          insertedCount += 1;
          continue;
        }

        if (local.syncStatus != SyncStatus.synced) {
          skippedCount += 1;
          continue;
        }

        await repository.saveBotellaEmpalme(
          incoming.copyWith(
            createdAt: local.createdAt ?? incoming.createdAt,
          ),
        );
        updatedCount += 1;
      } catch (error) {
        skippedCount += 1;
        errors.add('botella_empalme: ${error.toString()}');
      }
    }

    return OutsidePlantPullCycleResult(
      fetchedCount: remoteCajas.length + remoteBotellas.length,
      insertedCount: insertedCount,
      updatedCount: updatedCount,
      skippedCount: skippedCount,
      errors: errors,
    );
  }

  CajaPonOnt _mapCaja(Map<String, dynamic> raw) {
    final id = _requiredString(raw, ['id']);
    final codigo = _requiredString(raw, ['codigo']);
    final descripcion = _requiredString(raw, ['descripcion']);

    return CajaPonOnt(
      id: OutsidePlantId(id),
      codigo: codigo,
      descripcion: descripcion,
      location: _extractLocation(raw),
      syncStatus: SyncStatus.synced,
      createdAt: _optionalDateTime(raw['createdAt']),
      updatedAt: _optionalDateTime(raw['updatedAt']) ?? DateTime.now(),
    );
  }

  BotellaEmpalme _mapBotella(Map<String, dynamic> raw) {
    final id = _requiredString(raw, ['id']);
    final codigo = _requiredString(raw, ['codigo']);
    final descripcion = _requiredString(raw, ['descripcion']);

    return BotellaEmpalme(
      id: OutsidePlantId(id),
      codigo: codigo,
      descripcion: descripcion,
      location: _extractLocation(raw),
      syncStatus: SyncStatus.synced,
      createdAt: _optionalDateTime(raw['createdAt']),
      updatedAt: _optionalDateTime(raw['updatedAt']) ?? DateTime.now(),
    );
  }

  GeoPoint? _extractLocation(Map<String, dynamic> raw) {
    final latitude = _optionalDouble(raw['latitude']);
    final longitude = _optionalDouble(raw['longitude']);

    if (latitude == null || longitude == null) {
      return null;
    }

    return GeoPoint(latitude: latitude, longitude: longitude);
  }

  String _requiredString(Map<String, dynamic> raw, List<String> keys) {
    for (final key in keys) {
      final value = raw[key];
      if (value is String && value.trim().isNotEmpty) {
        return value.trim();
      }
    }

    throw StateError('Missing required keys: ${keys.join(', ')}');
  }

  double? _optionalDouble(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is num) {
      return value.toDouble();
    }

    if (value is String && value.trim().isNotEmpty) {
      return double.tryParse(value.trim());
    }

    return null;
  }

  DateTime? _optionalDateTime(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is DateTime) {
      return value;
    }

    if (value is String && value.trim().isNotEmpty) {
      return DateTime.tryParse(value.trim());
    }

    return null;
  }
}
