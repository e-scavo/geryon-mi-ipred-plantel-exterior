# Phase 0.3.2 — Update

---

## Objetivo

Agregar edición real de entidades ya existentes, reutilizando la estructura de formularios creada en 0.3.1 y persistiendo los cambios en la base local.

---

## Contexto inicial

Luego de 0.3.1 la aplicación ya permitía:

- listar entidades
- crear nuevas entidades
- persistirlas

Pero todavía no permitía modificar registros existentes.

---

## Problema a resolver

Sin update, el sistema seguía siendo incompleto desde el punto de vista operativo.

Una app de campo que crea registros pero no puede corregirlos ni actualizarlos queda rápidamente limitada.

---

## Alcance de la subfase

### Incluye
- edición de Caja PON / ONT
- edición de Botella de Empalme
- reutilización de formularios existentes
- precarga de datos
- actualización persistente
- conservación de identidad de entidad

### No incluye
- delete
- mejoras UX avanzadas
- sync backend

---

## Cambios implementados

### Formularios reutilizados
Los formularios de create pasan a soportar dos modos:

- alta
- edición

### Precarga
Cuando se abre el formulario en modo edición, los datos actuales se muestran precargados.

### Persistencia
El repository existente se reutiliza para aplicar el update.

### Coherencia temporal
Se conserva `createdAt` y se actualiza `updatedAt`.

---

## Resultado funcional

Después de 0.3.2 el sistema permite:

- editar registros existentes
- persistir cambios
- ver el resultado actualizado en las listas

---

## Impacto arquitectónico

La subfase mantiene la arquitectura previa:

- sin cambios de runtime
- sin cambios de backend
- sin cambios de storage engine

Se apoya sobre la base de 0.3.1 y la extiende.

---

## Conclusión

Phase 0.3.2 completa la segunda operación crítica del CRUD y transforma el sistema en una herramienta que ya no solo registra datos, sino que puede corregirlos y mantenerlos actualizados de forma persistente.