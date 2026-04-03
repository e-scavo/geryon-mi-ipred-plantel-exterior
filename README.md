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
- **Phase 0.1 — Controlled Clone & Technical Identity Baseline**

The purpose of Phase 0.1 is to create a safe baseline for the new product by:

- separating the repository identity from the original app
- preserving the proven technical runtime
- removing publication/release residue from the source product
- preparing a clean starting point for upcoming outside-plant features

Phase 0.1 does **not** introduce new domain CRUDs, offline sync flows, maps, camera integration, or navigation redesign yet.

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
   - `com.geryon.mi_ipred_plantel_exterior`

2. **Dart package name**
   - `mi_ipred_plantel_exterior`

3. **Local persistence**
   - a real local database must be used from the start
   - lightweight temporary persistence must not become the product core

4. **Backend contract**
   - use the real backend contract (`Table` + `ActionRequest`)
   - do not invent parallel DTOs if real models already exist

5. **Navigation**
   - the app must evolve with a scalable navigation structure from the beginning
   - drawer or equivalent is an acceptable future direction

6. **Map technology**
   - use `flutter_map`

7. **Offline policy**
   - offline must be simple but real
   - expected states include pending / synchronized / error
   - complex sync orchestration is intentionally deferred

These decisions are part of the product baseline and are not under discussion inside the bootstrap stage.

---

## Technology stack

Current technical baseline inherited from the source project:

- Flutter
- Dart
- Riverpod / flutter_riverpod
- WebSocket
- shared_preferences
- conditional imports for Web and IO
- local platform storage abstractions
- file saving abstractions for Web and IO

Additional domain-oriented technologies already decided for future stages:

- real local database baseline
- `flutter_map` for map surfaces

Those future technologies belong to the roadmap, but Phase 0.1 itself is intentionally limited to technical bootstrap and identity normalization.

---

## Observed architecture baseline

The current repository already contains a mature runtime structure that must be preserved as the technical foundation.

High-level boot flow:

    main.dart
      -> ProviderScope
      -> MyApp
      -> MyStartingPage
          -> notifierServiceProvider
              -> ServiceProvider
                  -> runtime initialization
                  -> backend connectivity
                  -> login/session continuity
          -> current post-bootstrap page

Main architectural blocks currently present in the repository:

- `lib/main.dart`
  - application bootstrap
  - ProviderScope creation
  - startup boundary control

- `lib/common_vars.dart`
  - global providers
  - navigator key
  - shared theme/runtime access points

- `lib/core/config/*`
  - config loading abstractions for Web and IO

- `lib/core/session/*`
  - session storage abstractions

- `lib/core/transport/*`
  - WebSocket transport abstractions

- `lib/core/files/*`
  - file saving abstractions

- `lib/core/utils/*`
  - shared utility layer

- `lib/models/ServiceProvider/*`
  - main runtime orchestrator
  - startup coordination
  - failure/recovery semantics
  - auth continuation logic
  - runtime diagnostics

- `lib/models/ServiceProviderConfig/*`
  - configuration flow and runtime configuration widgets/models

- `lib/models/SessionStorage/*`
  - compatibility layer for remembered session data

- `lib/models/GeryonSocket/*`
  - transport/client abstractions preserved from the source system

- `lib/models/Common*/*`, `lib/models/GenericDataModel/*`, `lib/models/tbl_*/*`
  - shared backend/domain models
  - procedure and table-oriented data contracts

- `lib/features/*`
  - higher-level application contracts and feature organization

- `lib/shared/*`
  - reusable layouts, widgets, and shared UI helpers

- `lib/pages/*`
  - current visual entry points inherited from the source project

This structure is the reason the project can be safely cloned without redesigning the entire runtime from day one.

---

## What Phase 0.1 changes

Phase 0.1 is intentionally narrow and controlled.

It includes:

- controlled project cloning
- technical identity replacement
- `pubspec.yaml` project-name normalization
- Android package identity normalization
- visible application label normalization
- minimum Web branding review
- cleanup of release/publication residue
- cleanup of signing material that must not be reused
- validation that the project still builds after the controlled clone

It does not include:

- new product navigation
- domain CRUDs
- map integration
- camera integration
- offline implementation
- runtime redesign
- deep refactors of ServiceProvider
- contract redesign against the backend

---

## Functional status at this stage

At this stage, the repository still inherits technical and UI elements from the original product baseline.

That is expected.

The purpose of Phase 0.1 is **not** to finish the field product surface.  
The purpose is to establish a safe technical starting point so subsequent phases can replace inherited customer-facing areas gradually and safely.

Therefore, during bootstrap:

- some source-product screens may still exist in code
- some source-product assets may still be present before cleanup
- the original product flow may still be temporarily visible in the inherited runtime
- the final outside-plant surface is not yet implemented

This is acceptable as long as the repository identity and technical baseline are normalized correctly.

---

## Repository hygiene baseline

The source ZIP confirms that the inherited repository contains publication and signing residue that must not remain as part of the new product baseline.

That residue includes, depending on the original source package contents:

- `distribution/`
- generated publication surfaces
- submission bundles
- release metadata from the source product
- `android/key.properties`
- local keystore references
- keystore files under project storage

For the new product baseline:

- signing material must be local-only and environment-specific
- generated store/publication outputs must not define the cloned product identity
- source-product publication surfaces must be removed from the inherited repository state

This cleanup is part of the controlled-clone contract.

---

## Running the project

### Web

    flutter pub get
    flutter run -d chrome

### Android

    flutter pub get
    flutter run -d android

### Technical validation after Phase 0.1 identity normalization

    flutter clean
    flutter pub get
    flutter analyze
    flutter run -d chrome
    flutter build apk

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