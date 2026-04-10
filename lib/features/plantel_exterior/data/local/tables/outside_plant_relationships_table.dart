import 'package:drift/drift.dart';

class OutsidePlantRelationshipsTable extends Table {
  @override
  String get tableName => 'outside_plant_relationships';

  TextColumn get id => text()();

  TextColumn get sourceEntityType => text().named('source_entity_type')();

  TextColumn get sourceEntityId => text().named('source_entity_id')();

  TextColumn get targetEntityType => text().named('target_entity_type')();

  TextColumn get targetEntityId => text().named('target_entity_id')();

  TextColumn get relationshipType => text().named('relationship_type')();

  TextColumn get syncStatus => text().named('sync_status')();

  DateTimeColumn get createdAt => dateTime().nullable().named('created_at')();

  DateTimeColumn get updatedAt => dateTime().nullable().named('updated_at')();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
