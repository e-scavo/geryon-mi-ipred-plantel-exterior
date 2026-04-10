# Flows

This document describes the current runtime and system flows of the application, based strictly on the real repository state (ZIP as source of truth).

The flows described here correspond to:

- Stage 0 — Technical Bootstrap
- Phase 0 — Technical Bootstrap
- Phase 0.4.2 — Backend Push Sync

At this stage, flows are inherited from Mi IP·RED and must be preserved without functional redesign.

---

## Flow Philosophy

The system is designed around a **runtime-controlled flow**, where:

- the UI does not own business logic
- the runtime (ServiceProvider) orchestrates all core operations
- backend communication is centralized
- session continuity is enforced

All flows must respect this structure.

---

## Core Flows Overview

The following flows are considered critical and must remain stable:

1. Application Startup Flow
2. Configuration Load Flow
3. Session Restore Flow
4. Backend Connection Flow
5. Login Continuity Flow
6. Runtime Ready Flow
7. UI Interaction Flow
8. Request/Response Flow (backend)
9. File Handling Flow

---

## 1. Application Startup Flow

Entry point:

    lib/main.dart

Flow:

    App launch
        → Flutter initialization
        → ProviderScope creation
        → MyApp
        → MyStartingPage
        → ServiceProvider initialization

Characteristics:

- minimal UI involvement
- delegates logic to runtime
- must remain stable across phases

---

## 2. Configuration Load Flow

Flow:

    ServiceProvider init
        → load configuration
            → Web or IO specific loader
        → validate configuration
        → expose config to runtime

Sources:

    lib/core/config/
    lib/models/ServiceProviderConfig/

Characteristics:

- platform-aware
- required before backend connection
- failure blocks runtime initialization

---

## 3. Session Restore Flow

Flow:

    App start
        → read stored session
        → validate stored data
        → hydrate runtime session state

Sources:

    lib/core/session/
    lib/models/SessionStorage/

Possible outcomes:

- valid session → continue login
- invalid session → require login

---

## 4. Backend Connection Flow

Flow:

    ServiceProvider
        → initialize WebSocket
        → attempt connection
        → handle success or failure

Sources:

    transport/websocket-related modules
    ServiceProvider integration points

Characteristics:

- critical system flow
- must remain unbroken
- tightly coupled with startup lifecycle

---

## 5. Login Continuity Flow

Flow:

    Session available?
        → yes → attempt authenticated continuity
        → no → request login

Then:

    login request
        → backend validation
        → runtime state update
        → session persistence

Characteristics:

- centralized in runtime/service flow
- must not be rewritten during bootstrap
- visible UI is secondary to runtime decision

---

## 6. Runtime Ready Flow

Flow:

    ServiceProvider startup complete
        → state marked ready
        → UI may render operational screen

This flow is critical because UI readiness depends on runtime readiness.

The UI must not bypass this sequence.

---

## 7. UI Interaction Flow

At the current stage, UI interaction remains reactive:

    User action
        → UI event
        → provider/runtime interaction
        → state update
        → UI rebuild

Characteristics:

- UI is not the source of truth
- runtime/provider state controls behavior
- inherited UI still exists during bootstrap

---

## 8. Backend Request / Response Flow

Conceptual flow:

    UI or runtime event
        → request construction
        → WebSocket send
        → backend processing
        → response receive
        → state/model update
        → UI refresh if needed

Critical rule:

- this flow must remain compatible with the inherited backend contract

---

## 9. File Handling Flow

The inherited application includes file-related abstractions to support:

- cross-platform compatibility
- asset access
- stored file operations
- future extensibility

At the current stage, file handling is not the primary focus, but its abstractions remain part of the runtime baseline.

---

## Flow Preservation Rule

During bootstrap phases, the following flows must remain preserved:

- startup
- backend connect
- login/session restore
- request/response
- runtime ready transition

Any break in these flows is considered a regression.

---

## UI vs Runtime Ownership

This repository follows a strong ownership model:

### Runtime owns:

- startup orchestration
- connection lifecycle
- session restoration
- backend state

### UI owns:

- rendering
- user interaction capture
- reactive presentation

This distinction must remain intact.

---

## Transitional Flow State

Because the repository is still in Stage 0:

- inherited UI/product flows may still appear
- some visible screens may not match the final target product yet
- this is acceptable only if core technical flows remain intact

This is a transitional condition, not the final state.

---

## Why flows must not be rewritten early

Premature flow rewrites are risky because:

- they can break backend compatibility
- they can break startup assumptions
- they can invalidate session continuity
- they can create regressions difficult to isolate

That is why bootstrap focuses first on technical stabilization, not flow redesign.

---

## Current Phase Impact on Flows

Phase 0.1 does **not** redesign runtime flows.

It only affects:

- application identity
- build configuration
- repository hygiene

All runtime flows must behave exactly as before.

---

## Constraints for Flow Stability

During Phase 0.1:

- do not modify startup sequence
- do not modify ServiceProvider flow
- do not change backend communication model
- do not alter session logic
- do not introduce parallel flows

---

## Future Flow Evolution

After bootstrap, flows will expand to include:

- Caja PON / ONT management
- Botella de Empalme management
- field operation workflows
- offline state transitions:
  - pending
  - synchronized
  - error
- map-based interactions
- data synchronization flows

These will be layered on top of existing runtime flows.

---

## Flow Ownership Model

| Flow | Owner |
|-----|------|
| Startup | ServiceProvider |
| Config | Config Layer |
| Session | Session Layer |
| Backend | Transport Layer |
| Login | ServiceProvider |
| Requests | ServiceProvider |
| Files | File Layer |
| UI | Reactive Consumer |

---

## Summary

The system operates as a runtime-driven architecture where:

- ServiceProvider is the central orchestrator
- UI reacts to runtime state
- backend communication is centralized
- flows are sequential and dependent

Phase 0.1 preserves all these flows unchanged while establishing a clean technical identity baseline for the new product.

---

## Conclusion

Maintaining flow integrity is critical during the bootstrap phase.

The system must remain:

- predictable
- stable
- backend-compatible

Only after Phase 0.1 is fully stabilized should new domain flows be introduced.

---

## Phase 0.2.1 Flow Extension — Domain Skeleton & Navigation Entry

Phase 0.2.1 preserves all runtime-controlled core flows from Phase 0.1, but changes the first visible application destination after startup/login continuity is complete.

### New visible post-login flow

Before:

    App startup
        → runtime ready
        → inherited customer dashboard

After Phase 0.2.1:

    App startup
        → runtime ready
        → PlantelExteriorHomeScreen

This is the most important flow change of the phase.

### New main surface navigation flow

Once inside the new home surface, the user can navigate through the drawer.

Flow:

    User opens drawer
        → selects section
        → plantelExteriorNavigationProvider updates current section
        → PlantelExteriorHomeScreen rebuilds active body
        → selected section becomes visible

### Sections currently available

The new flow exposes these product sections:

- Home
- Cajas PON / ONT
- Botellas de Empalme

### Home section flow

    Drawer
        → Home
        → PlantelExteriorHomeView rendered

Purpose:

- establish visible product identity
- communicate that the app is now an outside-plant field product
- serve as initial landing surface for upcoming domain growth

### Cajas PON / ONT section flow

    Drawer
        → Cajas PON / ONT
        → CajasPonOntScreen rendered

Current state:

- real screen
- skeleton behavior
- no CRUD yet

### Botellas de Empalme section flow

    Drawer
        → Botellas de Empalme
        → BotellasEmpalmeScreen rendered

Current state:

- real screen
- skeleton behavior
- no CRUD yet

### Logout continuity flow

The new drawer also exposes logout without changing the original logout ownership model.

    Drawer
        → Cerrar sesión
        → ApplicationCoordinator.performLogoutReset(ref: ref)

This preserves the inherited session reset flow.

### What Phase 0.2.1 does not change in flows

Phase 0.2.1 does not change:

- startup ownership
- configuration loading
- backend transport sequence
- login continuity
- session restoration
- backend request/response semantics

Only the visible destination and local domain navigation entry change.

### Flow significance

This phase is the first transition where the repository stops flowing visibly into a customer-product dashboard and starts flowing into a field-domain entry surface.

---

## Phase 0.2.2 Flow Extension — Domain-aware Presentation Baseline

Phase 0.2.2 preserves the runtime-controlled flow introduced in previous phases, but changes what happens inside the visible Plantel Exterior sections.

### Before Phase 0.2.2

The section flow was:

    App startup
        → runtime ready
        → PlantelExteriorHomeScreen
        → user opens a section
        → placeholder-only presentation

### After Phase 0.2.2

The section flow becomes:

    App startup
        → runtime ready
        → PlantelExteriorHomeScreen
        → user opens a section
        → section builds a real domain entity
        → UI renders typed domain fields

### Caja PON / ONT section flow

Current conceptual flow:

    Drawer
        → Cajas PON / ONT
        → CajasPonOntScreen
        → instantiate CajaPonOnt
        → render:
            - id
            - code
            - description
            - optional location
            - sync status

### Botella de Empalme section flow

Current conceptual flow:

    Drawer
        → Botellas de Empalme
        → BotellasEmpalmeScreen
        → instantiate BotellaEmpalme
        → render:
            - id
            - code
            - description
            - optional location
            - sync status

### Home section flow update

The home view now explains that the repository includes:

- real domain entities
- value objects
- repository contracts baseline

This means the home section is no longer describing only a visual shell.  
It now describes a structural domain milestone.

### Important limitation of current flow

Even after Phase 0.2.2, these flows are still:

- in-memory
- example-driven
- non-persistent
- not backend-backed

That is acceptable because the objective of the phase is to introduce domain structure, not data infrastructure.

### Flow significance of Phase 0.2.2

This phase introduces the first **domain-aware presentation flow** of the repository.

The UI no longer renders only textual placeholders.  
It now renders information derived from explicit domain objects, which is the necessary bridge toward CRUD, persistence and offline flows in later phases.


---

## Phase 0.2.3 Flow Extension — Local Persistence Baseline

Phase 0.2.3 preserves all prior runtime-controlled flows, but it changes how Plantel Exterior screens obtain their data.

### New persistence-backed feature flow

Before Phase 0.2.3:

    User enters Plantel Exterior section
        → widget instantiates example entity in memory
        → UI renders example data

After Phase 0.2.3:

    User enters Plantel Exterior section
        → Riverpod provider resolves repository
        → repository ensures seed data when needed
        → repository reads Drift database
        → database rows are mapped into domain entities
        → UI renders persisted domain data

### Database initialization flow

    Provider creation
        → PlantelExteriorDatabase instantiated
        → Lazy database connection opened on first use
        → local SQLite file resolved in application documents directory

This flow introduces durable local state without changing startup/runtime ownership.

### Seed flow

The repository now includes a seed path to guarantee non-empty initial rendering:

    Screen provider triggered
        → repository.ensureSeedData()
        → check if Caja table has rows
        → if empty, insert initial Caja record
        → insert initial Botella record
        → proceed with regular read

This seed path is idempotent for subsequent reads because it exits as soon as seed data already exists.

### Cajas PON / ONT flow update

    Drawer
        → Cajas PON / ONT
        → cajasPonOntListProvider
        → DriftOutsidePlantRepository
        → PlantelExteriorDatabase
        → read persisted rows
        → map rows to CajaPonOnt
        → render cards in UI

Rendered information now includes:

- id
- code
- description
- optional location
- sync status
- createdAt
- updatedAt

### Botellas de Empalme flow update

    Drawer
        → Botellas de Empalme
        → botellasEmpalmeListProvider
        → DriftOutsidePlantRepository
        → PlantelExteriorDatabase
        → read persisted rows
        → map rows to BotellaEmpalme
        → render cards in UI

Rendered information now includes:

- id
- code
- description
- optional location
- sync status
- createdAt
- updatedAt

### Home flow update

The home view no longer describes only architecture intent.
It now summarizes persisted module information through providers.

    Home section
        → cajasPonOntListProvider
        → botellasEmpalmeListProvider
        → provider-backed counts
        → InfoCard values updated

### Persistence limitation of current flow

Even after Phase 0.2.3, these flows are still:

- local-only
- not synchronized with backend domain data
- not web-enabled
- still lacking create/edit/delete UI workflows

That is acceptable because the objective of the phase is to introduce durable local state, not full operational workflows.

### Flow significance of Phase 0.2.3

This phase introduces the first **persistence-backed presentation flow** of the repository.

The Plantel Exterior UI no longer depends on placeholder strings or manually instantiated entities.
It now depends on repository-mediated local storage, which is the necessary bridge toward CRUD, offline and synchronization work in later phases.

---

## Phase 0.2.4 Flow Extension — Web Persistence Support

Phase 0.2.4 extends the persistence-backed flows to Web environments.

### New flow characteristics

    Provider initialization
        → platform-aware DB selection
        → WASM-compatible database initialization
        → ensure correct resource loading
        → proceed with persistence-backed flows

### Impact

- persistence flows now execute across:
  - Android
  - Desktop
  - Web
- no change to runtime ownership (ServiceProvider remains unchanged)

---

## Phase 0.3.1 Flow Extension — Create

Phase 0.3.1 introduces creation flows into the system.

### Create flow

    User action (create)
        → UI form input
        → provider call
        → repository insert
        → database write
        → provider invalidation
        → UI refresh

### Impact

- transitions from read-only to write-enabled system
- first full user-driven data mutation flow

---

## Phase 0.3.2 Flow Extension — Update

Phase 0.3.2 introduces update flows.

### Update flow

    User action (edit)
        → UI loads entity
        → user modifies fields
        → provider call
        → repository update
        → database write
        → provider invalidation
        → UI refresh

### Impact

- allows correction and evolution of persisted data
- maintains entity identity consistency

---

## Phase 0.3.3 Flow Extension — Delete

Phase 0.3.3 introduces delete flows.

### Delete flow

    User action (delete)
        → confirmation dialog
        → provider call
        → repository delete
        → database removal
        → provider invalidation
        → UI refresh

### Impact

- completes CRUD lifecycle
- ensures full entity lifecycle control

---

## Phase 0.3.4 Flow Extension — CRUD UX Minimum Layer

Phase 0.3.4 introduces usability improvements on top of CRUD flows.

### UX-enhanced flow

    User action
        → validation
        → loading state
        → operation execution
        → success/error feedback
        → UI update

### Impact

- reduces user error
- improves clarity of operations
- introduces minimum operational UX layer




---

## 10. Outside-Plant Local Mutation + Sync Trace Flow

Phase 0.4.1 adds a new module-level flow for outside-plant entities.

### Create / Update

    User submits form
        → form validation
        → Riverpod mutation provider
        → OutsidePlantSyncService
        → persist entity locally
        → capture local snapshot JSON
        → enqueue pending sync item
        → invalidate list providers
        → UI rebuild from local DB

### Delete

    User confirms delete
        → Riverpod mutation provider
        → OutsidePlantSyncService
        → capture delete tombstone JSON
        → enqueue pending sync item
        → delete entity locally
        → invalidate list providers
        → UI rebuild from local DB

Characteristics:

- local-first behavior preserved
- no direct widget/backend coupling
- no speculative remote payload contract
- queue remains local and transport-agnostic

---

## Phase 0.4.2 — Outside-Plant Push Flow

Phase 0.4.2 adds the first active synchronization cycle for the module.

Conceptual flow:

    UI technical trigger or future orchestrator
        → push processor starts cycle
        → read pending/error queue items
        → mark item as processing
        → dispatch by entity type + operation type
        → invoke remote sync contract
        → if success:
              → mark local entity as synced when applicable
              → remove queue item
        → if error:
              → persist error in queue
              → keep item available for future retry

Characteristics:

- local database remains the authoritative operational state
- queue is the authoritative synchronization workload
- remote adapter is isolated behind a dedicated boundary
- push does not imply pull
- push does not imply conflict resolution

---

## Phase 0.4.3 — Outside-Plant Pull Refresh Flow

Phase 0.4.3 adds the remote refresh path with conservative local reconciliation.

Conceptual flow:

    UI technical trigger or future orchestrator
        → pull processor starts cycle
        → fetch remote cajas and botellas snapshots
        → for each remote item:
              → if local row does not exist:
                    → insert locally as synced
              → if local row exists and is synced:
                    → update local row from remote snapshot
              → if local row exists and is pending/error:
                    → skip automatic overwrite
        → invalidate list providers
        → UI rebuild from local DB

Characteristics:

- local-first behavior is preserved
- pull does not consume or replace the push queue
- pull does not overwrite local work in progress
- pull does not implement remote deletions yet


---

## Phase 0.4.4 — Synchronization UX Flow

Phase 0.4.4 adds a visible presentation cycle around the already existing push and pull processors.

Conceptual flow:

    user presses push or pull action
        → presentation sync-ui provider marks the execution as running
        → existing processor runs
        → result is translated into a user-visible summary
        → pending counters and lists are invalidated as needed
        → home widgets and list cards rebuild from local data + presentation summaries

Characteristics:

- the execution still depends on the same processors from 0.4.2/0.4.3
- UX state is ephemeral and presentation-scoped
- list cards surface `pending`, `synced` and `error` more clearly
- edit forms explain why a saved row returns to `pending`


---

## Phase 0.4.5 — Synchronization Hardening Flow

Phase 0.4.5 keeps the same visible push/pull controls from 0.4.4 but reduces the execution flow to a single hardened path.

Conceptual flow:

    user presses push or pull action
        → sync-ui notifier checks whether another execution is already running
        → if busy: action is rejected and a short UX message is shown
        → if allowed: notifier marks the selected action as running
        → existing processor runs
        → list and counter providers are invalidated
        → notifier stores the final summary or error
        → home widgets rebuild from local state + presentation summaries

Characteristics:

- no alternative provider-based action path remains
- push and pull cannot be started concurrently from the supported UX path
- durable local-first behavior remains unchanged
- hardening is additive and does not invent backend contracts


---

## Phase 0.5.1 — Operational Data Capture And Inspection Flow

Phase 0.5.1 keeps the same create/update/delete and sync flow ownership, but enriches the data that moves through those flows.

Conceptual flow:

    user opens create/edit form
        → enters base identity fields
        → optionally enters operational fields
             → technical code
             → external reference
             → operational status
             → criticidad
             → zona / sector / tramo
             → technical notes
        → local validation runs
        → local entity is saved
        → sync queue snapshot is generated with the richer payload
        → active list screens rebuild from local DB
        → row card exposes a richer operational summary

Characteristics:

- local-first ownership remains unchanged
- operational fields are optional and additive
- manual push/pull still use the same queue and processors from 0.4.x
- the richer payload remains local-domain oriented until the final backend contract is introduced
