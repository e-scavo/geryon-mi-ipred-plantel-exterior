import 'package:drift/drift.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/data/local/database/construct_db.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/data/local/tables/botellas_empalme_table.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/data/local/tables/cajas_pon_ont_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    CajasPonOntTable,
    BotellasEmpalmeTable,
  ],
)
class PlantelExteriorDatabase extends _$PlantelExteriorDatabase {
  PlantelExteriorDatabase() : super(openPlantelExteriorConnection());

  PlantelExteriorDatabase.withExecutor(super.e);

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await _createSyncQueueTable();
          await _addOperationalFieldsToOutsidePlantTables();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await _createSyncQueueTable();
          }

          if (from < 3) {
            await _addOperationalFieldsToOutsidePlantTables();
          }
        },
      );

  Future<void> _createSyncQueueTable() async {
    await customStatement('''
      CREATE TABLE IF NOT EXISTS outside_plant_sync_queue (
        id TEXT NOT NULL PRIMARY KEY,
        entity_type TEXT NOT NULL,
        entity_id TEXT NOT NULL,
        operation_type TEXT NOT NULL,
        payload_json TEXT NOT NULL,
        status TEXT NOT NULL,
        attempt_count INTEGER NOT NULL DEFAULT 0,
        last_error TEXT NOT NULL DEFAULT '',
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_outside_plant_sync_queue_status_created_at
      ON outside_plant_sync_queue(status, created_at)
    ''');
  }

  Future<void> _addOperationalFieldsToOutsidePlantTables() async {
    for (final tableName in const ['cajas_pon_ont', 'botellas_empalme']) {
      await _addColumnIfMissing(
          tableName: tableName,
          columnName: 'codigo_tecnico',
          sqliteType: 'TEXT');
      await _addColumnIfMissing(
          tableName: tableName,
          columnName: 'referencia_externa',
          sqliteType: 'TEXT');
      await _addColumnIfMissing(
          tableName: tableName,
          columnName: 'observaciones_tecnicas',
          sqliteType: 'TEXT');
      await _addColumnIfMissing(
          tableName: tableName,
          columnName: 'estado_operativo',
          sqliteType: 'TEXT');
      await _addColumnIfMissing(
          tableName: tableName,
          columnName: 'criticidad',
          sqliteType: 'INTEGER');
      await _addColumnIfMissing(
          tableName: tableName, columnName: 'zona', sqliteType: 'TEXT');
      await _addColumnIfMissing(
          tableName: tableName, columnName: 'sector', sqliteType: 'TEXT');
      await _addColumnIfMissing(
          tableName: tableName, columnName: 'tramo', sqliteType: 'TEXT');
    }
  }

  Future<void> _addColumnIfMissing({
    required String tableName,
    required String columnName,
    required String sqliteType,
  }) async {
    final existingColumns =
        await customSelect('PRAGMA table_info($tableName)').get();
    final exists =
        existingColumns.any((row) => row.read<String>('name') == columnName);
    if (!exists) {
      await customStatement(
          'ALTER TABLE $tableName ADD COLUMN $columnName $sqliteType');
    }
  }
}
