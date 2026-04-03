# Decisions

This document captures all confirmed technical and architectural decisions for the repository.

These decisions are **binding** and must not be re-discussed unless explicitly invalidated by a future phase.

The content is cumulative and aligned strictly with the real repository (ZIP as source of truth).

---

## Current Context

- Stage: Stage 0 — Technical Bootstrap
- Phase: Phase 0 — Technical Bootstrap
- Subphase: Phase 0.1 — Controlled Clone & Technical Identity Baseline

---

## Decision Philosophy

All decisions follow these principles:

- stability over innovation during bootstrap
- reuse of proven technical components
- minimal changes to runtime behavior
- explicit constraints to avoid architectural drift
- alignment with real implementation (ZIP)

---

## Identity Decisions

### 1. Product Identity

The repository represents a **new product**, not a continuation of the original.

- Name: Mi IP·RED Plantel Exterior
- Domain: FTTH outside-plant management
- Product type: field operational application

Implication:

- original product behavior is not authoritative
- inherited code is technical base only

---

### 2. Dart Package Name

The Dart package name is fixed:

    mi_ipred_plantel_exterior

Must be applied in:

- pubspec.yaml
- project identity

---

### 3. Android Application Identity

The Android identity is fixed:

    applicationId: com.geryon.mi_ipred_plantel_exterior
    namespace: com.geryon.mi_ipred_plantel_exterior

Must be applied consistently across:

- build.gradle / build.gradle.kts
- AndroidManifest.xml

---

## Architecture Decisions

### 4. Runtime Ownership

The runtime owner is:

    ServiceProvider

Rules:

- must remain the central orchestrator
- must not be redesigned during bootstrap
- must not be bypassed by UI or other layers

---

### 5. Provider System

State management is based on:

    Riverpod

Rules:

- providers remain the integration layer between UI and runtime
- global providers defined in common_vars.dart must remain stable
- no alternative state management introduced during bootstrap

---

### 6. Transport Layer

Backend communication is based on:

    WebSocket

Rules:

- persistent connection model must be preserved
- request/response must remain stateful
- no REST replacement or abstraction introduced

---

### 7. Backend Contract

The system uses the real backend contract:

- Table
- ActionRequest
- GenericDataModel

Rules:

- do not introduce parallel DTOs
- do not wrap or abstract existing contract unnecessarily
- use models aligned with backend

---

## Persistence Decisions

### 8. Local Persistence Strategy

Decision:

- use a real local database from the start

Rules:

- temporary lightweight persistence must not become core
- future offline support depends on this

Important:

This is a forward decision and not fully implemented in Phase 0.1.

---

### 9. Session Persistence

Session handling must:

- persist login state
- support restore on startup
- remain cross-platform (Web + IO)

This is already implemented and must remain unchanged.

---

## Navigation Decisions

### 10. Navigation Strategy

Decision:

- navigation must be scalable from the beginning

Expected direction:

- drawer-based or equivalent

Important:

- no redesign during Phase 0.1
- current navigation remains inherited

---

## Map Decision

### 11. Map Technology

Decision:

    flutter_map

Rules:

- must be used for map features
- avoid dependencies requiring API keys (e.g., Google Maps)

Not implemented in Phase 0.1.

---

## Offline Decisions

### 12. Offline Strategy

Decision:

- offline must be simple but real

States required:

- pending
- synchronized
- error

Rules:

- no complex sync engine initially
- must integrate with real local database

Not implemented in Phase 0.1.

---

## Domain Decisions

### 13. Core Entities

The system must consider from the beginning:

1. Caja PON / ONT
2. Botella de Empalme

Rules:

- do not design system for a single entity
- domain must support both from early stages

---

## Bootstrap Constraints

### 14. No Runtime Redesign

During Stage 0:

- do not redesign ServiceProvider
- do not refactor runtime flow
- do not introduce new architecture layers

---

### 15. No Backend Disruption

Must not break:

- WebSocket connection
- login flow
- session continuity
- request/response contract

---

### 16. Minimal Change Policy

Changes must be:

- controlled
- minimal
- reversible if needed

Avoid:

- large refactors
- structural mutations

---

## Repository Hygiene Decisions

### 17. Release Artifact Cleanup

The following must NOT remain in the repository baseline:

- distribution/
- dist/
- submission bundles
- release metadata from original app

---

### 18. Signing Material

The following must be removed or not reused:

- android/key.properties
- keystore files
- upload keys from original product

Rules:

- signing must be environment-specific
- not inherited from source project

---

## Platform Decisions

### 19. Supported Platforms

Current:

- Web
- Android

Future:

- iOS (not part of bootstrap)

---

### 20. Cross-Platform Strategy

Use:

- conditional imports
- shared abstractions

Rules:

- maintain compatibility across platforms
- do not introduce platform divergence

---

## Documentation Decisions

### 21. Source of Truth

The only valid source:

    the real ZIP repository

Rules:

- documentation must match code
- assumptions are not allowed
- contradictions must be resolved in favor of code

---

### 22. Documentation Model

Documentation must be:

- incremental
- cumulative
- complete (no partial files)
- copy/paste safe

Must always update:

- README.md
- docs/index.md
- docs/architecture.md
- docs/flows.md
- docs/decisions.md
- phase-specific document

---

## Phase 0.1 Specific Decisions

### 23. Controlled Clone Strategy

Phase 0.1 must:

- create a new technical identity
- preserve runtime
- remove release artifacts
- validate build stability

---

### 24. No Functional Expansion

Phase 0.1 must NOT include:

- CRUDs
- map features
- offline system
- navigation redesign
- domain UI implementation

---

### 25. Identity Separation

The repository must:

- clearly separate from original product identity
- avoid confusion in package names
- avoid reuse of publication assets

---

## Risk Decisions

### 26. Stability Priority

Priority order:

1. runtime stability
2. backend compatibility
3. identity separation
4. future scalability

---

### 27. Controlled Transition

The system may temporarily:

- contain inherited UI
- expose non-final flows

This is acceptable during bootstrap.

---

## Future-Oriented Decisions

### 28. Domain Evolution

Future phases will introduce:

- entity modeling
- field workflows
- map integration
- offline behavior
- local database usage

---

### 29. Progressive Replacement

Inherited elements will be:

- replaced gradually
- not removed abruptly

This reduces risk.

---

## Summary

These decisions define:

- what is fixed
- what is allowed
- what is forbidden

They ensure:

- consistency
- stability
- controlled evolution

Any implementation that violates these decisions must be considered incorrect.

---

## Conclusion

This document acts as the contract for all technical work in the repository.

During Phase 0.1, the focus is:

- identity normalization
- runtime preservation
- repository cleanup

All future phases must build on top of these decisions without breaking them.