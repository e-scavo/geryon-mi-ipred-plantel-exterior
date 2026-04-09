# Phase 0.4.4 — Sync UX Baseline

## Objective

Phase 0.4.4 converts the synchronization layer from a purely technical validation surface into a minimum usable UX baseline for the outside-plant module.

The purpose of this subphase is not to harden sync behavior yet. The purpose is to make the existing local-first model, pending queue, push cycle and pull cycle understandable and visible from the module UI without inventing backend contracts or changing runtime ownership.

## Baseline Taken From The Real Project

This phase starts from the already consolidated 0.4.3 baseline:

- local Drift persistence remains the operational source of truth
- CRUD flows already enqueue local sync work
- controlled push processor already exists
- controlled pull processor already exists
- remote adapters remain stub-safe and non-speculative
- the active provider wiring lives under `presentation/providers/...`
- the module home already exposes technical push and pull triggers

## Problem Statement

By the end of 0.4.3 the synchronization architecture existed, but the user-facing experience was still too technical:

- sync state was present in the model but not consistently emphasized in the UI
- push and pull results were visible only through transient actions
- there was no reusable UI state holder for the last sync cycle summaries
- pending, synced and error states were not surfaced with a consistent visual language across the module
- the module home still behaved more like a technical verification screen than a baseline operational UX surface

## Scope

This phase adds only the minimum UX layer necessary to make synchronization visible and coherent.

Included in scope:

- reusable sync status badge widget
- sync summary card on the module home
- sync action card with controlled loading states
- sync feedback banner for the most recent visible result
- UI provider for ephemeral sync summaries and execution state
- list-level sync visibility on cajas and botellas cards
- form-level contextual message on edition flows when a row will return to `pending`
- cumulative trunk documentation updates

Out of scope:

- automatic retries
- background sync
- lifecycle-driven sync orchestration
- queue compaction
- conflict resolution UX
- remote delete UX
- real Go-backed payload integration

## Files Added

- `lib/features/plantel_exterior/presentation/providers/outside_plant_sync_ui_provider.dart`
- `lib/features/plantel_exterior/presentation/widgets/outside_plant_sync_status_badge.dart`
- `lib/features/plantel_exterior/presentation/widgets/outside_plant_sync_summary_card.dart`
- `lib/features/plantel_exterior/presentation/widgets/outside_plant_sync_actions_card.dart`
- `lib/features/plantel_exterior/presentation/widgets/outside_plant_sync_feedback_banner.dart`
- `docs/phase_0_4_4_sync_ux_baseline.md`

## Files Updated

- `lib/features/plantel_exterior/presentation/providers/outside_plant_mutations_provider.dart`
- `lib/features/plantel_exterior/presentation/screens/plantel_exterior_home_view.dart`
- `lib/features/plantel_exterior/presentation/screens/cajas_pon_ont_screen.dart`
- `lib/features/plantel_exterior/presentation/screens/botellas_empalme_screen.dart`
- `lib/features/plantel_exterior/presentation/screens/cajas/caja_form_screen.dart`
- `lib/features/plantel_exterior/presentation/screens/botellas/botella_form_screen.dart`
- `README.md`
- `docs/index.md`
- `docs/architecture.md`
- `docs/flows.md`
- `docs/decisions.md`

## Implementation Characteristics

### 1. Ephemeral Sync UX State

A dedicated presentation provider now stores:

- whether push is currently running
- whether pull is currently running
- last visible push summary
- last visible pull summary
- last visible error message

This state is intentionally UI-scoped and ephemeral. It does not belong in the database because it represents user feedback context, not durable operational truth.

### 2. Reusable Visual Language For Sync State

A reusable sync badge was added so that the same visual semantics can be used across module screens:

- `pending`
- `synced`
- `error`

This avoids free-text-only rendering and gives the list cards a clear local convergence signal.

### 3. Home Screen Upgraded From Technical Trigger To UX Baseline

The home now exposes:

- high-level module counters
- synchronization summary card
- feedback banner for the latest visible cycle result
- synchronization actions card with loading protection
- explanatory scope notes that reinforce the local-first operating model

### 4. Mutation Action Providers Now Feed UX Summaries

The controlled push and pull actions still use the same processors, but now also update the UI sync state so the module can render a stable summary instead of relying only on temporary snackbars.

### 5. List And Form Surfaces Now Reflect Sync State More Clearly

The cajas and botellas list cards now show a dedicated sync badge.

The edit forms now display the current row status and explicitly explain that saving changes will set the row back to `pending` until a later push converges it again.

## Architectural Notes

This phase deliberately does **not** change:

- ServiceProvider global ownership
- queue design
- push/pull processor boundaries
- stub-safe remote contracts
- placeholder empty wrapper screens
- deprecated legacy provider file removal timing

The UX baseline is therefore additive and controlled.

## Risks And Constraints

### Risk 1 — Overstating Sync Capability

The UI must not imply that synchronization is already fully automatic or production-integrated.

Mitigation:

- explicit wording remains controlled
- push and pull actions are still manual
- remote adapters remain documented as controlled/stub-safe

### Risk 2 — Mixing Durable State With UX Feedback

Mitigation:

- execution summaries stay in a presentation provider
- durable sync truth remains in local entity state and queue state

### Risk 3 — Premature Cleanup During A UX Phase

Mitigation:

- deprecated provider path remains documented, not removed
- empty wrapper screens remain documented, not opportunistically deleted

## Validation Expectations

Local validation should confirm at least:

- module home renders summary/action/feedback surfaces correctly
- push button blocks while push is running
- pull button blocks while pull is running
- list cards render sync badges correctly
- edit forms show the contextual sync message for existing entities
- no runtime ownership regression occurs
- web and android continue to work

## Outcome

After Phase 0.4.4:

- sync is visible in the module with a stable baseline UX
- push and pull have clearer execution feedback
- per-record local convergence state is easier to understand
- the module remains local-first and non-speculative
- the project is better prepared for later sync hardening without requiring backend Go structures yet
