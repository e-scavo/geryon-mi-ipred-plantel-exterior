# Phase 0.5.2.2 — Relationships UI Minimum

## Objective

Expose the relationship core introduced in 0.5.2.1 through a minimal but usable presentation layer integrated into the active caja and botella forms.

## Initial Context

Before this subphase, the project already had:

- `OutsidePlantRelationship` as a local-first entity
- local persistence in `outside_plant_relationships`
- relationship-aware sync queue integration
- repository and provider support for relationship CRUD operations

What was still missing was a direct UI path for operators to inspect and manage those links.

## Scope

This subphase adds:

- a reusable relationships section widget
- a dedicated relationship editor dialog
- integration into `caja_form_screen.dart`
- integration into `botella_form_screen.dart`
- cumulative documentation updates

This subphase does not add:

- topology graph visualization
- advanced navigation between linked nodes
- relationship filtering/search beyond the existing form scope
- real backend contract mapping

## Files Created

- `lib/features/plantel_exterior/presentation/widgets/outside_plant_relationships_section.dart`
- `lib/features/plantel_exterior/presentation/widgets/outside_plant_relationship_editor_dialog.dart`
- `docs/phase_0_5_2_2_relationships_ui_minimum.md`

## Files Updated

- `lib/features/plantel_exterior/presentation/screens/cajas/caja_form_screen.dart`
- `lib/features/plantel_exterior/presentation/screens/botellas/botella_form_screen.dart`
- `README.md`
- `docs/index.md`
- `docs/architecture.md`
- `docs/flows.md`
- `docs/decisions.md`

## UX Behavior

### Existing entity in edit mode

The form now shows a dedicated relationships section where the operator can:

- list linked relationships
- create a new relationship
- delete a relationship with confirmation

### New entity in create mode

The form shows an informational message indicating that relationships become available only after the entity has been saved.

## Validation Rules

The dialog enforces:

- destination entity type is required
- destination entity is required
- relationship type is required
- self-links are rejected
- duplicate exact links are rejected by the core save flow

## Architectural Characteristics

- the relationship source is always the entity being edited
- the UI remains form-scoped and intentionally lightweight
- the solution reuses the existing Riverpod providers and mutations
- the sync baseline from 0.4.x and the relationship core from 0.5.2.1 remain unchanged

## Result

With 0.5.2.2, Plantel Exterior stops having relationships only at storage level and begins exposing them as a real operator-facing workflow, while still staying far away from a full topology editor.
