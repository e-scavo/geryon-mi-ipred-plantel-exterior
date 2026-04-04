import 'package:drift/drift.dart';

class BotellasEmpalmeTable extends Table {
  @override
  String get tableName => 'botellas_empalme';

  TextColumn get id => text()();

  TextColumn get codigo => text()();

  TextColumn get descripcion => text()();

  RealColumn get latitude => real().nullable()();

  RealColumn get longitude => real().nullable()();

  TextColumn get syncStatus => text().named('sync_status')();

  DateTimeColumn get createdAt => dateTime().nullable()();

  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
