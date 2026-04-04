# Flows

This document describes the current runtime and system flows of the application, based strictly on the real repository state (ZIP as source of truth).

The flows described here correspond to:

- Stage 0 — Technical Bootstrap
- Phase 0 — Technical Bootstrap
- Phase 0.2.2 — Domain Modeling & Contracts Baseline

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
