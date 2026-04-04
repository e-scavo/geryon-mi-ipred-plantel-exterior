# Phase 0.2.3 — Local Persistence Baseline

---

## Objective

Introduce the first real local persistence layer of **Mi IP·RED Plantel Exterior** using Drift, without modifying runtime ownership, backend communication, login/session continuity or the visible navigation shell established in previous phases.

This phase must:

- preserve the proven technical baseline inherited from earlier phases
- preserve the visible Plantel Exterior shell introduced in Phase 0.2.1
- preserve the domain model introduced in Phase 0.2.2
- replace in-memory sample entity rendering with persistence-backed reads
- keep the implementation low-risk and strictly incremental

---

## Initial Context

After Phase 0.2.2, the repository already had an explicit Plantel Exterior domain baseline:

- the inherited customer dashboard was no longer the main visible post-login surface
- a drawer-based navigation shell already existed
- the first two domain sections were visible:
  - Caja PON / ONT
  - Botella de Empalme
- explicit domain entities already existed
- value objects and a repository contract already existed

However, the codebase still had a major functional limitation:

- the UI was still rendering manually instantiated sample entities
- there was no durable local state
- there was no persistence layer to support future CRUD
- there was no real offline-ready baseline yet

This meant the repository was already UI-aware and domain-aware, but not persistence-aware.

---

## Problem Statement

The repository lacked a real local persistence layer for Plantel Exterior data.

That caused several structural limitations:

- Plantel Exterior screens depended on in-memory sample objects
- no data durability existed between executions
- repository contracts had no concrete implementation
- future CRUD work would have no stable storage baseline
- offline-first evolution remained blocked

Without correcting that, the feature would remain structurally incomplete even though the visible shell and domain model already existed.

---

## Scope

### Included in this phase

- introduction of a local Drift database for the Plantel Exterior feature
- creation of local tables for:
  - Caja PON / ONT
  - Botella de Empalme
- generated Drift database artifacts
- mapper layer between database rows and domain entities
- first concrete implementation of `OutsidePlantRepositoryContract`
- Riverpod providers to expose persistence-backed feature reads
- update of Plantel Exterior screens to read from the repository instead of local inline examples
- controlled initial seed data when local tables are empty

### Explicitly excluded

- backend synchronization
- conflict resolution
- CRUD forms
- create/edit/delete UI flows
- advanced query/filtering
- map integration
- camera/media evidence
- web persistence support
- runtime refactor
- transport refactor

---

## Root Cause Analysis

The root cause was not a runtime or backend defect.

The root cause was a **data durability gap** between the domain layer introduced in Phase 0.2.2 and the future feature set expected by the product.

Why this happened:

1. Phase 0.1 intentionally stopped at technical identity normalization
2. Phase 0.2.1 intentionally focused on visible shell and navigation only
3. Phase 0.2.2 intentionally stopped at domain structure without persistence
4. no concrete repository implementation or local storage existed yet

As a result, the feature still rendered sample data manually instantiated in widgets instead of a persistence-backed state.

---

## Files Affected

### Existing files modified

- `pubspec.yaml`
- `.gitignore`
- `lib/features/plantel_exterior/domain/contracts/outside_plant_repository_contract.dart`
- `lib/features/plantel_exterior/presentation/screens/plantel_exterior_home_view.dart`
- `lib/features/plantel_exterior/presentation/screens/cajas_pon_ont_screen.dart`
- `lib/features/plantel_exterior/presentation/screens/botellas_empalme_screen.dart`

### New files added

- `lib/features/plantel_exterior/data/local/app_database.dart`
- `lib/features/plantel_exterior/data/local/app_database.g.dart`
- `lib/features/plantel_exterior/data/local/tables/cajas_pon_ont_table.dart`
- `lib/features/plantel_exterior/data/local/tables/botellas_empalme_table.dart`
- `lib/features/plantel_exterior/data/mappers/caja_pon_ont_mapper.dart`
- `lib/features/plantel_exterior/data/mappers/botella_empalme_mapper.dart`
- `lib/features/plantel_exterior/data/repositories/drift_outside_plant_repository.dart`
- `lib/features/plantel_exterior/application/providers/outside_plant_providers.dart`

### Documentation files updated

- `README.md`
- `docs/index.md`
- `docs/architecture.md`
- `docs/flows.md`
- `docs/decisions.md`
- `docs/phase0_2_3_local_persistence_baseline.md`

---

## Implementation Characteristics

### 1. Low-risk implementation

The implementation is intentionally narrow:

- one new feature-local data layer
- one local Drift database
- one concrete repository implementation
- provider-backed screen reads
- no runtime redesign

### 2. Runtime preservation first

The implementation preserves:

- ServiceProvider ownership
- notifierServiceProvider integration
- bootstrap/loading sequence
- backend connectivity
- login/session continuity
- logout ownership flow

### 3. Feature-local persistence encapsulation

The persistence logic is encapsulated inside the Plantel Exterior feature under:

    lib/features/plantel_exterior/data/

This keeps the change localized and makes future feature growth cleaner.

### 4. Repository boundary preserved

The repository contract introduced in Phase 0.2.2 is not bypassed.

Instead, a concrete implementation is introduced behind that boundary, keeping:

- domain stable
- UI decoupled from database details
- future backend/hybrid implementations possible

### 5. Seed-first baseline usability

The feature inserts first-run baseline records when local tables are empty.

This ensures:

- persistence-backed rendering from day one
- deterministic validation
- no need to introduce CRUD forms in the same phase

---

## Detailed Implementation Summary

### Step 1 — Drift persistence baseline added

A new `PlantelExteriorDatabase` is introduced as the feature-local database entrypoint.

It declares two tables:

- `CajasPonOntTable`
- `BotellasEmpalmeTable`

### Step 2 — Local storage path introduced

The database uses `NativeDatabase` and resolves a local SQLite file under the application documents directory for supported native environments.

### Step 3 — Mapper layer added

Two mapper files translate between:

- database row models
- domain entities

This preserves separation between persistence and domain.

### Step 4 — Concrete repository implementation added

`DriftOutsidePlantRepository` becomes the first concrete implementation of `OutsidePlantRepositoryContract`.

Its responsibilities include:

- ensuring seed data when storage is empty
- loading Caja PON / ONT entities
- loading Botella de Empalme entities
- saving Caja PON / ONT entities
- saving Botella de Empalme entities

### Step 5 — Application providers added

A provider chain exposes persistence-backed reads to the presentation layer:

- database provider
- repository provider
- cajas list provider
- botellas list provider

### Step 6 — Presentation layer switched to repository-backed rendering

The Plantel Exterior screens stop instantiating sample entities inline and start consuming persistence-backed providers instead.

---

## Validation

### Functional validation expected

After startup and successful login/session continuity:

- the application must still enter PlantelExteriorHomeScreen
- the home view must show provider-backed summary cards
- the cajas view must load persisted data through the repository
- the botellas view must load persisted data through the repository
- the first run must insert controlled seed records when local tables are empty

### Technical validation expected

The following must remain intact:

- startup sequence
- backend connection
- login continuity
- session continuity
- Android/native persistence path

### Explicit platform limitation

The current implementation intentionally rejects web persistence in this phase.

This is expected behavior for Phase 0.2.3 and must not be treated as an accidental defect.

---

## Release Impact

### Positive impact

- the repository gains a real local persistence layer
- the Plantel Exterior module stops depending on sample in-memory entity instantiation
- future CRUD and offline work now have a real storage baseline
- the feature becomes structurally much closer to real field usage

### Controlled impact

- backend unchanged
- runtime unchanged
- login/session unchanged
- transport unchanged
- navigation unchanged

### Deferred impact

The phase intentionally defers:

- web persistence
- synchronization
- conflict handling
- CRUD forms
- advanced offline workflows

---

## Risks

### 1. Web limitation risk

Because web persistence is deferred, platform behavior is temporarily asymmetric.

This is acceptable for the phase but must be addressed in a later dedicated step.

### 2. Seed-data coupling risk

The current module uses seed data for baseline usability.

That is correct for the phase, but later phases must ensure CRUD and real data flows progressively replace reliance on seed-only validation.

### 3. Persistence-only scope risk

The module now has durable local state but still lacks synchronization and CRUD flows.

This means persistence maturity is ahead of feature-completeness, which is acceptable only if future phases continue.

---

## What it does NOT solve

This phase does **not** solve:

- backend synchronization
- multi-device consistency
- conflict handling
- full CRUD UI
- web persistence
- advanced offline queueing
- field workflow orchestration
- map integration
- media/evidence capture

All of those belong to later phases.

---

## Conclusion

Phase 0.2.3 is the first phase where Mi IP·RED Plantel Exterior becomes a persistence-backed feature instead of a shell/domain-only feature.

It does so by introducing:

- a local Drift database
- local tables for the first two domain entities
- mappers
- a concrete repository implementation
- provider-backed persisted reads in the UI

At the same time, it preserves the critical technical baseline inherited from Mi IP·RED:

- runtime stability
- backend compatibility
- session continuity
- multiplatform bootstrap assumptions

This makes Phase 0.2.3 another low-risk but high-value bootstrap milestone: the repository now has a real local data foundation for the next stages of CRUD, offline behavior and future synchronization.
