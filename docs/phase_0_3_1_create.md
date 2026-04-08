# Phase 0.3.1 — Create

---

## Objetivo

Incorporar la capacidad de alta real para las entidades principales del dominio, permitiendo crear nuevos registros persistidos localmente desde la interfaz del producto.

---

## Contexto inicial

Al finalizar las fases 0.2.x el sistema ya contaba con:

- dominio modelado
- persistencia local real
- soporte multi-plataforma
- listados persistidos

Sin embargo, todavía no existía una operación real de creación desde UI.

---

## Problema a resolver

La aplicación podía consultar y mostrar datos persistidos, pero no permitía generar nuevas entidades desde el flujo normal de uso.

Eso dejaba al sistema en un estado de lectura, no de operación real.

---

## Alcance de la subfase

### Incluye
- formularios de alta para Caja PON / ONT
- formularios de alta para Botella de Empalme
- validación básica inicial
- guardado persistente
- refresco de listados

### No incluye
- edición
- eliminación
- mejoras UX avanzadas
- sync backend

---

## Cambios implementados

### Formularios nuevos
Se incorporaron formularios específicos de creación para ambas entidades.

### Persistencia
Los formularios guardan directamente contra el repository ya existente.

### Integración con listados
Al volver del formulario, los providers se invalidan y los listados se actualizan con la nueva entidad.

---

## Resultado funcional

Después de 0.3.1 el sistema permite:

- crear cajas
- crear botellas
- persistirlas localmente
- verlas inmediatamente en pantalla

---

## Impacto arquitectónico

No se modificó:

- runtime
- backend
- domain contract base
- persistencia existente

La subfase se limitó a extender la superficie operativa del sistema.

---

## Conclusión

Phase 0.3.1 convierte al sistema en una aplicación capaz de operar sobre su propio dominio, dejando atrás el estado de mera consulta persistida e introduciendo la primera operación real del CRUD.