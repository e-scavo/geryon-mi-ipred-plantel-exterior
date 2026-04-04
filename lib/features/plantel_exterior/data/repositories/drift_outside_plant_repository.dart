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

class DriftOutsidePlantRepository implements OutsidePlantRepositoryContract {
  final PlantelExteriorDatabase db;

  DriftOutsidePlantRepository(this.db);

  @override
  Future<void> ensureSeedData() async {
    final cajas = await db.select(db.cajasPonOntTable).get();

    if (cajas.isNotEmpty) return;

    final now = DateTime.now();

    await db.into(db.cajasPonOntTable).insert(
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
        );

    await db.into(db.botellasEmpalmeTable).insert(
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
        );
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
}
