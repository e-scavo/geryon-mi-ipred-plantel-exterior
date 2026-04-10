# Phase 0.5.1 — Operational Fields Baseline

This document records the first controlled movement of Phase 0.5 — Domain Operational Consolidation.

The goal of this subphase is not to change synchronization ownership or to integrate the real backend yet. The goal is to make the local domain more useful for technical outside-plant work while preserving the current local-first architecture.

---

## Objective

Extend the active outside-plant domain entities and the active UX surfaces with richer operational information, without breaking:

- current Drift persistence
- current queue-based sync trace
- current push/pull baseline
- current runtime ownership under `ServiceProvider`

---

## Scope

Included in this subphase:

- additive operational fields in Caja PON / ONT and Botella de Empalme
- active form support for the new fields
- richer operational summaries in active list cards
- cumulative documentation updates

Explicitly not included yet:

- real backend Go DTO alignment
- relationship modeling between cajas and botellas
- topology or map logic
- background sync
- ServiceProvider redesign

---

## Operational Fields Introduced

The local domain now supports the following additive fields in both main outside-plant entities:

- `codigoTecnico`
- `referenciaExterna`
- `observacionesTecnicas`
- `estadoOperativo`
- `criticidad`
- `zona`
- `sector`
- `tramo`

All fields remain optional so existing data and migration safety are preserved.

---

## UX Impact

The active create/edit forms now allow the user to capture the richer operational context directly from the module UI.

The active list screens now expose enough context to inspect a row operationally without opening the editor every time, while still preserving the visible sync badge introduced in 0.4.4.

---

## Architectural Impact

This subphase does not introduce new runtime ownership.

The same architecture remains in force:

- local database stays authoritative for module truth
- save/delete mutations still pass through the feature sync layer
- queue snapshots still represent the unit of future remote convergence
- push/pull remain manual and presentation-controlled

The improvement is domain richness, not architectural redirection.

---

## Deferred Dependencies

The final backend alignment remains intentionally deferred.

A future backend-integration phase will still require:

- Go structs for cajas
- Go structs for botellas
- real backend send contract details
- final convergence/mapping rules

Phase 0.5.1 prepares the local module for that future work without inventing those contracts now.
