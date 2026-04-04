import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables/cajas_pon_ont_table.dart';
import 'tables/botellas_empalme_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    CajasPonOntTable,
    BotellasEmpalmeTable,
  ],
)
class PlantelExteriorDatabase extends _$PlantelExteriorDatabase {
  PlantelExteriorDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    if (kIsWeb) {
      throw UnsupportedError(
        'Drift NativeDatabase no soportado en Web en esta fase (0.2.3)',
      );
    }

    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'plantel_exterior.db'));

    return NativeDatabase(file);
  });
}
