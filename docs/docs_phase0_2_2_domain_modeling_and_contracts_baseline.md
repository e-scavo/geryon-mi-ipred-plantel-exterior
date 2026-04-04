# Phase 0.2.2 — Domain Modeling & Contracts Baseline

---

## Objective

Introduce the first real domain layer of **Mi IP·RED Plantel Exterior** without modifying runtime ownership, backend communication, login/session continuity or the visible navigation shell already established in Phase 0.2.1.

This phase must:

- preserve the proven technical baseline inherited from earlier phases
- convert the new product shell into a structurally domain-aware application
- introduce the first real business entities of the outside-plant domain
- establish reusable value objects and contracts for future persistence work
- keep the implementation low-risk and strictly incremental

---

## Initial Context

After Phase 0.2.1, the repository already had a visible product shell aligned with Mi IP·RED Plantel Exterior:

- the inherited customer dashboard had stopped being the primary visible post-login surface
- a drawer-based navigation shell already existed
- the first two domain sections were visible:
  - Caja PON / ONT
  - Botella de Empalme

However, the codebase still had an important limitation:

- the domain existed in documentation and screen labeling
- but it did not yet exist as a real shared structural layer in code

That meant the project had:

- a visible domain shell
- but no domain entities
- no shared value objects
- no repository boundary
- no domain-aware screen rendering

---

## Problem Statement

The repository had successfully moved from a customer-facing inherited surface to a new field-domain visible shell, but it still lacked the internal structural baseline required for any serious domain evolution.

More specifically, the system lacked:

- typed entities for core outside-plant objects
- shared value objects for identifiers and coordinates
- a domain-level sync/offline status concept
- a contract boundary for future persistence
- any real coupling between Plantel Exterior presentation and actual domain types

Without these pieces:

- future CRUD work would be built on ad-hoc UI data
- local persistence would have no stable domain contract to target
- offline and sync work would have no shared domain state model
- the visible shell would remain structurally shallow

---

## Scope

### Included in this phase

- introduction of a first domain package under the Plantel Exterior feature
- creation of immutable entities for:
  - `CajaPonOnt`
  - `BotellaEmpalme`
- creation of shared value objects:
  - `OutsidePlantId`
  - `GeoPoint`
- creation of a shared enum:
  - `SyncStatus`
- creation of a first repository contract:
  - `OutsidePlantRepositoryContract`
- replacement of placeholder-only section rendering with screens that depend on real domain entities
- update of the Plantel Exterior home content to reflect the existence of the new domain baseline

### Explicitly excluded

- database implementation
- repository implementation
- backend mapping for the new entities
- synchronization engine
- map interaction logic
- camera/media evidence flows
- runtime refactor
- ServiceProvider redesign
- transport redesign
- aggressive global navigation changes

---

## Root Cause Analysis

The root cause was not a transport, runtime or session problem.

The root cause was a **missing internal domain structure**.

Phase 0.2.1 intentionally focused on visible product decoupling and navigation entry.  
That solved the surface problem, but it intentionally left domain implementation for the next step.

As a result, the repository was in a transitional state where:

- the product looked like a Plantel Exterior application
- but internally the sections still behaved like placeholder-driven presentation

This created an architectural gap between:

- what the product claimed to be
- and what the code was actually modeling

Phase 0.2.2 exists to close that gap safely.

---

## Files Affected

### New files added

- `lib/features/plantel_exterior/domain/value_objects/outside_plant_id.dart`
- `lib/features/plantel_exterior/domain/value_objects/geo_point.dart`
- `lib/features/plantel_exterior/domain/enums/sync_status.dart`
- `lib/features/plantel_exterior/domain/entities/caja_pon_ont.dart`
- `lib/features/plantel_exterior/domain/entities/botella_empalme.dart`
- `lib/features/plantel_exterior/domain/contracts/outside_plant_repository_contract.dart`

### Existing files updated

- `lib/features/plantel_exterior/presentation/screens/cajas_pon_ont_screen.dart`
- `lib/features/plantel_exterior/presentation/screens/botellas_empalme_screen.dart`
- `lib/features/plantel_exterior/presentation/screens/plantel_exterior_home_view.dart`

### Documentation files updated

- `README.md`
- `docs/index.md`
- `docs/architecture.md`
- `docs/flows.md`
- `docs/decisions.md`
- `docs/phase0_2_2_domain_modeling_and_contracts_baseline.md`

---

## Implementation Characteristics

### 1. Minimal and controlled surface of change

The phase changes only what is necessary to introduce the first domain baseline:

- a new domain package
- three presentation files updated to consume the new structure
- no runtime-critical files modified

This keeps regression risk low.

### 2. Runtime preservation

The implementation preserves:

- `ServiceProvider`
- `notifierServiceProvider`
- startup bootstrap logic
- backend communication
- login/session continuity
- logout flow
- drawer-based navigation shell created in Phase 0.2.1

### 3. Domain first, persistence later

The new domain layer is intentionally introduced before any storage implementation.

This preserves clean separation between:

- business structure
- data source concerns
- transport concerns

### 4. Immutable modeling

The first entities are immutable and include typed fields prepared for later growth.

This is especially important for future:

- offline state handling
- sync transitions
- repository persistence
- copy/update semantics

### 5. Presentation made domain-aware

The Plantel Exterior screens no longer depend only on placeholder copy.  
They now instantiate and render explicit domain entities.

This is the first point where the visible product shell is backed by real business structure.

---

## Detailed Implementation Summary

### Step 1 — Value objects introduced

Two value objects are added:

- `OutsidePlantId`
- `GeoPoint`

These centralize:

- outside-plant identifiers
- geographic coordinates

They reduce primitive-only modeling and improve future consistency.

### Step 2 — Shared sync/offline enum introduced

A `SyncStatus` enum is added with:

- `pending`
- `synced`
- `error`

This does not implement synchronization yet, but it introduces a stable domain concept for future offline-first work.

### Step 3 — Core entities introduced

Two immutable entities are added:

- `CajaPonOnt`
- `BotellaEmpalme`

Each currently includes:

- `id`
- `codigo`
- `descripcion`
- `location`
- `syncStatus`
- optional creation/update timestamps

### Step 4 — Repository boundary introduced

A first domain contract is added:

- `OutsidePlantRepositoryContract`

Its purpose is to define future read/save operations without committing yet to a concrete storage implementation.

### Step 5 — Presentation integrated with domain

The following screens are updated:

- `CajasPonOntScreen`
- `BotellasEmpalmeScreen`
- `PlantelExteriorHomeView`

The two domain sections now instantiate and render real entities instead of showing placeholder-only empty-state widgets.

### Step 6 — Visible shell preserved

The visible shell created in Phase 0.2.1 remains the same:

- `PlantelExteriorHomeScreen`
- drawer navigation
- post-login visible entrypoint

This means the user-visible product flow remains stable while the internal domain baseline evolves.

---

## Validation

### Functional validation expected

After applying Phase 0.2.2:

- the app must keep starting normally
- the runtime bootstrap must remain intact
- the visible Plantel Exterior shell must remain the post-login surface
- the drawer must remain functional
- the Cajas section must render domain-backed content
- the Botellas section must render domain-backed content
- the home view must reflect the new domain baseline

### Technical validation expected

The following must remain intact:

- Web build path
- Android build path
- ServiceProvider ownership
- backend communication path
- session continuity
- login/logout behavior

### Structural validation expected

The repository must now contain a real domain package under Plantel Exterior with:

- entities
- value objects
- enum
- repository contract

This structural validation is the core success criterion of the phase.

---

## Release Impact

### Positive impact

- the repository gains its first real internal domain structure
- the visible product shell is now backed by actual business types
- future CRUD, persistence and sync work have a stable starting point

### Neutral impact

- no backend protocol change
- no runtime change
- no login/session change
- no global navigation redesign

### Deferred impact

The phase intentionally postpones:

- persistence
- repository implementation
- backend/domain mapping
- offline engine
- advanced field workflows

---

## Risks

### 1. In-memory-only transitional state

The domain now exists, but it is still used in an example/in-memory way inside presentation.

This is acceptable for the phase, but later phases must complete the persistence path.

### 2. Temporary example data in presentation

Because repository and persistence are not yet implemented, screens still instantiate sample entities directly.

This is a controlled temporary state, not the final architecture.

### 3. Future contract evolution pressure

The initial repository contract is intentionally minimal.  
Later phases may need to extend it carefully as CRUD and sync requirements become explicit.

---

## What it does NOT solve

This phase does **not** solve:

- local database persistence
- repository implementation
- backend integration for outside-plant entities
- synchronization engine
- real offline queueing
- map-driven interactions
- CRUD workflows
- search/filter/listing flows
- asset relationship modeling between outside-plant elements

All of these remain outside the scope of Phase 0.2.2.

---

## Conclusion

Phase 0.2.2 is the first phase where Mi IP·RED Plantel Exterior becomes not only visibly domain-oriented, but also structurally domain-aware.

Without touching the inherited runtime core, the phase introduces:

- real domain entities
- reusable value objects
- a shared sync-oriented state
- a repository contract baseline
- domain-aware rendering inside the Plantel Exterior sections

This makes Phase 0.2.2 the structural bridge between:

- a visually decoupled product shell
- and a future operational field application with real CRUD, persistence and offline capabilities.
