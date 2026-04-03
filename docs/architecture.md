# Architecture

This document describes the current technical architecture of the repository based strictly on the real project state (ZIP as source of truth).

The architecture described here corresponds to:

- Stage 0 — Technical Bootstrap
- Phase 0 — Technical Bootstrap
- Phase 0.2.1 — Domain Skeleton & Navigation Entry

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