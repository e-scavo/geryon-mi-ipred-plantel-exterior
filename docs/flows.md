# Flows

This document describes the current runtime and system flows of the application, based strictly on the real repository state (ZIP as source of truth).

The flows described here correspond to:

- Stage 0 — Technical Bootstrap
- Phase 0 — Technical Bootstrap
- Phase 0.1 — Controlled Clone & Technical Identity Baseline

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

    lib/core/transport/
    lib/models/GeryonSocket/

Characteristics:

- persistent connection
- retry logic present
- tightly coupled with runtime

Failure handling:

- retry connection
- surface error state to runtime

---

## 5. Login Continuity Flow

Flow:

    After connection
        → check session/token
        → validate with backend
        → either:
            → continue authenticated session
            → request login

Characteristics:

- automatic when possible
- user interaction only if required

Important:

Login flow must not be broken during bootstrap.

---

## 6. Runtime Ready Flow

Flow:

    Config loaded
    + Session resolved
    + Backend connected
        → runtime enters READY state

Effects:

- UI can render main screens
- actions can be executed
- backend requests enabled

---

## 7. UI Interaction Flow

Flow:

    UI event
        → provider call
        → ServiceProvider method
        → backend request (if needed)
        → response handled
        → state updated
        → UI re-render

Characteristics:

- UI is reactive, not authoritative
- all logic flows through ServiceProvider
- no direct backend calls from UI

---

## 8. Request / Response Flow (Backend)

Flow:

    UI or runtime
        → build request (Table / ActionRequest)
        → send via WebSocket
        → await response
        → parse response
        → update models/state

Sources:

    lib/models/tbl_*/
    lib/models/GenericDataModel/
    lib/models/Common*/*

Characteristics:

- strongly tied to backend contract
- no DTO abstraction layer
- transport is stateful

---

## 9. File Handling Flow

Flow:

    Backend response (file data)
        → processed by runtime
        → passed to file abstraction
        → saved or downloaded

Sources:

    lib/core/files/

Characteristics:

- platform-specific handling
- unified abstraction for Web and IO

---

## Flow Dependencies

Critical dependencies between flows:

- Configuration must complete before backend connection
- Session restore must complete before login continuity
- Backend connection must exist before requests
- Runtime must be READY before UI actions

---

## Error Handling Strategy

Errors can occur in:

- configuration load
- session restore
- backend connection
- request/response cycle

Handling approach:

- retry where possible
- fail fast when critical
- surface state to runtime
- avoid UI-level error ownership

---

## Transitional State (Phase 0.1)

During this phase:

- flows remain unchanged from original app
- UI may not match final domain
- some flows may appear unrelated to plantel exterior

This is expected.

---

## What Phase 0.1 Changes in Flows

Phase 0.1 does NOT change flow logic.

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