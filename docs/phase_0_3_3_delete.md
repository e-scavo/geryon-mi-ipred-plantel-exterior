# Phase 0.3.3 — Delete

---

## Objetivo

Completar el CRUD base mediante la incorporación de borrado real de entidades persistidas, con confirmación previa y refresco consistente de los listados.

---

## Contexto inicial

Al cerrar 0.3.2 la aplicación ya soportaba:

- create
- update
- persistencia local
- listados funcionales

Pero seguía faltando la última operación básica del CRUD: delete.

---

## Problema a resolver

Sin borrado real, el sistema acumulaba registros sin posibilidad de depuración ni corrección estructural, lo cual reducía su utilidad operativa.

---

## Alcance de la subfase

### Incluye
- delete persistente de Caja PON / ONT
- delete persistente de Botella de Empalme
- confirmación previa
- invalidación de providers
- refresco automático de listas

### No incluye
- soft delete
- papelera
- auditoría
- sync backend

---

## Cambios implementados

### Repository contract
Se ampliaron los contratos del repository para exponer operaciones de borrado.

### Repository Drift
La implementación concreta agrega deletes por `id`.

### UI
Las cards de las entidades incorporan acción `Eliminar`.

### Confirmación
Antes del borrado se solicita confirmación al usuario.

---

## Resultado funcional

Después de 0.3.3 el sistema soporta CRUD base completo:

- Create
- Update
- Delete

sobre persistencia local real.

---

## Impacto arquitectónico

La subfase extiende la infraestructura existente sin rediseños:

- se reutiliza Drift
- se reutiliza Riverpod
- se reutiliza el mismo flujo general de invalidación/refresco

---

## Conclusión

Phase 0.3.3 completa el CRUD offline base del sistema y deja al producto en una posición donde ya es posible gestionar el ciclo de vida completo de las entidades del dominio dentro de la aplicación.