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
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await _createSyncQueueTable();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await _createSyncQueueTable();
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
}
