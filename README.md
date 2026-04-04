# Mi IP·RED Plantel Exterior

Operational field application for passive FTTH outside-plant management.

Mi IP·RED Plantel Exterior is a new Flutter application derived from the mature technical base of Mi IP·RED, but it is **not** a continuation of the original customer self-service product.

This repository starts a new product line focused on the technical and operational management of ISP outside plant infrastructure, while preserving the already proven runtime base:

- backend connectivity over WebSocket
- login flow
- session handling
- runtime orchestration through ServiceProvider
- Web + Android compatibility
- shared core utilities and platform abstractions

The goal of the current bootstrap stage is to establish a **controlled clone** with a clean technical identity, stable baseline, and safe documentary continuity before introducing domain-specific functional work.

---

## Current status

- Product name: **Mi IP·RED Plantel Exterior**
- Technical package name: `mi_ipred_plantel_exterior`
- Android applicationId / namespace: `com.geryon.mi_ipred_plantel_exterior`
- Product status: **Stage 0 / Technical Bootstrap**
- Active subphase: **Phase 0.2.3 — Local Persistence Baseline**
- Current targets:
  - Web
  - Android
- Deferred targets:
  - iOS

---

## Project origin and product boundary

This repository is derived from the existing Mi IP·RED codebase, but the new product has a different purpose.

### Reused technical base

The following parts are intentionally preserved from the original application because they are already mature and operationally valuable:

- ServiceProvider runtime ownership
- backend transport and WebSocket communication
- login/session continuity
- cross-platform persistence abstractions
- shared utility layer
- existing architectural baseline
- Web + Android compatibility

### Discarded product surface

The following original product areas are **not** part of the new product scope:

- customer dashboard as a product goal
- billing-centered product flows
- customer self-service UX as the target surface
- existing Play Store publication assets
- existing release/publication identity of the original app

This means the repository is technically inherited, but product-wise reset.

---

## Stage 0 objective

The repository is currently in:

- **Stage 0 — Technical Bootstrap**
- **Phase 0 — Technical Bootstrap**
- **Phase 0.2.1 — Domain Skeleton & Navigation Entry**

The Stage 0 sequence is cumulative:

- **Phase 0.1 — Controlled Clone & Technical Identity Baseline**
- **Phase 0.2.1 — Domain Skeleton & Navigation Entry**

Phase 0.1 established the safe technical baseline for the new product by:

- separating the repository identity from the original app
- preserving the proven technical runtime
- removing publication/release residue from the source product
- preparing a clean starting point for upcoming outside-plant features

Phase 0.2.1 builds directly on that baseline and introduces:

- a new post-login visible surface aligned with Mi IP·RED Plantel Exterior
- a scalable base navigation using a drawer
- a real domain home screen
- first skeleton sections for:
  - Caja PON / ONT
  - Botella de Empalme

Phase 0.2.1 still does **not** introduce full CRUDs, real offline sync flows, maps, camera integration, or a deep runtime redesign.

---

## Product domain

Mi IP·RED Plantel Exterior is intended to manage passive FTTH outside-plant infrastructure.

The initial domain baseline explicitly includes two infrastructure entities from the beginning:

1. **Caja PON / ONT**
2. **Botella de Empalme**

This is important because the product must not be designed as if only one entity existed.  
Even before full CRUD implementation, the architecture and documentation must assume that both entities belong to the core domain model.

---

## Core engineering rule

The backend connection flow remains the most critical technical part of the system and must be preserved during all bootstrap and migration stages.

This includes:

- WebSocket bootstrap
- backend handshake
- token/session continuity
- channel subscription behavior
- request / response transport semantics
- login flow
- startup initialization
- existing runtime orchestration expectations

Even though the product identity changes, the technical baseline must remain stable.

---

## Confirmed technical decisions

The following decisions are already fixed for this repository baseline:

1. **Android applicationId / namespace**

       com.geryon.mi_ipred_plantel_exterior

2. **Dart package name**

       mi_ipred_plantel_exterior

3. **Backend contract reuse**
   - use the existing real backend contract
   - do not invent a new contract if the current one already supports the domain evolution

4. **Base local strategy**
   - local persistence must be real from day one of the real persistence phase
   - but the full persistence layer is not part of the clone/bootstrap phase

5. **Map technology**
   - use `flutter_map`

6. **Navigation expectation**
   - a scalable entry navigation is required in the upcoming domain phases
   - but Phase 0.1 itself does not redesign navigation yet

---

## What has already been normalized in the controlled clone

The technical baseline created in the repository already includes normalization in areas such as:

- repository/product naming
- application identity
- technical package identity
- inherited release residue removal
- signing/publication cleanup
- baseline documentation rewrite
- Web-facing public labels (minimum viable normalization)

This provides a stable ground for functional outside-plant evolution.

---

## What is intentionally NOT done yet

At the current bootstrap stage, the repository intentionally does **not** implement:

- domain CRUD for Caja PON / ONT
- domain CRUD for Botella de Empalme
- map flows
- offline queue/sync engine
- camera evidence flow
- local DB implementation
- production field workflows
- structural ServiceProvider decomposition
- architecture redesign for purity reasons alone

The reason is simple: the project first needs a **stable cloned baseline** before real functional divergence begins.

---

## Technical baseline philosophy

This repository follows a **stability-first migration philosophy**.

That means:

- preserve what is already mature
- change only what is required by the new product identity
- delay heavy redesign until the new product direction is visible and validated
- avoid “cleanup for aesthetics” if it endangers runtime continuity

This philosophy is especially important because the inherited codebase already contains working infrastructure that is expensive to re-create incorrectly.

---

## Runtime-critical layers preserved

The following layers are treated as critical and must remain stable until explicitly phased otherwise:

### 1. Application bootstrap

Includes:

- Flutter app initialization
- ProviderScope startup
- root application wiring
- startup loading orchestration

### 2. ServiceProvider runtime

Includes:

- startup orchestration
- backend connectivity
- state transition handling
- runtime ownership

### 3. WebSocket communication

Includes:

- initialization
- handshake/connection management
- request/response flow
- backend continuity

### 4. Login and session continuity

Includes:

- token/session persistence
- startup session restore
- authenticated continuity expectations

---

## Product direction after bootstrap

Once the technical baseline is stable, the repository is expected to evolve toward:

- new domain-first navigation
- domain screens centered on outside-plant operations
- real local persistence
- offline states:
  - pending
  - synchronized
  - error
- map-assisted infrastructure interaction
- progressive removal of inherited customer-facing surface

This means the bootstrap stage is not the final product, but the foundation for it.

---

## Why this repository is intentionally conservative

There is a strong temptation in inherited-code projects to rewrite everything immediately.

This repository deliberately avoids that because:

- the inherited runtime is already functional
- the backend integration is already proven
- early rewrites often create regressions with no real product value
- the new product still needs a reliable starting point before domain growth

So the repository prefers:

- controlled mutation
- explicit phase boundaries
- cumulative documentation
- validation after each change

---

## Source of truth rule

For all future work:

- the attached ZIP is the only source of truth
- documentation must reflect the real ZIP state
- previous chat assumptions must be discarded if the ZIP contradicts them
- implementation and documentation must move together

This rule is mandatory.

---

## Documentation contract

This repository uses a strict documentation model.

Every phase must:

- be documented incrementally
- preserve prior valid context
- avoid placeholders
- avoid partial/fragmented markdown
- return full files for copy/paste

Primary documentation files include:

- `README.md`
- `docs/index.md`
- `docs/architecture.md`
- `docs/flows.md`
- `docs/decisions.md`
- dedicated phase documents

---

## Build and validation expectations

At this baseline stage, validation is expected to confirm:

- project identity compiles correctly
- runtime still boots
- backend connectivity path remains intact
- session/login path remains intact
- Web compatibility remains intact
- Android compatibility remains intact

Suggested validation commands depend on the local environment, but typically include:

```bash
flutter pub get
flutter analyze
flutter run -d chrome
```

and, when available:

```bash
flutter run -d android
```

These commands validate that the controlled clone still preserves the inherited technical runtime after identity cleanup.

---

## Immediate repository priorities

The current repository priorities are:

1. establish a controlled clone
2. remove technical identity ambiguity
3. preserve backend/runtime stability
4. remove inherited release/publication residue
5. prepare a clean baseline for field-domain implementation
6. continue Stage 0 without premature functional redesign

This means stability is currently more important than visible functional expansion.

---

## Documentation structure

Primary repository documentation:

    docs/
      index.md
      architecture.md
      flows.md
      decisions.md
      phase0_1_controlled_clone_technical_identity_baseline.md

Additional inherited historical documentation from the source product may still exist during the controlled transition and should be interpreted carefully: they belong to the technical origin of the repository, not to the final target product scope.

The new documentation baseline must progressively replace that ambiguity with repository-specific truth.

---

## Current engineering policy

- do not redesign ServiceProvider during bootstrap
- do not break backend communication
- do not break login/session continuity
- prefer controlled minimal changes
- preserve Web + Android compatibility
- document all technical boundary changes explicitly
- treat the attached ZIP as the source of truth
- do not assume prior repository state when it contradicts the real ZIP
- keep documentation cumulative and incremental

---

## Short roadmap after Phase 0.1

Once the controlled clone baseline is stable, the next justified work will move toward:

- outside-plant domain structure
- scalable navigation baseline
- real local persistence
- passive-infrastructure entity modeling
- operational field workflows
- simple real offline states
- map-enabled technical surfaces
- progressive replacement of inherited customer-product screens

Those steps belong to later phases, not to Phase 0.1 itself.

---

## Conclusion

Mi IP·RED Plantel Exterior begins as a controlled derivative of Mi IP·RED, but it is a new product with a different mission.

The repository must therefore do two things at the same time:

1. preserve the proven runtime and backend connection foundation
2. separate itself completely from the original product identity and publication residue

Phase 0.1 exists to create exactly that baseline.

It is intentionally conservative, technically focused, and stability-first so the project can evolve into a field operations product without losing the maturity already achieved by the inherited runtime.

---

## Phase 0.2.1 implementation update

Phase 0.2.1 is the first phase that changes the **visible functional entrypoint** of the repository after login.

### What changed in Phase 0.2.1

The application no longer presents the inherited customer dashboard as the main post-login product surface.

Instead, it now exposes a dedicated outside-plant entry surface with:

- a product-specific home screen
- drawer-based navigation
- first domain sections for:
  - **Caja PON / ONT**
  - **Botella de Empalme**

### What remains intentionally unchanged

Phase 0.2.1 preserves:

- ServiceProvider as runtime owner
- bootstrap and startup orchestration
- backend communication
- login and session continuity
- Web + Android compatibility
- inherited modules that are not yet removed

### Why this matters

This phase is strategically important because it is the first point where the repository stops looking like the original customer product and starts behaving like a real field operations product, even though domain behavior is still in skeleton form.

### Phase 0.2.1 affected files

Implementation introduced or modified the following files:

    lib/main.dart
    lib/features/plantel_exterior/presentation/providers/plantel_navigation_provider.dart
    lib/features/plantel_exterior/presentation/widgets/plantel_exterior_drawer.dart
    lib/features/plantel_exterior/presentation/screens/plantel_exterior_home_screen.dart
    lib/features/plantel_exterior/presentation/screens/plantel_exterior_home_view.dart
    lib/features/plantel_exterior/presentation/screens/cajas_pon_ont_screen.dart
    lib/features/plantel_exterior/presentation/screens/botellas_empalme_screen.dart

### Current visible behavior after login

Current expected behavior is:

    Login OK / Session restored
        → PlantelExteriorHomeScreen
            → Home
            → Cajas PON / ONT
            → Botellas de Empalme

This is now the correct visible baseline for future field-domain work.

---

## Phase 0.2.3 — Local Persistence Baseline

Phase 0.2.3 introduces the first real persistence layer of Mi IP·RED Plantel Exterior.

After Phase 0.2.1 established the visible product shell and Phase 0.2.2 introduced the first explicit domain model, this phase adds a concrete local data layer based on Drift so the application no longer depends on in-memory sample entities rendered directly by the widgets.

### What changed in Phase 0.2.3

The repository now contains a real persistence structure under `lib/features/plantel_exterior/data/`, including:

- local Drift database definition
- generated database companion/model layer
- Drift table definitions for:
  - Caja PON / ONT
  - Botella de Empalme
- entity/database mappers
- first concrete repository implementation
- Riverpod providers that connect UI to persistence

### Persistence technology

This phase adopts **Drift 2.31.0** as the local persistence baseline for the project, together with generated code through `build_runner`.

The resulting persistence chain is:

    UI
        → Riverpod providers
        → DriftOutsidePlantRepository
        → PlantelExteriorDatabase
        → local SQLite database

### Current platform scope of persistence

Phase 0.2.3 intentionally enables native local persistence first.

Current persistence support status:

- Android: supported
- native desktop environments compatible with `NativeDatabase`: supported by the persistence design
- Web: explicitly deferred to a later phase

In the current implementation, web persistence is not yet enabled and the database opening path throws an explicit unsupported error on web.

### Seed data strategy

The first repository implementation guarantees that the initial UI always has valid local data to render by inserting baseline records only when the local tables are empty.

Seeded records include:

- one Caja PON / ONT
- one Botella de Empalme

This keeps the repository testable and makes the visual module useful before CRUD flows are introduced.

### What remains intentionally unchanged

Phase 0.2.3 preserves:

- ServiceProvider as runtime owner
- startup and bootstrap orchestration
- backend communication
- login and session continuity
- the visible navigation shell introduced in Phase 0.2.1
- the domain model introduced in Phase 0.2.2

### Why this phase matters

This phase is the first one where the product stops depending on sample entity instantiation inside presentation widgets and starts behaving like a persistence-backed application.

That is strategically important because it creates the real foundation for:

- CRUD flows
- durable local state
- offline-first behavior
- future synchronization
- repository expansion without UI rewrites

### Phase 0.2.3 affected files

Implementation introduced or modified the following key files:

    pubspec.yaml
    .gitignore
    lib/features/plantel_exterior/data/local/app_database.dart
    lib/features/plantel_exterior/data/local/app_database.g.dart
    lib/features/plantel_exterior/data/local/tables/cajas_pon_ont_table.dart
    lib/features/plantel_exterior/data/local/tables/botellas_empalme_table.dart
    lib/features/plantel_exterior/data/mappers/caja_pon_ont_mapper.dart
    lib/features/plantel_exterior/data/mappers/botella_empalme_mapper.dart
    lib/features/plantel_exterior/data/repositories/drift_outside_plant_repository.dart
    lib/features/plantel_exterior/application/providers/outside_plant_providers.dart
    lib/features/plantel_exterior/presentation/screens/plantel_exterior_home_view.dart
    lib/features/plantel_exterior/presentation/screens/cajas_pon_ont_screen.dart
    lib/features/plantel_exterior/presentation/screens/botellas_empalme_screen.dart

### Current visible behavior after local persistence

Current expected behavior is:

    Login OK / Session restored
        → PlantelExteriorHomeScreen
            → Home (summaries fed by providers)
            → Cajas PON / ONT (loaded from local repository)
            → Botellas de Empalme (loaded from local repository)

This makes Phase 0.2.3 the first persistence-backed baseline for future outside-plant operations work.
