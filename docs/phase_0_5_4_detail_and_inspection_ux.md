# Phase 0.5.4 — Detail and Inspection UX

## Objective

This phase improves the operational readability of Plantel Exterior records without forcing the operator into edit flows. It adds a lightweight inspection surface on top of the existing listing screens for cajas PON / ONT and botellas de empalme.

## Scope

Included in this phase:

- richer visual summary on active listing cards
- explicit `Ver detalle` inspection action on cajas and botellas
- reusable inspection dialog for read-only operational review
- reusable detail section and metadata row widgets
- visibility of operational, technical, location and relationship context inside the inspection surface

Not included in this phase:

- topology view
- graph or map rendering
- backend real integration
- form redesign
- sync core changes

## Implementation Summary

The implementation keeps routing unchanged and uses a dialog-based inspection surface. This avoids navigation churn while giving the operator a dedicated space to inspect a record.

New widgets introduced:

- `outside_plant_detail_dialog.dart`
- `outside_plant_detail_section.dart`
- `outside_plant_metadata_row.dart`

Modified active listing screens:

- `cajas_pon_ont_screen.dart`
- `botellas_empalme_screen.dart`

## UX Behavior

From each active list card the operator can now:

- inspect the record through `Ver detalle`
- keep edit as a separate action
- read identity, state, technical context, location and timestamps in a dedicated surface
- inspect relationship context in read-only mode

## Architectural Notes

The inspection layer is intentionally read-only. Relationship CRUD remains in the form-driven flow added in phase 0.5.2.2. Search and filter behavior added in phase 0.5.3 remains unchanged and continues to drive the visible working set before detail inspection is opened.

## Validation Focus

The expected validation points for this phase are:

- cajas and botellas still open edit flows correctly
- `Ver detalle` opens the correct entity type
- relationship context is readable and non-destructive
- no change in DB schema or sync pipeline behavior
