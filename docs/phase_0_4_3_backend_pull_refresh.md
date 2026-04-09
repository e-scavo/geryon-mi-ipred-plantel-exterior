# Phase 0.4.3 — Backend Pull Refresh

---

## OBJETIVO

Incorporar el pipeline de pull remoto→local del módulo Plantel Exterior con reconciliación conservadora, sin inventar todavía el contrato backend definitivo y sin romper el enfoque local-first ya consolidado.

---

## CONTEXTO

Phase 0.4.1 dejó lista la outbox local y la trazabilidad de mutaciones.

Phase 0.4.2 agregó el processor de push secuencial y el boundary remoto controlado para envío.

El gap restante era que el módulo todavía no podía refrescar estado remoto hacia la base local ni aplicar una política explícita de reconciliación.

---

## PROBLEMA

Hasta este punto el módulo podía:

- persistir localmente
- registrar pendientes
- ejecutar push controlado

Pero todavía no podía:

- traer snapshots remotos del backend futuro
- insertar registros remotos ausentes en la base local
- refrescar registros locales ya sincronizados
- proteger automáticamente registros locales con trabajo pendiente

---

## SOLUCIÓN

Se agrega una capa de pull del feature compuesta por:

1. `OutsidePlantRemotePullContract`
2. `OutsidePlantRemotePullStubRepository`
3. `OutsidePlantPullSyncProcessor`
4. `OutsidePlantPullCycleResult`

La implementación sigue el mismo criterio disciplinado de 0.4.2:

- el boundary remoto existe
- el processor real existe
- el adapter queda controlado y no especulativo
- la reconciliación local queda definida sin inventar DTOs finales

---

## CAMBIOS IMPLEMENTADOS

### Contrato remoto de pull

Se agrega `OutsidePlantRemotePullContract` para desacoplar el módulo del transporte concreto de refresh.

En esta etapa el contrato devuelve listas de `Map<String, dynamic>` para evitar fijar un DTO backend definitivo antes de recibir las estructuras Go reales.

---

### Adapter remoto controlado de pull

Se agrega `OutsidePlantRemotePullStubRepository`.

Su comportamiento actual es deliberadamente controlado:

- devuelve listas vacías
- no inventa endpoints
- no inventa payloads remotos
- permite validar wiring, processor y UX técnica mínima

---

### Processor de pull y reconciliación

Se agrega `OutsidePlantPullSyncProcessor`.

Responsabilidades reales:

- consultar snapshots remotos de cajas y botellas
- mapear snapshots remotos a entidades locales del módulo
- insertar filas remotas que aún no existen localmente
- actualizar filas locales solo si están en `synced`
- omitir filas locales en `pending` o `error`
- devolver un resumen tipado del ciclo ejecutado

La política de reconciliación es explícitamente conservadora.

---

### Regla de reconciliación local

Reglas implementadas:

- si el registro remoto no existe localmente, se inserta como `synced`
- si existe localmente y está `synced`, puede refrescarse desde remoto
- si existe localmente y está `pending`, se omite
- si existe localmente y está `error`, se omite
- el borrado remoto aún no forma parte de esta subfase

Esto protege trabajo local pendiente y evita pseudo-resolución de conflictos antes de tiempo.

---

### Providers del feature

Se agregan:

- provider del contrato remoto de pull
- provider del `OutsidePlantPullSyncProcessor`
- provider para ejecutar el ciclo de pull

Con esto el módulo ya dispone de dos pipelines separados y coherentes:

- push: outbox local → boundary remoto
- pull: boundary remoto → reconciliación local

---

### UI técnica mínima

La home del módulo se actualiza con una nueva acción:

- `Refrescar desde servidor`

El objetivo es técnico y controlado:

- ejecutar el ciclo de pull
- invalidar providers locales
- mostrar un resumen simple del resultado

No se trata todavía de la UX final de sincronización.

---

### Observaciones de baseline resueltas/documentadas

Además de la capa de pull, esta subfase deja documentadas dos observaciones reales del ZIP validado:

1. `application/providers/outside_plant_mutations_provider.dart` queda marcado como `@Deprecated`, porque la ruta activa del módulo ya está en `presentation/providers/...`
2. `presentation/screens/cajas/cajas_list_screen.dart` y `presentation/screens/botellas/botellas_list_screen.dart` permanecen presentes pero vacíos; se documentan como placeholders fuera de uso actual y no se eliminan oportunistamente en esta fase de sync

---

## RESULTADO

Al finalizar 0.4.3 el módulo ya dispone de:

- foundation local-first
- outbox local
- push processor secuencial
- pull processor con reconciliación conservadora
- boundaries remotos separados para push y pull
- protección explícita de cambios locales pendientes frente al refresh remoto

---

## IMPACTO

- deja preparada la arquitectura bidireccional del módulo
- mantiene la DB local como source of truth operativo
- evita pisar trabajo local no convergido
- no inventa todavía contratos backend finales
- mejora la trazabilidad documental sobre residuos/legacy del baseline

---

## LIMITACIONES

Aún no incluye:

- integración real con backend Go
- DTOs/backend mapping definitivos
- delete remoto
- resolución de conflictos avanzada
- retry/backoff sofisticado
- compactación inteligente de queue
- UX final de sincronización

---

## CONCLUSIÓN

Phase 0.4.3 completa el circuito arquitectónico base de sincronización del módulo Plantel Exterior.

A partir de este punto el proyecto ya tiene:

- push controlado
- pull controlado
- reconciliación local explícita

sin romper el baseline local-first ni especular con un contrato backend todavía no modelado.
