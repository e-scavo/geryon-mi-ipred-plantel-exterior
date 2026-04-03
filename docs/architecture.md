# Architecture

This document describes the current technical architecture of the repository based strictly on the real project state (ZIP as source of truth).

The architecture described here corresponds to:

- Stage 0 — Technical Bootstrap
- Phase 0 — Technical Bootstrap
- Phase 0.1 — Controlled Clone & Technical Identity Baseline

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
- state propagation system
- lifecycle boundary between UI and runtime

At this stage, providers must remain stable and unchanged.

---

## Transport Layer

### WebSocket Client

Location:

    lib/core/transport/
    lib/models/GeryonSocket/

Responsibilities:

- establish connection with backend
- send and receive messages
- maintain persistent channel
- handle reconnection scenarios

Characteristics:

- backend communication is stateful
- request/response model is abstracted through transport
- tightly integrated with ServiceProvider

---

## Backend Contract Layer

The application uses a contract based on:

- Table
- ActionRequest
- Generic models

Locations:

    lib/models/tbl_*/
    lib/models/GenericDataModel/
    lib/models/Common*/*

Characteristics:

- no DTO duplication
- direct usage of backend-aligned models
- strongly tied to GERYON backend behavior

This contract must not be replaced or abstracted during bootstrap.

---

## Session Layer

Location:

    lib/core/session/
    lib/models/SessionStorage/

Responsibilities:

- store authentication data
- restore session on startup
- maintain login continuity

Supports:

- Web storage
- IO storage (Android/Desktop)

This layer ensures that login state survives app restarts.

---

## Configuration Layer

Location:

    lib/core/config/
    lib/models/ServiceProviderConfig/

Responsibilities:

- load runtime configuration
- adapt behavior between Web and IO
- provide configuration to runtime layer

Characteristics:

- uses conditional imports
- must remain compatible across platforms

---

## File Abstraction Layer

Location:

    lib/core/files/

Responsibilities:

- save files (downloads, exports)
- abstract differences between Web and IO

Used by:

- features requiring file output
- backend responses that generate files

---

## Utility Layer

Location:

    lib/core/utils/

Responsibilities:

- shared helpers
- formatting
- generic logic reused across layers

This layer must remain generic and not domain-specific.

---

## UI Layer

Locations:

    lib/pages/
    lib/shared/
    lib/features/

Responsibilities:

- render UI
- consume runtime state via providers
- trigger actions through ServiceProvider

Current status:

- still contains inherited UI from original product
- not yet aligned with plantel exterior domain

This is expected during bootstrap.

---

## Data Flow Overview

### Startup Flow

    main.dart
        → ProviderScope
        → MyApp
        → MyStartingPage
            → ServiceProvider initialization
                → config load
                → session restore
                → backend connect
                → login validation
                → ready state

---

### Runtime Flow

    UI
      ↔ ServiceProvider
          ↔ WebSocket Transport
              ↔ Backend

---

### Session Flow

    App start
        → load session
        → validate token
        → continue login or request login

---

## Platform Strategy

The application supports:

- Web
- Android

Using:

- conditional imports
- shared abstractions for storage and files

This strategy must remain intact during bootstrap.

---

## Persistence Strategy (Current vs Future)

Current state:

- session persistence implemented
- lightweight storage in place

Future direction (already decided):

- introduce real local database
- support offline states:
  - pending
  - synchronized
  - error

Important:

This is NOT implemented in Phase 0.1.

---

## Navigation Strategy

Current state:

- inherited navigation from original app

Future requirement:

- scalable navigation (drawer or equivalent)

Important:

Navigation redesign is NOT part of Phase 0.1.

---

## Map Integration

Future decision:

- use flutter_map

Current state:

- not implemented

---

## Offline Strategy

Future decision:

- simple but real offline system

States:

- pending
- synchronized
- error

Current state:

- not implemented

---

## Architecture Constraints (Critical)

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