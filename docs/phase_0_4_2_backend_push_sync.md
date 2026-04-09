# Phase 0.4.2 — Backend Push Sync

---

## OBJETIVO

Introducir el pipeline de push del módulo Plantel Exterior para procesar la outbox local de forma secuencial y controlada, sin incorporar todavía pull remoto ni modelado backend definitivo.

---

## CONTEXTO

Phase 0.4.1 dejó resuelto el fundamento local-first con:

- base local Drift operativa
- `outside_plant_sync_queue`
- contrato de sync local
- snapshots para create / update / delete
- `OutsidePlantSyncService`
- mutations del módulo preparadas para dejar trazabilidad de convergencia

El gap real restante era que la cola existía, pero todavía no había un processor que intentara empujar sus pendientes hacia un boundary remoto del feature.

---

## PROBLEMA

El módulo ya sabía registrar intención de sync, pero no podía ejecutar un ciclo de push que:

- leyera la queue pendiente
- marcara `processing`
- despachara por entidad + operación
- propagara éxito o error
- actualizara `syncStatus` local en create/update exitosos

Sin esa capa, la subfase 0.4.1 quedaba incompleta para preparar convergencia real futura.

---

## SOLUCIÓN

Se incorpora un pipeline de push del feature compuesto por cuatro piezas:

1. `OutsidePlantRemoteSyncContract`
2. adapter remoto controlado `OutsidePlantRemoteSyncStubRepository`
3. `OutsidePlantPushSyncProcessor`
4. resultado tipado `OutsidePlantPushCycleResult`

La decisión arquitectónica fue no inventar todavía el contrato backend real. Por eso el adapter remoto queda encapsulado en un stub-safe que devuelve indisponibilidad explícita, mientras el processor y la transición de estados quedan completamente implementados.

---

## CAMBIOS IMPLEMENTADOS

### Contrato remoto del módulo

Se agrega:

- `OutsidePlantRemoteSyncContract`

El contrato separa el feature de cualquier detalle concreto del backend y expone operaciones de push por entidad + tipo de operación:

- create caja
- update caja
- delete caja
- create botella
- update botella
- delete botella

En esta subfase el contrato consume snapshots JSON ya persistidos en la outbox local, evitando inventar payloads remotos definitivos.

---

### Resultado remoto tipado

Se agrega:

- `OutsidePlantRemotePushResult`

Esto permite que el processor trate el resultado remoto como un dato del dominio técnico del módulo y no como excepciones ad-hoc dispersas.

---

### Processor secuencial de push

Se agrega:

- `OutsidePlantPushSyncProcessor`

Responsabilidades reales:

- leer pendientes de `outside_plant_sync_queue`
- marcarlos `processing`
- despachar por `entityType` + `operationType`
- registrar error cuando el push falla
- marcar entidad local como `synced` cuando create/update resultan exitosos
- remover item de queue cuando la convergencia fue aceptada
- devolver un resumen del ciclo ejecutado

La ejecución es deliberadamente secuencial para mantener trazabilidad, previsibilidad y simplicidad en esta etapa.

---

### Adapter remoto controlado

Se agrega:

- `OutsidePlantRemoteSyncStubRepository`

En esta subfase el adapter no intenta hablar con backend real porque todavía no existe el contrato Go modelado para este módulo.

En lugar de inventar payloads o endpoints, devuelve error controlado:

- `Remote sync contract not wired yet...`

Esto permite validar el pipeline completo de push y el manejo de estados de error sin mentir sobre una integración remota inexistente.

---

### Repositorio principal

Se extiende `OutsidePlantRepositoryContract` y su implementación Drift con dos operaciones nuevas:

- `markCajaPonOntSynced(...)`
- `markBotellaEmpalmeSynced(...)`

Con esto el processor queda listo para actualizar `syncStatus` local en cuanto el adapter remoto real quede conectado.

---

### Providers del feature

Se agrega a `presentation/providers/outside_plant_providers.dart`:

- provider del contrato remoto del módulo
- provider del processor de push

Se agrega a `presentation/providers/outside_plant_mutations_provider.dart`:

- `runOutsidePlantPushSyncProvider`

Además, se corrige el wiring de formularios y acciones delete para que vuelvan a pasar por los mutation providers del feature y no bypasseen el service local de sync.

Este punto es importante: sin esa corrección, la outbox no quedaba garantizada para todas las mutaciones del CRUD.

---

### UI técnica mínima de validación

Se actualiza la home del módulo con:

- contador de pendientes de sync
- acción manual `Intentar push`
- feedback resumido del ciclo ejecutado

No se trata todavía de una UX final de sincronización. Es un control técnico mínimo y explícito para validar 0.4.2 sin adelantar 0.4.4.

---

## RESULTADO

Al finalizar 0.4.2 el módulo ya dispone de:

- outbox local funcional
- processor secuencial de push
- adapter remoto desacoplado
- transición `pending/error -> processing -> remove o error`
- actualización prevista de `syncStatus` local para create/update exitosos
- punto de disparo manual para validar el pipeline

---

## IMPACTO

- deja lista la arquitectura para enchufar backend real sin rehacer el módulo
- mantiene DB local como source of truth operativo
- no toca el runtime owner heredado
- no inventa payloads backend todavía
- mejora la disciplina de mutaciones del CRUD del módulo

---

## LIMITACIONES

Aún no incluye:

- contrato backend Go real
- push productivo contra backend existente
- pull / refresh remoto
- resolución de conflictos
- retry policy avanzada
- compactación inteligente de queue
- UX final de sync

El adapter remoto actual es deliberadamente controlado y no productivo.

---

## CONCLUSIÓN

Phase 0.4.2 deja completa la columna vertebral de push del módulo Plantel Exterior sin romper el enfoque local-first y sin especular con contratos remotos que todavía no fueron modelados.

El proyecto queda correctamente preparado para avanzar a:

→ Phase 0.4.3 — Backend Pull Refresh
