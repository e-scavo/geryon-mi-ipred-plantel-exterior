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
  int get schemaVersion => 1;
}
