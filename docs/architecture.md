# Architecture

This document describes the current technical architecture of the repository based strictly on the real project state (ZIP as source of truth).

The architecture described here corresponds to:

- Stage 0 — Technical Bootstrap
- Phase 0 — Technical Bootstrap
- Phase 0.3.4 — CRUD UX Minimum Layer

At this stage, the architecture is **inherited from Mi IP·RED**, with identity normalization applied, but without structural redesign.

---

## Architectural Philosophy

The system is built around a **runtime-first architecture**, where a central orchestrator manages:

- application lifecycle
- backend connectivity
- session continuity
- configuration loading
- recovery and retry logic

This central orchestrator is:

    ServiceProvider

The architecture intentionally avoids fragmentation at this stage and prioritizes:

- stability
- predictability
- backend compatibility
- minimal mutation during bootstrap

---

## High-Level Architecture

The application follows this high-level structure:

    UI Layer
        ↓
    Runtime Layer (ServiceProvider)
        ↓
    Transport Layer (WebSocket)
        ↓
    Backend (GERYON)

Supporting layers:

- Session Storage
- Configuration
- Utilities
- File Abstractions
- Data Models (Table / Generic)

---

## Application Entry Point

File:

    lib/main.dart

Responsibilities:

- initialize Flutter bindings
- create ProviderScope (Riverpod)
- bootstrap the application
- define root widget (MyApp)
- define initial screen (MyStartingPage)

The application startup is intentionally simple and delegates complexity to the runtime layer.

---

## Runtime Layer

### ServiceProvider

Location:

    lib/models/ServiceProvider/

Role:

- main runtime orchestrator
- controls startup sequence
- manages backend connection
- handles authentication continuity
- coordinates session restore
- exposes runtime state to UI

Key characteristics:

- single source of truth for runtime state
- tightly coupled with backend communication
- must not be redesigned during bootstrap phases
- contains retry and recovery logic

This is the most critical component of the system.

---

## Provider Layer (Riverpod)

Global providers are defined in:

    lib/common_vars.dart

Includes:

- service provider notifier
- navigation key
- shared runtime dependencies

Riverpod is used as:

- dependency injection mechanism
- runtime state bridge to UI
- controlled state exposure layer

At this stage, Riverpod usage remains inherited and stable.

---

## Transport Layer

Backend communication relies on:

    WebSocket

Expected responsibilities:

- connection bootstrap
- request transport
- response delivery
- reconnection handling
- runtime coordination with ServiceProvider

This layer is considered **runtime-critical**.

No transport abstraction replacement is introduced during the bootstrap stage.

---

## Session Layer

The application includes session continuity mechanisms responsible for:

- reading stored session data
- restoring runtime session state
- supporting startup continuity
- preserving authenticated flows across restarts

This layer must remain stable during Stage 0.

---

## Configuration Layer

The configuration layer is responsible for:

- loading runtime environment values
- adapting to target platform
- exposing backend-related configuration
- ensuring startup prerequisites are satisfied

This layer is required before backend connectivity becomes valid.

---

## Utility and Shared Layers

The inherited repository includes a mature set of shared components such as:

- utility helpers
- cross-platform abstractions
- file helpers
- model serializers
- common widgets

These layers are intentionally preserved because they support runtime continuity and avoid unnecessary duplication during bootstrap.

---

## UI Layer (Current Stage)

At the current stage, the UI layer is still partially inherited from the original product.

This means:

- some screens may still reflect the source product
- final outside-plant UX is not fully implemented yet
- Stage 0 focuses first on technical baseline, not complete domain surface

This is an expected transitional state.

---

## Domain Layer Status

The new target domain is:

- passive FTTH outside-plant management

Initial confirmed entities:

- Caja PON / ONT
- Botella de Empalme

However, in Phase 0.1:

- these entities are documented
- but not yet implemented as full domain modules

So the domain exists at the product-definition level, not yet as a full application layer.

---

## Persistence Strategy

The long-term repository direction requires **real local persistence**, not lightweight placeholder persistence.

However, at the current stage:

- full local DB integration is not yet implemented
- persistence design remains deferred
- architecture still reflects inherited storage/session mechanisms

This is intentional.

---

## Map Strategy

The confirmed map technology for future phases is:

    flutter_map

But map integration is not part of the current architectural implementation yet.

---

## Navigation Status

A scalable navigation baseline is required in future phases, but not yet fully implemented in Phase 0.1.

At this stage:

- existing inherited navigation still exists
- future navigation must evolve toward outside-plant operational surfaces
- no large navigation refactor is performed during controlled clone

---

## Backend Contract Strategy

The system must reuse the **real existing backend contract**, rather than introducing speculative DTO redesign.

This means:

- existing models/tables remain authoritative where applicable
- future domain work must adapt carefully to real backend semantics
- architectural drift between frontend and backend is forbidden

---

## Platform Scope

Current supported platforms:

- Web
- Android

Deferred platform:

- iOS

Architecture must remain compatible with the supported platforms during all Stage 0 phases.

---

## Build/Release Residue Status

Phase 0.1 removes publication/release residue from the source product, such as:

- distribution artifacts
- submission bundles
- signing configuration residue
- inherited publication identity

This is considered repository hygiene, not an architectural redesign.

---

## Why the architecture is intentionally conservative

A mature inherited codebase always creates tension between:

- preserving what already works
- redesigning for future purity

At this stage, the repository explicitly chooses preservation because:

- runtime stability is more valuable than aesthetic cleanup
- backend continuity is critical
- field-domain functionality should be introduced on top of a stable baseline
- premature architectural fragmentation could break proven flows

---

## Architectural Constraints (Critical)

During Phase 0.1:

- do not redesign ServiceProvider
- do not break WebSocket communication
- do not modify backend contract
- do not introduce parallel abstractions
- do not refactor runtime flow
- do not change provider structure

---

## Known Transitional State

Because this is a controlled clone:

- UI still reflects original product partially
- domain is not yet implemented
- some modules may appear unrelated to final product

This is expected and acceptable.

---

## Phase 0.1 Architectural Impact

This phase introduces:

- identity normalization
- removal of release artifacts
- cleanup of signing configuration
- preservation of runtime

It does NOT introduce:

- new layers
- new abstractions
- structural refactors

---

## Future Evolution (Post Bootstrap)

After Phase 0.1, the architecture will evolve toward:

- domain-driven structure for plantel exterior
- entity modeling (Caja PON, Botella de Empalme)
- local database integration
- offline support
- map-based UI
- field operation workflows
- progressive replacement of inherited UI

---

## Conclusion

The architecture at this stage is intentionally conservative.

It preserves:

- a proven runtime model
- stable backend integration
- cross-platform compatibility

While enabling:

- safe product identity separation
- controlled evolution toward a new domain

This balance is critical to avoid regressions while transitioning from a customer-facing app to an operational field tool.

---

## Phase 0.2.1 Architectural Extension — Domain Skeleton & Navigation Entry

Phase 0.2.1 does not redesign the inherited architecture, but it introduces the first **new functional feature layer** that becomes the visible main surface of the product after login.

### New feature layer introduced

A new presentation layer is introduced under:

    lib/features/plantel_exterior/

This layer is intentionally narrow and focused on:

- product-specific entry surface
- local feature navigation
- early domain visibility

### Internal structure

    lib/features/plantel_exterior/
      presentation/
        providers/
          plantel_navigation_provider.dart
        widgets/
          plantel_exterior_drawer.dart
        screens/
          plantel_exterior_home_screen.dart
          plantel_exterior_home_view.dart
          cajas_pon_ont_screen.dart
          botellas_empalme_screen.dart

### Architectural role of the new layer

This feature layer is responsible for:

- replacing the inherited customer dashboard as the visible post-login home
- exposing a new field-domain home entry
- giving both initial domain entities real navigable presence
- doing so without changing runtime ownership or transport architecture

### Navigation model introduced in Phase 0.2.1

Navigation inside the new module is intentionally simple.

It uses:

- a small local provider
- a section enum
- a drawer as the main entry switch
- screen-body replacement based on provider state

This means Phase 0.2.1 introduces local presentation navigation, not a full routing redesign.

### Post-login entrypoint change

From an architectural perspective, the most important change is the visible destination selected once startup and session continuity are complete.

Before:

    runtime ready
        → inherited DashboardPage(clientID: -1)

After Phase 0.2.1:

    runtime ready
        → PlantelExteriorHomeScreen()

This is the first architectural step where the repository begins to expose its real product direction.

### What is intentionally preserved

Phase 0.2.1 preserves:

- ServiceProvider
- notifierServiceProvider runtime integration
- backend communication model
- login/session continuity
- startup bootstrap pattern
- inherited modules outside the new visible entrypoint

### Architectural constraints still valid

Even after Phase 0.2.1, the following remain forbidden:

- ServiceProvider redesign
- transport replacement
- premature local database insertion
- sync engine introduction
- deep global navigation rewrite
- destructive removal of inherited modules

### Architectural effect of Phase 0.2.1

This phase introduces a **new top-level visible feature surface** without changing the structural runtime core.

That makes it a low-risk but high-importance architectural transition.

---

## Phase 0.2.2 Architectural Extension — Domain Modeling & Contracts Baseline

Phase 0.2.2 keeps the runtime architecture introduced in earlier phases intact, but it adds the first dedicated domain layer inside the Plantel Exterior feature.

### New domain layer introduced

A new domain structure is added under:

    lib/features/plantel_exterior/domain/

Its internal organization is:

    lib/features/plantel_exterior/domain/
      value_objects/
        outside_plant_id.dart
        geo_point.dart
      enums/
        sync_status.dart
      entities/
        caja_pon_ont.dart
        botella_empalme.dart
      contracts/
        outside_plant_repository_contract.dart

### Architectural role of the domain layer

This layer is responsible for:

- representing the first real business entities of the product
- centralizing reusable value objects
- defining a first shared sync/offline status type
- establishing a repository contract baseline for future persistence work

### Design constraints of the domain layer

The new domain layer must remain:

- independent from UI widgets
- independent from ServiceProvider
- independent from backend transport implementation
- independent from storage implementation details

This preserves clean layering and avoids prematurely coupling domain rules to persistence or transport.

### Entities introduced

The first explicit domain entities added are:

- `CajaPonOnt`
- `BotellaEmpalme`

Each entity now centralizes core typed fields such as:

- identifier
- code
- description
- optional location
- sync status
- optional creation/update timestamps

### Value objects introduced

The first shared value objects are:

- `OutsidePlantId`
- `GeoPoint`

These reduce primitive-only modeling and prepare the codebase for stronger consistency in later phases.

### Enum introduced

A shared enum is introduced:

- `SyncStatus`
  - `pending`
  - `synced`
  - `error`

This is architecturally important because it prepares the product for future offline-first behavior without implementing the full engine yet.

### Contract introduced

A first repository contract is introduced:

- `OutsidePlantRepositoryContract`

Its role is not to implement persistence yet, but to define a stable boundary for future data access work.

### Impact on presentation layer

The presentation layer now consumes domain entities instead of depending on placeholder-only copy.

This means:

- `CajasPonOntScreen` renders a real `CajaPonOnt`
- `BotellasEmpalmeScreen` renders a real `BotellaEmpalme`
- `PlantelExteriorHomeView` now documents the existence of a typed domain baseline

### What Phase 0.2.2 still does not introduce

This phase still does not introduce:

- local database implementation
- repository implementation
- backend mapping
- synchronization engine
- map workflows
- advanced domain services

All of those remain future architectural steps.

### Architectural significance of Phase 0.2.2

Phase 0.2.2 is the first phase where the repository gains a true internal business structure without modifying the runtime core.

That makes it a foundational architectural milestone:

- low risk for current runtime
- high value for future product evolution


---

## Phase 0.2.3 Architectural Extension — Local Persistence Baseline

Phase 0.2.3 does not change the runtime-centric architectural core of the repository, but it introduces the first concrete persistence layer for the Plantel Exterior module.

### New data layer introduced

A new data-oriented structure is introduced under:

    lib/features/plantel_exterior/data/

This layer contains:

- local database configuration
- table declarations
- generated Drift database artifacts
- domain/database mappers
- repository implementation

### Internal persistence structure

    lib/features/plantel_exterior/data/
      local/
        app_database.dart
        app_database.g.dart
        tables/
          cajas_pon_ont_table.dart
          botellas_empalme_table.dart
      mappers/
        caja_pon_ont_mapper.dart
        botella_empalme_mapper.dart
      repositories/
        drift_outside_plant_repository.dart

### Architectural role of the new layer

This layer is responsible for:

- persisting Plantel Exterior entities locally
- isolating Drift from the domain layer
- translating domain entities to database structures and back
- exposing a stable persistence-backed repository to the application layer

### Database strategy introduced in Phase 0.2.3

The current persistence baseline uses Drift with `NativeDatabase` for local storage in native environments.

A local database named `plantel_exterior.db` is created under the application documents directory.

This is the first point in the repository where the Plantel Exterior feature owns durable local state.

### Application layer integration

The new persistence layer is not consumed directly by widgets.

A new provider chain connects the UI to persistence:

- `plantelExteriorDatabaseProvider`
- `outsidePlantRepositoryProvider`
- `cajasPonOntListProvider`
- `botellasEmpalmeListProvider`

This preserves separation between:

- rendering
- feature/application orchestration
- domain
- persistence infrastructure

### Updated dependency direction

After Phase 0.2.3, the effective dependency path becomes:

    UI
        → application/providers
        → repository contract + implementation
        → Drift database
        → local SQLite storage

The domain layer remains free from direct Drift or SQL concerns.

### Seed data architecture decision

The repository implementation includes a controlled seed path executed through `ensureSeedData()`.

Its responsibility is:

- detect empty local tables
- insert one initial Caja PON / ONT
- insert one initial Botella de Empalme

This guarantees the first persistence-backed screens can render meaningful information without requiring CRUD first.

### Presentation impact of Phase 0.2.3

The presentation layer no longer builds sample entities inline.

Instead:

- `PlantelExteriorHomeView` consumes provider-backed counts
- `CajasPonOntScreen` loads persisted entities through the repository
- `BotellasEmpalmeScreen` loads persisted entities through the repository

This is the first time the visible module is backed by durable local state.

### Platform limitation explicitly preserved

Phase 0.2.3 intentionally does not implement web persistence yet.

The current database opening path explicitly rejects web execution with an unsupported error.

This limitation is architectural, explicit and phase-scoped, not accidental.

### What Phase 0.2.3 still does not introduce

This phase still does not introduce:

- backend/domain synchronization
- conflict resolution
- reactive watchers/streams for entity collections
- full CRUD UI
- web persistence support
- complex offline orchestration

All of those remain future architectural steps.

### Architectural significance of Phase 0.2.3

Phase 0.2.3 is the first phase where the repository gains a real persistence layer under the Plantel Exterior feature without changing the runtime core.

That makes it another foundational architectural milestone:

- low risk for inherited runtime stability
- high value for future offline and CRUD evolution
- clear layering between domain and data

---

## Phase 0.2.4 Architectural Extension — Web Persistence Support

Phase 0.2.4 extends the persistence baseline to Web-compatible execution.

This introduces:

- platform-aware database initialization
- WASM-compatible persistence handling
- resolution of WebAssembly loading constraints
- correction of seed concurrency issues

Architectural impact:

- persistence layer becomes multi-platform
- no changes to runtime layer (ServiceProvider remains intact)
- no change to domain layer boundaries

---

## Phase 0.3.1 Architectural Extension — Create

Phase 0.3.1 introduces creation flows at the architectural level.

This includes:

- UI → provider → repository → database insert path
- persistence-backed entity creation
- provider invalidation after insert

Architectural impact:

- transition from read-only persistence to write capability
- repository becomes bi-directional (read + write)
- no changes to runtime orchestration

---

## Phase 0.3.2 Architectural Extension — Update

Phase 0.3.2 introduces update flows.

This includes:

- UI edit mode → provider → repository → update
- data preloading from persistence layer
- preservation of entity identity

Architectural impact:

- full mutation capability over persisted entities
- domain consistency enforced through repository layer
- no changes to transport or runtime layers

---

## Phase 0.3.3 Architectural Extension — Delete

Phase 0.3.3 introduces delete flows.

This includes:

- UI delete action → confirmation → repository delete
- removal from persistence layer
- list refresh via provider invalidation

Architectural impact:

- completes CRUD mutation capability
- repository now supports full lifecycle operations
- still no backend sync involved

---

## Phase 0.3.4 Architectural Extension — CRUD UX Minimum Layer

Phase 0.3.4 introduces a usability layer on top of CRUD.

This includes:

- validation layer in presentation
- feedback channels (success/error)
- loading state handling
- empty state normalization

Architectural impact:

- improves interaction reliability
- does not introduce new layers
- maintains strict separation of concerns




---

## Phase 0.4.1 — Synchronization Foundation Layer

The outside-plant module now adds a dedicated synchronization preparation layer without changing the global runtime owner.

### Added module pieces

- `OutsidePlantSyncContract`
- `DriftOutsidePlantSyncRepository`
- `OutsidePlantSyncService`
- entity snapshot mappers for local queue payload generation
- queue-backed migration in `PlantelExteriorDatabase`

### Ownership model in 0.4.1

`ServiceProvider` remains the global runtime owner.

The outside-plant feature introduces a **feature-scoped orchestration layer** so that synchronization concerns do not get pushed into UI widgets and do not require a bootstrap redesign.

Flow of ownership for local mutations:

- UI form / UI action
- Riverpod mutation provider
- `OutsidePlantSyncService`
- local repository + local sync repository
- Drift database

### Current persistence strategy for sync preparation

The authoritative operational state remains the entity tables:

- `cajas_pon_ont`
- `botellas_empalme`

The new queue table is auxiliary and records pending synchronization intent:

- `outside_plant_sync_queue`

This queue is append-oriented in 0.4.1 and stores:

- entity type
- entity id
- operation type
- local JSON snapshot / tombstone payload
- queue status
- retry/error metadata
- timestamps

### Why delete is traced before local removal

The inherited CRUD baseline already used physical delete.

To keep 0.4.1 controlled and avoid destabilizing the current domain tables before backend contracts are known, the implementation records a delete tombstone in the queue first and only then removes the row locally.

This preserves future push intent without forcing an early redesign of entity storage semantics in the same subphase.

---

## Phase 0.4.2 — Push Processing Layer

Phase 0.4.2 introduces a new architectural slice above the local outbox created in 0.4.1.

The resulting ownership model becomes:

- UI: triggers feature-level actions only
- mutation/service layer: persists local state and creates sync queue trace
- sync queue repository: stores pending operations and queue state transitions
- push processor: consumes queue items sequentially and dispatches them by entity + operation
- remote sync contract: isolates the future backend integration from the rest of the module

### Remote contract policy in 0.4.2

The remote contract is intentionally introduced before the real backend mapping is known.

This is allowed because the contract is used as a stable boundary, not as a speculative transport implementation.

Therefore:

- the processor can be completed now
- the adapter can remain controlled/non-productive now
- the future backend integration can replace only the adapter later

### Push execution model

The push processor is deliberately sequential.

At this stage the priority is:

- predictable ordering
- simple diagnostics
- explicit queue state transitions
- low architectural risk

Concurrency, queue compaction and retry hardening remain deferred.

---

## Phase 0.4.3 — Pull Refresh and Local Reconciliation Layer

Phase 0.4.3 adds the remote-to-local refresh path on top of the local queue and push processor already introduced in 0.4.1 and 0.4.2.

The resulting ownership model becomes:

- UI: triggers technical refresh only
- pull processor: requests remote snapshots through a dedicated boundary
- repository: persists reconciled local state
- local entity tables: remain the operational source of truth
- pending queue: remains the push workload and is not replaced by pull

### Reconciliation rule in 0.4.3

Remote refresh is intentionally conservative.

Rules:

- if a remote row does not exist locally, it may be inserted as `synced`
- if a local row exists as `synced`, it may be updated from remote data
- if a local row exists as `pending`, it must not be overwritten automatically
- if a local row exists as `error`, it must not be overwritten automatically
- remote delete reconciliation is still out of scope in this phase

### Legacy and placeholder notes

The file `application/providers/outside_plant_mutations_provider.dart` is now explicitly marked as deprecated because the active module wiring already lives in `presentation/providers/...`.

The files:

- `presentation/screens/cajas/cajas_list_screen.dart`
- `presentation/screens/botellas/botellas_list_screen.dart`

remain present but empty and unused in the current baseline. They are preserved for controlled cleanup or reuse in a later UX-oriented phase instead of being removed opportunistically now.


---

## Phase 0.4.4 — Synchronization UX Baseline Layer

Phase 0.4.4 adds a presentation-only synchronization UX layer on top of the already existing local queue, push processor and pull processor.

### UX responsibilities introduced in 0.4.4

- render per-row sync status with a reusable badge
- retain the latest visible push/pull summaries in presentation state
- expose controlled loading/disabled states for manual sync actions
- surface recent errors without persisting them as new domain data

### Architectural rule in 0.4.4

Execution summaries and UI blocking state belong to a presentation provider, not to the local database.

Therefore:

- durable operational truth remains in entity `syncStatus` and in the local queue
- ephemeral execution feedback remains in `outside_plant_sync_ui_provider.dart`
- home/dashboard widgets consume processor results indirectly through presentation state

### Explicit non-goals preserved in 0.4.4

- no background sync
- no automatic retries
- no queue compaction
- no backend contract finalization
- no deletion of residual placeholder screens or deprecated provider path during this phase


---

## Phase 0.4.5 — Synchronization Hardening Layer

Phase 0.4.5 does not add a new synchronization capability. It removes residual invalid execution paths and hardens the only allowed presentation path for manual push/pull.

### Hardening responsibilities introduced in 0.4.5

- keep exactly one valid manual execution path for push and pull
- remove residual FutureProvider-based action wrappers that previously mutated presentation state during execution
- centralize concurrency guards inside the presentation sync-ui notifier
- keep list invalidation and processor ownership unchanged

### Architectural rule in 0.4.5

Presentation actions may invoke processors, but they must not leave alternative provider-based command paths that mutate other providers during initialization.

Therefore:

- `runOutsidePlantPushSyncProvider` and `runOutsidePlantPullSyncProvider` remain as processor result providers
- execution start/finish is coordinated from the widget plus notifier path only
- the old residual action providers are removed instead of being left as dormant traps

### Explicit non-goals preserved in 0.4.5

- no backend Go contract integration yet
- no queue compaction
- no automatic retry scheduler
- no opportunistic deletion of the deprecated application provider path
- no cleanup of the still-empty wrapper list screens during this phase


---

## Phase 0.5.1 — Operational Domain Enrichment Layer

Phase 0.5.1 adds operational richness to the local domain model without changing the synchronization architecture already stabilized in 0.4.5.

### Responsibilities introduced in 0.5.1

- extend Caja PON / ONT and Botella de Empalme with operational fields useful for technical field work
- keep the same entity ownership and same persistence boundaries
- expose richer semantics in active forms and active list screens
- prepare the domain for future relationship and topology work without inventing backend DTOs yet

### Architectural rule in 0.5.1

Operational enrichment belongs to the local domain first, not to speculative remote contracts.

Therefore:

- entity extensions remain nullable and additive
- current forms and list cards become the visible consumers of those fields
- queue, push and pull processors keep the same responsibilities from 0.4.x
- real backend alignment still waits for the future Go structs and transport details

### Explicit non-goals preserved in 0.5.1

- no entity relationships yet
- no topology graph yet
- no real backend Go contract integration yet
- no ServiceProvider ownership changes
- no redesign of the manual synchronization UX
## Phase 0.5.2.1 — Relationship Core Architecture

The Plantel Exterior module now introduces `OutsidePlantRelationship` as a dedicated domain entity stored in `outside_plant_relationships`. This relationship layer is kept intentionally independent from `CajaPonOnt` and `BotellaEmpalme` so that real many-link scenarios can be represented without constraining the model to 1:1 references.

The relationship table is the structural local truth for links between plant entities. It remains local-first, sync-compatible, and remote-contract-neutral until the real backend representation is provided.
