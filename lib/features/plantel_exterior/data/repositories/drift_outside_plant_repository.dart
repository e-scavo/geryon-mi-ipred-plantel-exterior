import 'package:drift/drift.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/data/local/app_database.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/data/mappers/botella_empalme_mapper.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/data/mappers/caja_pon_ont_mapper.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/contracts/outside_plant_repository_contract.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/entities/botella_empalme.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/entities/caja_pon_ont.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/enums/sync_status.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/value_objects/geo_point.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/value_objects/outside_plant_id.dart';
import 'package:synchronized/synchronized.dart';

class DriftOutsidePlantRepository implements OutsidePlantRepositoryContract {
  final PlantelExteriorDatabase db;
  final Lock _seedLock = Lock();

  bool _seedEnsured = false;

  DriftOutsidePlantRepository(this.db);

  @override
  Future<void> ensureSeedData() async {
    if (_seedEnsured) {
      return;
    }

    await _seedLock.synchronized(() async {
      if (_seedEnsured) {
        return;
      }

      final cajasCountExpression = db.cajasPonOntTable.id.count();
      final botellasCountExpression = db.botellasEmpalmeTable.id.count();

      final cajasCountQuery = db.selectOnly(db.cajasPonOntTable)
        ..addColumns([cajasCountExpression]);

      final botellasCountQuery = db.selectOnly(db.botellasEmpalmeTable)
        ..addColumns([botellasCountExpression]);

      final cajasCountRow = await cajasCountQuery.getSingle();
      final botellasCountRow = await botellasCountQuery.getSingle();

      final cajasCount = cajasCountRow.read(cajasCountExpression) ?? 0;
      final botellasCount = botellasCountRow.read(botellasCountExpression) ?? 0;

      final now = DateTime.now();

      await db.batch((batch) {
        if (cajasCount == 0) {
          batch.insert(
            db.cajasPonOntTable,
            CajasPonOntTableCompanion.insert(
              id: 'caja-pon-ont-001',
              codigo: 'CP-001',
              descripcion: 'Caja inicial',
              latitude: const Value(-32.9442),
              longitude: const Value(-60.6505),
              syncStatus: 'pending',
              createdAt: Value(now),
              updatedAt: Value(now),
            ),
            mode: InsertMode.insertOrIgnore,
          );
        }

        if (botellasCount == 0) {
          batch.insert(
            db.botellasEmpalmeTable,
            BotellasEmpalmeTableCompanion.insert(
              id: 'botella-empalme-001',
              codigo: 'BE-001',
              descripcion: 'Botella inicial',
              latitude: const Value(-32.9470),
              longitude: const Value(-60.6401),
              syncStatus: 'synced',
              createdAt: Value(now),
              updatedAt: Value(now),
            ),
            mode: InsertMode.insertOrIgnore,
          );
        }
      });

      _seedEnsured = true;
    });
  }

  @override
  Future<List<CajaPonOnt>> getCajasPonOnt() async {
    final rows = await db.customSelect(
      '''
      SELECT id, codigo, descripcion, latitude, longitude,
             codigo_tecnico, referencia_externa, observaciones_tecnicas,
             estado_operativo, criticidad, zona, sector, tramo,
             sync_status, created_at, updated_at
      FROM cajas_pon_ont
      ORDER BY updated_at DESC, codigo ASC
      ''',
      readsFrom: {db.cajasPonOntTable},
    ).get();

    return rows.map(_mapCajaRow).toList();
  }

  @override
  Future<List<BotellaEmpalme>> getBotellasEmpalme() async {
    final rows = await db.customSelect(
      '''
      SELECT id, codigo, descripcion, latitude, longitude,
             codigo_tecnico, referencia_externa, observaciones_tecnicas,
             estado_operativo, criticidad, zona, sector, tramo,
             sync_status, created_at, updated_at
      FROM botellas_empalme
      ORDER BY updated_at DESC, codigo ASC
      ''',
      readsFrom: {db.botellasEmpalmeTable},
    ).get();

    return rows.map(_mapBotellaRow).toList();
  }

  @override
  Future<void> saveCajaPonOnt(CajaPonOnt caja) async {
    await db.into(db.cajasPonOntTable).insertOnConflictUpdate(
          CajaPonOntMapper.toCompanion(caja),
        );
    await _updateOperationalFields(
      tableName: 'cajas_pon_ont',
      id: caja.id.value,
      codigoTecnico: caja.codigoTecnico,
      referenciaExterna: caja.referenciaExterna,
      observacionesTecnicas: caja.observacionesTecnicas,
      estadoOperativo: caja.estadoOperativo,
      criticidad: caja.criticidad,
      zona: caja.zona,
      sector: caja.sector,
      tramo: caja.tramo,
    );
  }

  @override
  Future<void> saveBotellaEmpalme(BotellaEmpalme botella) async {
    await db.into(db.botellasEmpalmeTable).insertOnConflictUpdate(
          BotellaEmpalmeMapper.toCompanion(botella),
        );
    await _updateOperationalFields(
      tableName: 'botellas_empalme',
      id: botella.id.value,
      codigoTecnico: botella.codigoTecnico,
      referenciaExterna: botella.referenciaExterna,
      observacionesTecnicas: botella.observacionesTecnicas,
      estadoOperativo: botella.estadoOperativo,
      criticidad: botella.criticidad,
      zona: botella.zona,
      sector: botella.sector,
      tramo: botella.tramo,
    );
  }

  @override
  Future<void> deleteCajaPonOnt(OutsidePlantId id) async {
    final query = db.delete(db.cajasPonOntTable)
      ..where((tbl) => tbl.id.equals(id.value));
    await query.go();
  }

  @override
  Future<void> deleteBotellaEmpalme(OutsidePlantId id) async {
    final query = db.delete(db.botellasEmpalmeTable)
      ..where((tbl) => tbl.id.equals(id.value));
    await query.go();
  }

  @override
  Future<void> markCajaPonOntSynced(OutsidePlantId id) async {
    final query = db.update(db.cajasPonOntTable)
      ..where((tbl) => tbl.id.equals(id.value));
    await query.write(
      CajasPonOntTableCompanion(
        syncStatus: const Value('synced'),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  @override
  Future<void> markBotellaEmpalmeSynced(OutsidePlantId id) async {
    final query = db.update(db.botellasEmpalmeTable)
      ..where((tbl) => tbl.id.equals(id.value));
    await query.write(
      BotellasEmpalmeTableCompanion(
        syncStatus: const Value('synced'),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  CajaPonOnt _mapCajaRow(QueryRow row) {
    final latitude = row.read<double?>('latitude');
    final longitude = row.read<double?>('longitude');

    return CajaPonOnt(
      id: OutsidePlantId(row.read<String>('id')),
      codigo: row.read<String>('codigo'),
      descripcion: row.read<String>('descripcion'),
      location: latitude != null && longitude != null
          ? GeoPoint(latitude: latitude, longitude: longitude)
          : null,
      codigoTecnico:
          _normalizeNullableString(row.read<String?>('codigo_tecnico')),
      referenciaExterna:
          _normalizeNullableString(row.read<String?>('referencia_externa')),
      observacionesTecnicas:
          _normalizeNullableString(row.read<String?>('observaciones_tecnicas')),
      estadoOperativo:
          _normalizeNullableString(row.read<String?>('estado_operativo')),
      criticidad: row.read<int?>('criticidad'),
      zona: _normalizeNullableString(row.read<String?>('zona')),
      sector: _normalizeNullableString(row.read<String?>('sector')),
      tramo: _normalizeNullableString(row.read<String?>('tramo')),
      syncStatus: _syncStatusFromDb(row.read<String>('sync_status')),
      createdAt: row.read<DateTime?>('created_at'),
      updatedAt: row.read<DateTime?>('updated_at'),
    );
  }

  BotellaEmpalme _mapBotellaRow(QueryRow row) {
    final latitude = row.read<double?>('latitude');
    final longitude = row.read<double?>('longitude');

    return BotellaEmpalme(
      id: OutsidePlantId(row.read<String>('id')),
      codigo: row.read<String>('codigo'),
      descripcion: row.read<String>('descripcion'),
      location: latitude != null && longitude != null
          ? GeoPoint(latitude: latitude, longitude: longitude)
          : null,
      codigoTecnico:
          _normalizeNullableString(row.read<String?>('codigo_tecnico')),
      referenciaExterna:
          _normalizeNullableString(row.read<String?>('referencia_externa')),
      observacionesTecnicas:
          _normalizeNullableString(row.read<String?>('observaciones_tecnicas')),
      estadoOperativo:
          _normalizeNullableString(row.read<String?>('estado_operativo')),
      criticidad: row.read<int?>('criticidad'),
      zona: _normalizeNullableString(row.read<String?>('zona')),
      sector: _normalizeNullableString(row.read<String?>('sector')),
      tramo: _normalizeNullableString(row.read<String?>('tramo')),
      syncStatus: _syncStatusFromDb(row.read<String>('sync_status')),
      createdAt: row.read<DateTime?>('created_at'),
      updatedAt: row.read<DateTime?>('updated_at'),
    );
  }

  Future<void> _updateOperationalFields({
    required String tableName,
    required String id,
    required String? codigoTecnico,
    required String? referenciaExterna,
    required String? observacionesTecnicas,
    required String? estadoOperativo,
    required int? criticidad,
    required String? zona,
    required String? sector,
    required String? tramo,
  }) async {
    await db.customStatement('''
      UPDATE $tableName
      SET
        codigo_tecnico = ${_sqlString(codigoTecnico)},
        referencia_externa = ${_sqlString(referenciaExterna)},
        observaciones_tecnicas = ${_sqlString(observacionesTecnicas)},
        estado_operativo = ${_sqlString(estadoOperativo)},
        criticidad = ${_sqlInt(criticidad)},
        zona = ${_sqlString(zona)},
        sector = ${_sqlString(sector)},
        tramo = ${_sqlString(tramo)}
      WHERE id = ${_sqlString(id)}
    ''');
  }

  SyncStatus _syncStatusFromDb(String raw) {
    switch (raw) {
      case 'pending':
        return SyncStatus.pending;
      case 'synced':
        return SyncStatus.synced;
      case 'error':
        return SyncStatus.error;
      default:
        return SyncStatus.pending;
    }
  }

  String? _normalizeNullableString(String? value) {
    if (value == null) return null;
    final normalized = value.trim();
    return normalized.isEmpty ? null : normalized;
  }

  String _sqlString(String? value) {
    if (value == null || value.trim().isEmpty) return 'NULL';
    return "'${value.trim().replaceAll("'", "''")}'";
  }

  String _sqlInt(int? value) => value?.toString() ?? 'NULL';
}
