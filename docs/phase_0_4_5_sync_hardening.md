# Phase 0.4.5 — Sync Hardening

## Objective

Phase 0.4.5 hardens the synchronization baseline already introduced in 0.4.1–0.4.4 so the module closes Stage 0 synchronization work with a single valid manual execution path and without residual invalid Riverpod wiring.

This subphase does not add new synchronization capabilities. It removes architectural residue, reinforces presentation-state guards and makes the visible push/pull behavior safer under repeated interaction.

## Baseline Taken From The Real Project

This phase starts from the already validated 0.4.4 baseline:

- local Drift persistence remains the operational source of truth
- CRUD flows already enqueue local sync work
- push and pull processors already exist and are still stub-safe on the remote side
- the module home already exposes sync summary, feedback and action surfaces
- the active sync UX path was corrected so buttons no longer mutate another provider during provider initialization
- residual FutureProvider-based action wrappers still remained in the codebase even though they were no longer the primary UI path

## Problem Statement

By the end of 0.4.4, the user-facing sync UX worked, but the module still had some structural loose ends:

- residual action providers still expressed the old invalid provider-mutation pattern
- manual push and pull needed a formally hardened single-path execution model
- UI running-state guards relied too heavily on button disabling alone
- home wording still reflected the UX-baseline phase rather than the hardening closure of 0.4

## Scope

This phase hardens the existing synchronization baseline without changing the local-first architecture.

Included in scope:

- removal of residual invalid sync action providers
- stronger execution guards in the sync UI notifier
- single-path manual execution maintained in the action card
- normalized snackbar feedback for push and pull actions
- home text refresh aligned to hardening scope
- cumulative trunk documentation updates

Out of scope:

- real backend contract integration
- queue compaction
- background retries
- automatic scheduling
- lifecycle-driven sync orchestration
- placeholder wrapper screen cleanup
- removal of the deprecated application/provider path

## Files Added

- `docs/phase_0_4_5_sync_hardening.md`

## Files Updated

- `lib/features/plantel_exterior/presentation/providers/outside_plant_mutations_provider.dart`
- `lib/features/plantel_exterior/presentation/providers/outside_plant_sync_ui_provider.dart`
- `lib/features/plantel_exterior/presentation/widgets/outside_plant_sync_actions_card.dart`
- `lib/features/plantel_exterior/presentation/screens/plantel_exterior_home_view.dart`
- `README.md`
- `docs/index.md`
- `docs/architecture.md`
- `docs/flows.md`
- `docs/decisions.md`

## Implementation Characteristics

### 1. Residual Invalid Action Providers Are Removed

The old `runOutsidePlantPushSyncActionProvider` and `runOutsidePlantPullSyncActionProvider` providers are removed in this phase.

They were no longer the active path after the 0.4.4 fix, but keeping them in place would preserve an architecturally unsafe pattern in the codebase:

- provider execution wrapping a command-like action
- direct mutation of presentation sync UI state during that execution path
- future regression risk if reused later by mistake

Removing them is safer than merely marking them deprecated.

### 2. Sync UI Notifier Now Enforces Concurrency Rules

The sync UI notifier now blocks execution starts when another sync action is already active.

This creates a two-layer defense:

- buttons remain disabled while an action is running
- notifier methods still reject a second start request if one somehow slips through

This avoids depending only on visual state for correctness.

### 3. Action Card Keeps The Only Supported Manual Execution Path

The action card remains the active manual control surface for push and pull.

Its behavior is now explicit and hardened:

- ask notifier for permission to start
- run the existing processor-backed provider
- store the final summary or error in the sync UI notifier
- show one consistent snackbar message
- reject concurrent execution with a short visible explanation

### 4. Hardening Does Not Alter Processor Ownership

This phase does not change:

- push processor responsibilities
- pull processor responsibilities
- local queue design
- list/provider invalidation ownership
- remote stub behavior

The purpose here is hardening the supported execution path, not redesigning the synchronization architecture.

## Architectural Notes

This phase deliberately keeps the following controlled as-is:

- ServiceProvider global ownership
- local-first operational truth
- stub-safe remote adapters
- deprecated `application/providers/outside_plant_mutations_provider.dart` file still present but out of the active path
- empty `cajas_list_screen.dart` and `botellas_list_screen.dart` wrappers still documented but untouched

## Risks And Constraints

### Risk 1 — Over-cleaning During Hardening

This phase must remove unsafe residue without turning into a broad cleanup pass.

Mitigation:

- remove only the residual invalid action providers
- keep legacy/deprecated and placeholder files documented but untouched

### Risk 2 — Hidden Re-entry Paths In Future UI Reuse

Mitigation:

- notifier-level concurrency guard remains even though buttons are also disabled
- manual sync execution keeps a single supported path

### Risk 3 — Misrepresenting Backend Readiness

Mitigation:

- no real backend wiring is introduced here
- no speculative Go mapping is added
- processor and queue behavior remain exactly within the current controlled scope

## Validation Expectations

Local validation should confirm at least:

- push still executes from the module home
- pull still executes from the module home
- a second action cannot start while the first one is running
- snackbar feedback remains coherent for success and error paths
- pending counters and list providers still refresh after execution
- web and android continue to compile and run

## Outcome

After Phase 0.4.5:

- synchronization keeps the same visible baseline UX introduced in 0.4.4
- only one supported manual execution path remains for push and pull
- residual invalid Riverpod action wiring is removed from the active codebase
- notifier state is more predictable under repeated interaction
- the synchronization roadmap for Phase 0.4 is closed in a more stable and controlled condition
