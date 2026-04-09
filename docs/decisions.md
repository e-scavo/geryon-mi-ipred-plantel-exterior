# Decisions

This document captures all confirmed technical and architectural decisions for the repository.

These decisions are **binding** and must not be re-discussed unless explicitly invalidated by a future phase.

The content is cumulative and aligned strictly with the real repository (ZIP as source of truth).

---

## Current Context

- Stage: Stage 0 — Technical Bootstrap
- Phase: Phase 0 — Technical Bootstrap
- Subphase: Phase 0.4.2 — Backend Push Sync

---

## Decision Philosophy

All decisions follow these principles:

- stability over innovation during bootstrap
- reuse of proven technical components
- minimal changes to runtime behavior
- explicit constraints to avoid architectural drift
- alignment with real implementation (ZIP)

---

## Identity Decisions

### 1. Product Identity

The repository represents a **new product**, not a continuation of the original.

- Name: Mi IP·RED Plantel Exterior
- Domain: FTTH outside-plant management
- Product type: field operational application

Implication:

- original product behavior is not authoritative
- inherited code is technical base only

---

### 2. Dart Package Name

The Dart package name is fixed:

    mi_ipred_plantel_exterior

Must be applied in:

- pubspec.yaml
- project identity

---

### 3. Android Application Identity

The Android identity is fixed:

    applicationId: com.geryon.mi_ipred_plantel_exterior
    namespace: com.geryon.mi_ipred_plantel_exterior

Must be applied consistently across:

- build.gradle / build.gradle.kts
- AndroidManifest.xml

---

## Architecture Decisions

### 4. Runtime Ownership

The runtime owner is:

    ServiceProvider

Rules:

- must remain the central orchestrator
- must not be redesigned during bootstrap
- must not be bypassed by UI or other layers

---

### 5. Provider System

State management is based on:

    Riverpod

Rules:

- providers remain the integration layer between UI and runtime
- global providers defined in common_vars.dart must remain stable
- no alternative state management introduced during bootstrap

---

### 6. Transport Layer

Backend communication is based on:

    WebSocket

Rules:

- persistent connection model must be preserved
- request/response must remain stateful
- no REST replacement or abstraction introduced

---

### 7. Backend Contract

The repository must reuse the **real existing backend contract**.

Rules:

- do not invent a replacement contract during bootstrap
- adapt future domain work to the real contract
- preserve compatibility with the current backend

---

### 8. Runtime Refactor Policy

During Stage 0:

- no deep ServiceProvider refactor
- no runtime decomposition for aesthetic reasons
- no transport redesign

Allowed:

- minimal safe changes only when required by the active phase

---

## Domain Decisions

### 9. Product Domain

The target domain is:

- passive FTTH outside-plant management

This is the authoritative product direction.

---

### 10. Initial Domain Entities

The domain must explicitly include from the beginning:

1. Caja PON / ONT
2. Botella de Empalme

Rule:

- the system must not be designed as if only one entity exists

---

### 11. CRUD Timing

CRUD for domain entities is **not** part of the controlled clone phase.

Rule:

- defer CRUD until after the technical baseline is stable

---

### 12. Offline Strategy

Offline support is required in the product roadmap, but not in Phase 0.1.

Expected future simplified states:

- pending
- synchronized
- error

---

### 13. Persistence Strategy

Real local persistence is required for the real persistence phase.

Rule:

- do not adopt lightweight placeholder persistence as the product core

However:

- full persistence implementation is deferred beyond Phase 0.1

---

### 14. Map Strategy

Confirmed map technology:

    flutter_map

Rule:

- future map features must be built on flutter_map
- do not introduce an alternative mapping stack

---

## Navigation Decisions

### 15. Navigation Evolution

The application will need a scalable navigation baseline.

Rule:

- this is acknowledged during bootstrap
- but Phase 0.1 does not perform a navigation redesign yet

---

## Platform Decisions

### 16. Supported Platforms

Current supported platforms:

- Web
- Android

Deferred:

- iOS

Rule:

- all bootstrap work must preserve Web + Android compatibility

---

## Repository Hygiene Decisions

### 17. Publication Residue Removal

Inherited publication and release artifacts must be removed from the new repository baseline.

Includes:

- distribution artifacts
- submission bundles
- signing residue
- product-specific publication identity

---

### 18. Signing Isolation

Signing-related inherited artifacts from the original repository must not remain as active operational residue.

Reason:

- avoid accidental release coupling between products

---

## Documentation Decisions

### 19. ZIP as Source of Truth

The attached ZIP is the only authoritative source of truth.

Rules:

- if chat memory conflicts with ZIP → ZIP wins
- docs must reflect ZIP
- implementations must be aligned with ZIP

---

### 20. Documentation Style

Documentation must be:

- cumulative
- incremental
- full-file based
- copy/paste safe

Forbidden:

- placeholders
- destructive summarization
- fragmented markdown delivery

---

### 21. Phase Documentation Requirement

Every phase/subphase must have a dedicated full document.

Rule:

- no phase can be considered complete without documentation

---

## Safety/Change Decisions

### 22. Stability Priority

Bootstrap phases prioritize:

1. runtime stability
2. backend compatibility
3. identity separation
4. safe future extensibility

---

### 23. Minimal Change Principle

Changes should be:

- controlled
- minimal
- justified by current phase scope

Forbidden:

- unnecessary redesign
- speculative cleanup
- broad refactors without phase need

---

### 24. Transitional Tolerance

During bootstrap, the repository may temporarily contain:

- inherited UI
- inherited flows
- non-final product surface

This is acceptable if:

- runtime remains stable
- documentation is explicit
- the final product direction remains clear

---

### 25. Product Surface Transition

Inherited customer-facing screens may remain temporarily while the controlled clone baseline is being established.

Rule:

- do not remove them aggressively before the new product surface is ready

---

## Risk Decisions

### 26. Stability Priority

Priority order:

1. runtime stability
2. backend compatibility
3. identity separation
4. future scalability

---

### 27. Controlled Transition

The system may temporarily:

- contain inherited UI
- expose non-final flows

This is acceptable during bootstrap.

---

## Future-Oriented Decisions

### 28. Domain Evolution

Future phases will introduce:

- entity modeling
- field workflows
- map integration
- offline behavior
- local database usage

---

### 29. Progressive Replacement

Inherited elements will be:

- replaced gradually
- not removed abruptly

This reduces risk.

---

## Summary

These decisions define:

- what is fixed
- what is allowed
- what is forbidden

They ensure:

- consistency
- stability
- controlled evolution

Any implementation that violates these decisions must be considered incorrect.

---

## Conclusion

This document acts as the contract for all technical work in the repository.

During Phase 0.1, the focus is:

- identity normalization
- runtime preservation
- repository cleanup

All future phases must build on top of these decisions without breaking them.

---

## Phase 0.2.1 Decisions

### 30. Visible Post-Login Surface Replacement

Decision:

The inherited customer dashboard must stop being the primary visible post-login surface.

Reason:

The new repository already has its own product identity and domain. Keeping the customer dashboard as the visible entrypoint would preserve a false product surface.

Impact:

The application now enters through a Plantel Exterior home surface.

---

### 31. Drawer-Based Main Navigation

Decision:

The first navigation baseline for the new product surface must use a drawer or equivalent simple scalable pattern.

Reason:

The project needs an extensible entry navigation, but the phase must remain low risk and avoid premature complexity.

Impact:

A drawer-based navigation baseline becomes the first visible domain shell.

---

### 32. Both Core Domain Entities Must Exist From the First Visible Domain Phase

Decision:

Phase 0.2.1 must expose both initial domain entities:

- Caja PON / ONT
- Botella de Empalme

Reason:

The product must not be shaped around a single initial entity. Both must be acknowledged from the beginning.

Impact:

Both sections now exist as real navigable screens, even though still in skeleton form.

---

### 33. Skeleton Screens Are Valid at This Stage

Decision:

At this stage, the domain sections may be implemented as functional skeletons instead of full CRUD screens.

Reason:

The objective of the phase is to establish visible product direction and navigation, not complete operational logic.

Impact:

The project gains a real domain shell without introducing premature complexity.

---

### 34. Legacy Modules May Remain Internally While the Visible Surface Changes

Decision:

Inherited modules do not need to be removed yet, as long as they stop being the visible primary surface.

Reason:

Abrupt deletion increases risk and can remove useful technical references.

Impact:

Transition remains controlled and reversible while future phases progressively replace inherited surfaces.

---

### 35. Runtime Ownership Remains Untouched During Visible Surface Transition

Decision:

The visible transition introduced in Phase 0.2.1 must not alter ServiceProvider ownership or backend flow control.

Reason:

The new visible shell is not a justification for runtime redesign.

Impact:

The project preserves its most critical stable subsystem while evolving product identity.

---

## Updated Summary After Phase 0.2.1

Project decisions now establish that:

- Phase 0.1 created the technical clone baseline
- Phase 0.2.1 created the first visible domain shell
- future phases will build on top of that shell instead of returning to the inherited customer dashboard

---

## Phase 0.2.2 Decisions

### 36. Introduce the domain layer before persistence

Decision:

The repository must introduce real domain entities and shared value objects before implementing local persistence.

Reason:

This avoids tying business structure to premature storage decisions and creates a clean base for repository implementations.

Impact:

The product now has a typed domain layer without forcing database choices yet.

---

### 37. Domain entities must be immutable

Decision:

The first domain entities are implemented as immutable objects.

Reason:

Immutability improves predictability, makes state transitions safer, and prepares the project for future sync/offline workflows.

Impact:

Future persistence and synchronization logic can evolve on top of stable entity snapshots.

---

### 38. Introduce value objects early

Decision:

Dedicated value objects such as `OutsidePlantId` and `GeoPoint` must exist from the first domain phase.

Reason:

This avoids primitive obsession and centralizes meaning for identifiers and coordinates.

Impact:

Future domain growth will be more consistent and easier to validate.

---

### 39. Introduce sync-oriented state as a domain concept

Decision:

A shared `SyncStatus` enum is introduced before implementing actual synchronization.

Reason:

The product roadmap already assumes offline/simple sync states, so the domain should acknowledge them early.

Impact:

The codebase gains a stable semantic placeholder for future offline-first behavior.

---

### 40. Define repository contract before repository implementation

Decision:

A repository contract must be introduced now, but its implementation is deferred.

Reason:

This creates a clean architectural boundary between domain and future data sources such as local DB, backend, or hybrid persistence.

Impact:

Later phases can implement storage without having to redesign domain-facing APIs first.

---

### 41. Presentation must stop depending on pure placeholder text

Decision:

The Plantel Exterior screens must begin depending on real domain objects rather than placeholder-only messages.

Reason:

Without domain-aware presentation, the repository would remain visually reoriented but structurally empty.

Impact:

The visible product shell now reflects real domain code.

---

### 42. Keep runtime untouched during domain introduction

Decision:

Phase 0.2.2 must not alter ServiceProvider, startup orchestration, backend transport or session continuity.

Reason:

The purpose of the phase is domain introduction, not runtime redesign.

Impact:

The new domain baseline is introduced with minimal operational risk.

---

## Updated summary after Phase 0.2.2

Project decisions now establish a three-step bootstrap sequence:

- Phase 0.1 → technical identity and controlled clone baseline
- Phase 0.2.1 → visible Plantel Exterior shell and navigation entry
- Phase 0.2.2 → first real domain entities, value objects and repository contract baseline

Future phases must build on this sequence instead of bypassing it.


---

## Phase 0.2.3 Decisions

### 43. Introduce a real persistence layer before CRUD UI

Decision:

The repository must gain a real local persistence layer before implementing full create/edit/delete flows.

Reason:

CRUD UI without durable local storage would create another temporary layer and force avoidable rework in later phases.

Impact:

Persistence now becomes part of the core Plantel Exterior feature baseline.

---

### 44. Use Drift as the local persistence baseline

Decision:

Phase 0.2.3 adopts Drift 2.31.0 as the persistence baseline for the Plantel Exterior module.

Reason:

Drift provides a typed local data layer with generated models and a clean mapping path between database records and domain entities while remaining compatible with the current SDK constraints of the project baseline.

Impact:

The repository now has a structured, code-generated local persistence layer suitable for future CRUD and offline work.

---

### 45. Keep the domain layer free from persistence concerns

Decision:

The domain layer must not import Drift, SQL-specific types or database classes.

Reason:

The domain introduced in Phase 0.2.2 must remain reusable and independent of the chosen persistence technology.

Impact:

Mappers now absorb the translation responsibility between local tables and domain entities.

---

### 46. Implement repository pattern before adding multiple data sources

Decision:

The first concrete persistence integration must still respect the repository boundary introduced in Phase 0.2.2.

Reason:

The repository contract is the correct seam for future local/backend or hybrid implementations. Bypassing it now would undermine the purpose of the previous phase.

Impact:

UI and providers consume `OutsidePlantRepositoryContract` semantics through a concrete Drift implementation.

---

### 47. Seed initial local data for baseline usability

Decision:

Phase 0.2.3 includes controlled initial seed data when local storage is empty.

Reason:

The feature needs deterministic visible data for validation and early testing even before CRUD forms exist.

Impact:

The module is persistence-backed and immediately testable after first run.

---

### 48. Add application-layer providers for persistence-backed reads

Decision:

Persistence-backed reads must be exposed to the presentation layer through Riverpod providers rather than direct widget/database coupling.

Reason:

This keeps the architecture layered and maintains the same discipline used for other state boundaries in the repository.

Impact:

The home screen, cajas screen and botellas screen now load through feature/application providers.

---

### 49. Defer web persistence support to a later phase

Decision:

Phase 0.2.3 does not enable web persistence.

Reason:

The web path adds platform-specific complexity that is orthogonal to the goal of introducing the first local persistence baseline.

Impact:

The current database opening path explicitly rejects web execution, and web support must be treated as a dedicated later phase.

---

### 50. Keep runtime untouched during persistence introduction

Decision:

Phase 0.2.3 must not alter ServiceProvider, startup orchestration, backend transport or session continuity.

Reason:

Persistence introduction remains a feature/data concern and must not expand into a runtime redesign.

Impact:

The new persistence baseline is introduced with minimal operational risk.

---

## Updated summary after Phase 0.2.3

Project decisions now establish a four-step bootstrap sequence:

- Phase 0.1 → technical identity and controlled clone baseline
- Phase 0.2.1 → visible Plantel Exterior shell and navigation entry
- Phase 0.2.2 → first real domain entities, value objects and repository contract baseline
- Phase 0.2.3 → first concrete local persistence layer with Drift-backed repository reads

Future phases must build on this sequence instead of bypassing it.

---

## Phase 0.2.4 Decisions

### 51. Enable web-compatible persistence

Decision:

Persistence must be extended to support Web execution.

Reason:

The product targets Web as a first-class platform.

Impact:

- persistence must be platform-aware
- WASM-based database handling is required

---

## Phase 0.3.1 Decisions

### 52. Introduce create operations over persistence

Decision:

The system must support entity creation backed by persistence.

Impact:

- repository must support insert
- UI must trigger creation flows

---

## Phase 0.3.2 Decisions

### 53. Introduce update operations over persistence

Decision:

The system must support entity updates.

Impact:

- repository must support update
- domain identity must be preserved

---

## Phase 0.3.3 Decisions

### 54. Introduce delete operations over persistence

Decision:

The system must support entity deletion.

Impact:

- repository must support delete
- UI must enforce confirmation

---

## Phase 0.3.4 Decisions

### 55. Introduce minimum UX layer over CRUD

Decision:

The system must include validation, feedback, and loading states.

Impact:

- improves usability
- reduces operational errors

---

## Updated summary after Phase 0.3.4

Project decisions now establish:

- Phase 0.1 → technical baseline
- Phase 0.2.x → domain + persistence
- Phase 0.3.x → full CRUD + UX layer

The system is now ready for backend synchronization phases.



---

### 18. Synchronization Foundation Strategy

Phase 0.4.1 must prepare synchronization without introducing real backend transport behavior yet.

Rules:

- keep local DB as operational source of truth
- introduce explicit local queue for pending synchronization
- avoid inventing backend payload contracts
- keep synchronization orchestration outside widgets
- keep global runtime ownership unchanged

---

### 19. Module Sync Boundary

The outside-plant module now has a dedicated sync boundary.

Current contract:

    OutsidePlantSyncContract

Rule:

- queue persistence and queue-state mutations must go through this boundary
- UI must not write queue rows directly

---

### 20. Delete Trace Policy in 0.4.1

In this subphase, delete operations must leave a synchronization trace before local removal.

Rule:

- capture queue tombstone first
- remove local row after trace is stored

Reason:

- preserve future push intent
- avoid forcing speculative backend modeling
- avoid expanding table semantics prematurely in the same controlled subphase

---

### 21. Push Processor Must Exist Before Real Backend Wiring

Phase 0.4.2 must complete the queue-processing architecture even if the real backend contract is not yet available.

Reason:

- the module needs a stable internal pipeline before transport binding
- this prevents UI/backend coupling
- this allows later Go-backed integration to replace only the remote adapter layer

---

### 22. Remote Adapter May Be Controlled/Non-Productive in 0.4.2

During this subphase, the remote adapter is allowed to return an explicit controlled failure when the real contract is still unknown.

This is preferable to:

- inventing payloads
- hardcoding speculative endpoints
- pretending convergence exists when it does not

---

### 23. CRUD Mutations Must Not Bypass Feature Sync Layer

After 0.4.1 and 0.4.2, create/update/delete flows of the outside-plant module must route through the feature mutation layer so that:

- local persistence remains centralized
- sync queue trace is guaranteed
- future push/pull semantics remain coherent

---

### 24. Pull Refresh Must Preserve Pending Local State

Phase 0.4.3 introduces remote refresh, but this refresh must remain conservative.

Rule:

- remote data may update only local rows that are already `synced`
- local rows in `pending` or `error` must not be overwritten automatically

Reason:

- preserve local-first ownership
- avoid losing unsent local work
- avoid fake conflict resolution before the real backend contract exists

---

### 25. Remote Pull Contract Must Be Non-Speculative

The pull side of the module may introduce a dedicated remote boundary before the final Go structures are available.

Rule:

- use generic map-based snapshots for now
- do not invent final backend DTOs or transport assumptions

---

### 26. Legacy Provider Path Must Be Marked, Not Removed Yet

The old file under `application/providers/outside_plant_mutations_provider.dart` is no longer the active feature wiring.

Rule:

- mark it deprecated now
- keep it in place until a later cleanup phase explicitly removes it

---

### 27. Empty Wrapper Screens Must Be Documented Explicitly

The current project baseline still contains empty files for list wrappers under `presentation/screens/cajas` and `presentation/screens/botellas`.

Rule:

- do not silently ignore them
- do not opportunistically delete them in a sync phase
- document their placeholder status and defer cleanup/reuse to a later UI phase


---

### 28. Synchronization Execution Feedback Must Stay In Presentation State

Push/pull execution summaries are useful for UX but they are not durable domain truth.

Rule:

- keep the latest summaries and running flags in a presentation provider
- do not add them to the database in 0.4.4
- keep durable synchronization truth in entity state and queue state

---

### 29. Synchronization Status Must Use A Reusable Visual Badge

The module already exposes `pending`, `synced` and `error` in the domain. 0.4.4 formalizes a reusable visual language for those states.

Rule:

- use a reusable sync status badge widget
- avoid ad hoc free-text-only rendering where the row state matters
- keep per-record sync visibility lightweight and consistent

---

### 30. Sync UX Baseline Must Remain Manual And Honest

This phase improves usability, but it must not imply that the module already has background sync or final backend integration.

Rule:

- keep push and pull user-triggered
- show clear feedback about recent execution
- do not overstate the current backend readiness before real Go structures are wired


---

### 31. Residual Invalid Sync Action Providers Must Be Removed

Once the active UI path was corrected in 0.4.4, leaving the old provider-based action wrappers in the codebase would preserve a dormant invalid pattern and invite regressions.

Rule:

- remove residual action providers that mutate sync UI state during provider execution
- keep a single supported manual execution path
- prefer deletion over deprecation when the residual code is already architecturally unsafe

---

### 32. Concurrency Guards Belong In The Sync UI Notifier

Blocking duplicate or crossed manual sync actions is presentation behavior, but it should still be enforced centrally instead of only relying on disabled buttons.

Rule:

- let the sync UI notifier reject `startPush()` or `startPull()` when another execution is already active
- keep buttons visually disabled as the first barrier
- keep notifier guards as the second barrier so rapid interaction or future UI reuse cannot bypass the rule
