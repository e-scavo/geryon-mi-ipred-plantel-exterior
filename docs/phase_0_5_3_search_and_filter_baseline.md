# Phase 0.5.3 — Search and Filter Baseline

## Objective
Add a first local search and filter layer to the active outside plant listing screens so technicians can find already-loaded entities faster without introducing remote search, advanced indexing, or topology-aware filtering.

## Initial Context
By the close of Phase 0.5.2.2, the module already supported:

- enriched local domain fields for cajas and botellas
- local-first persistence and synchronization
- relationship core and minimum relationship UI
- active operational listing screens for cajas and botellas

That baseline was already structurally solid, but day-to-day usability still depended on manually scanning cards in each listing.

## Problem Statement
The active listing screens exposed the available operational information, but they still lacked a first-class way to:

- search by technical or descriptive text
- filter by operational status
- filter by criticality
- filter by synchronization state
- quickly clear current criteria and return to the full list

This created friction as soon as the module began to accumulate more real entities.

## Scope
Phase 0.5.3 stays intentionally local and lightweight.

Included:

- search/filter state model in presentation
- local filtered providers for cajas and botellas
- reusable search/filter bar widget
- integration into the active listing screens
- empty-state differentiation between “no data” and “no matches”
- cumulative documentation updates

Explicitly excluded:

- remote search
- persisted saved filters
- relationship-aware filtering
- topological filtering
- form-level search
- DB/schema changes
- sync architecture changes

## Files Affected
Created:

- `lib/features/plantel_exterior/presentation/state/outside_plant_search_filters.dart`
- `lib/features/plantel_exterior/presentation/widgets/outside_plant_search_filter_bar.dart`
- `docs/phase_0_5_3_search_and_filter_baseline.md`

Modified:

- `lib/features/plantel_exterior/presentation/providers/outside_plant_providers.dart`
- `lib/features/plantel_exterior/presentation/screens/cajas_pon_ont_screen.dart`
- `lib/features/plantel_exterior/presentation/screens/botellas_empalme_screen.dart`
- `README.md`
- `docs/index.md`
- `docs/architecture.md`
- `docs/flows.md`
- `docs/decisions.md`

## Implementation Characteristics
The search/filter state is represented as a compact immutable object with a copy-based update flow.

Filtering is performed locally in memory over the already-loaded entity lists, using Riverpod providers to derive filtered outputs for each active screen.

The textual search baseline covers the most operationally useful fields currently available in the local domain:

- código
- descripción
- código técnico
- referencia externa
- observaciones técnicas
- zona
- sector
- tramo

The initial baseline filters are:

- estado operativo
- criticidad
- sync status

This keeps the UX compact while still addressing the highest-value operational use cases.

## UX Behavior
Each active listing screen now exposes:

- a local text search box
- compact inline dropdown filters
- a clear filters action
- contextual empty state when filters yield no results

The phase deliberately avoids modal-heavy search UX or advanced query builders.

## Validation Intent
The expected validation surface for this phase is:

- search updates visible results for cajas and botellas
- filters narrow results correctly
- clear returns the screen to the full list
- empty states remain understandable in both “no data” and “no match” scenarios
- no changes to sync, DB, or relationship workflows

## Architectural Impact
This phase adds a presentation-level search/filter baseline without altering domain persistence or synchronization responsibilities.

It improves operator usability while preserving the established local-first runtime and keeping the architecture aligned with the existing module boundaries.

## Conclusion
Phase 0.5.3 establishes the first usable search and filter layer for the module. It does not attempt to solve advanced lookup scenarios yet, but it meaningfully improves operational navigation and prepares the listing screens for richer inspection and filtering work in later phases.
