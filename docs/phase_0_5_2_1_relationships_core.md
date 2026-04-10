# Phase 0.5.2.1 — Relationships Core

## Objective

Introduce a minimal, local-first, sync-compatible relationship core for Plantel Exterior without forcing a final topology model or backend contract.

## Initial Context

Phase 0.5.1 had already consolidated:

- operational fields baseline for `CajaPonOnt`
- operational fields baseline for `BotellaEmpalme`
- additive Drift migration
- sync snapshots updated for entity fields
- local-first persistence preserved

At that point the module still modeled entities mostly in isolation. Real plantel exterior usage, however, requires expressing dependencies and derivations between multiple elements:

- caja → botella
- caja → caja
- botella → botella
- botella → caja

This phase addresses that structural gap locally, without moving yet into topology visualization or real backend integration.

## Scope

This subphase introduces:

- `OutsidePlantRelationship` as a new local domain entity
- a dedicated `outside_plant_relationships` table
- repository methods for list/save/delete/existence checks
- sync service support for create/update/delete queueing
- provider exposure for relationship reads and mutations
- documentation updates describing the architectural decision

This subphase does **not** introduce:

- relationship UI/editor screens
- topology visualization
- remote push/pull real wiring
- backend Go struct mapping

## Architectural Decision

The relationship model was intentionally implemented as a standalone table instead of embedding 1:1 references inside `CajaPonOnt` or `BotellaEmpalme`.

This keeps the model compatible with real operational scenarios where:

- one caja can depend on multiple botellas
- one caja can depend on multiple cajas
- one botella can derive toward multiple downstream elements

The relationship table is therefore the primary local truth for links.

## Data Model

The relationship core stores:

- `id`
- `source_entity_type`
- `source_entity_id`
- `target_entity_type`
- `target_entity_id`
- `relationship_type`
- `sync_status`
- `created_at`
- `updated_at`

Entity types currently supported:

- `caja_pon_ont`
- `botella_empalme`

Relationship type remains a plain string in this stage to avoid premature rigidity.

## Sync Impact

The relationship core enters the existing outbox pattern as a new syncable entity type:

- `outside_plant_relationship`

No queue redesign was required. The implementation only extends the current enqueue/dispatch/mark-synced path.

The remote side remains stub-safe and intentionally unresolved until real Go structures and backend contracts are provided.

## Validation Rules Introduced

The core introduces minimal integrity guards:

- unsupported entity types are rejected
- source and target IDs are required
- relationship type is required
- self-reference to the exact same entity is rejected
- duplicate exact links can be detected before create

## Deletion Strategy

This phase keeps deletion conservative and local:

- when a caja is deleted, its incoming/outgoing relationships are removed first
- when a botella is deleted, its incoming/outgoing relationships are removed first

This avoids orphan local relationship rows without introducing hard FK cascades.

## Conclusion

Phase 0.5.2.1 leaves Plantel Exterior structurally prepared for the next step:

- relationship management UI
- relationship-aware inspection
- later topology readiness
- later backend mapping against real Go contracts
