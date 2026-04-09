import 'package:drift/drift.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/data/local/app_database.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/data/mappers/botella_empalme_mapper.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/data/mappers/caja_pon_ont_mapper.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/contracts/outside_plant_repository_contract.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/entities/botella_empalme.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/entities/caja_pon_ont.dart';
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
    final rows = await db.select(db.cajasPonOntTable).get();
    return rows.map(CajaPonOntMapper.toEntity).toList();
  }

  @override
  Future<List<BotellaEmpalme>> getBotellasEmpalme() async {
    final rows = await db.select(db.botellasEmpalmeTable).get();
    return rows.map(BotellaEmpalmeMapper.toEntity).toList();
  }

  @override
  Future<void> saveCajaPonOnt(CajaPonOnt caja) async {
    await db.into(db.cajasPonOntTable).insertOnConflictUpdate(
          CajaPonOntMapper.toCompanion(caja),
        );
  }

  @override
  Future<void> saveBotellaEmpalme(BotellaEmpalme botella) async {
    await db.into(db.botellasEmpalmeTable).insertOnConflictUpdate(
          BotellaEmpalmeMapper.toCompanion(botella),
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
}
