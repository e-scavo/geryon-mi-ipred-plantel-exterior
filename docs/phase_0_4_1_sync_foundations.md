# Phase 0.4.1 — Sync Foundations

---

## OBJETIVO

Introducir la base estructural de sincronización offline-first del módulo Plantel Exterior sin conectar todavía el backend real y sin romper el CRUD local ya consolidado.

---

## CONTEXTO

Hasta Phase 0.3.4 el proyecto contaba con:

- shell post-login consolidado
- navegación propia del módulo
- dominio real inicial para Caja PON / ONT y Botella de Empalme
- persistencia local Drift operativa en Web + Android
- CRUD completo local
- capa mínima de UX para create / update / delete

El gap real del baseline era que las mutaciones locales no dejaban una trazabilidad estructurada para futura convergencia con backend.

---

## PROBLEMA

El módulo podía crear, editar y eliminar registros localmente, pero todavía no tenía:

- outbox local
- boundary específico de sync
- snapshots persistidos para push futuro
- conteo de pendientes
- orquestación dedicada para mutations + sync trace

Esto hacía imposible avanzar a 0.4.2 de forma seria sin introducir acoplamiento prematuro entre UI y transporte.

---

## SOLUCIÓN

Se implementa una fundación de sincronización centrada en cinco piezas:

1. migración local con tabla `outside_plant_sync_queue`
2. contrato de sync del módulo
3. repositorio Drift para persistencia de queue
4. service de orquestación del feature
5. snapshot mappers para create / update / delete

La decisión de esta subfase fue mantener la fuente de verdad operativa en la base local y registrar la intención de sync en una cola independiente, sin inventar todavía contratos remotos.

---

## CAMBIOS IMPLEMENTADOS

### Base de datos

Se elevó el schema local a versión 2.

Se agregó migración controlada para crear:

- `outside_plant_sync_queue`
- índice por estado + fecha de creación

La tabla almacena:

- id de operación
- tipo de entidad
- id de entidad
- tipo de operación
- payload JSON local
- estado de cola
- contador de intentos
- último error
- timestamps

---

### Contrato de sync

Se incorporó:

- `OutsidePlantSyncContract`

Responsabilidades:

- encolar operación pendiente
- listar pendientes
- obtener conteo de pendientes
- marcar procesamiento
- marcar error
- remover item

---

### Repositorio de sync

Se implementó:

- `DriftOutsidePlantSyncRepository`

La persistencia se resolvió mediante SQL custom sobre la misma base Drift existente para no introducir en esta subfase una regeneración de código más amplia que la necesaria.

---

### Snapshot mappers

Se implementaron mappers específicos para:

- `CajaPonOnt`
- `BotellaEmpalme`

Cada mutation local ahora puede persistir:

- snapshot JSON de create/update
- tombstone JSON de delete

---

### Orquestación del feature

Se incorporó:

- `OutsidePlantSyncService`

Responsabilidad real:

- coordinar persistencia local + queue trace dentro de una transacción
- mantener a la UI fuera de detalles de sync
- preparar el terreno para 0.4.2 sin meter esta lógica dentro de `ServiceProvider`

---

### Providers

Se amplió la capa de providers con:

- repositorio de sync
- service de sync
- mutation providers para save/delete de ambas entidades
- provider de conteo de pendientes

Con esto la UI deja de mutar el repositorio local directamente para las operaciones del CRUD del módulo.

---

### UI

Se actualizaron formularios y pantallas de listado para que create / update / delete pasen por la capa de mutation providers del feature.

Esto preserva el comportamiento visual existente, pero ahora cada acción local deja trazabilidad de sincronización.

---

## RESULTADO

El módulo ahora conserva su comportamiento local-first y además queda preparado para la siguiente etapa de sincronización.

A partir de esta subfase existe:

- cola local de pendientes
- boundary de sync
- snapshots persistidos
- capa de orquestación del feature
- conteo de pendientes listo para futura UX

---

## IMPACTO

- prepara 0.4.2 sin acoplar widgets al backend
- mantiene estable el runtime heredado
- preserva Web + Android
- agrega trazabilidad real de mutaciones locales

---

## LIMITACIONES

Aún no incluye:

- push real contra backend
- pull / refresh remoto
- resolución de conflictos
- retry UI
- compactación de cola
- hardening de errores complejos

Además, en esta subfase la eliminación sigue siendo física en la tabla principal, pero ahora queda registrada primero como tombstone en la cola local.

---

## CONCLUSIÓN

Phase 0.4.1 deja resuelto el cimiento arquitectónico mínimo para sincronización offline-first del módulo Plantel Exterior.

El proyecto queda correctamente preparado para avanzar a:

→ Phase 0.4.2 — Backend Push Sync
