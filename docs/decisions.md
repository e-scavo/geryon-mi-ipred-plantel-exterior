# Decisions

This document captures all confirmed technical and architectural decisions for the repository.

These decisions are **binding** and must not be re-discussed unless explicitly invalidated by a future phase.

The content is cumulative and aligned strictly with the real repository (ZIP as source of truth).

---

## Current Context

- Stage: Stage 0 — Technical Bootstrap
- Phase: Phase 0 — Technical Bootstrap
- Subphase: Phase 0.2.1 — Domain Skeleton & Navigation Entry

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

The repository must reuse the **real existing backend contract**.

Rules:

- do not invent a replacement contract during bootstrap
- adapt future domain work to the real contract
- preserve compatibility with the current backend

---

### 8. Runtime Refactor Policy

During Stage 0:

- no deep ServiceProvider refactor
- no runtime decomposition for aesthetic reasons
- no transport redesign

Allowed:

- minimal safe changes only when required by the active phase

---

## Domain Decisions

### 9. Product Domain

The target domain is:

- passive FTTH outside-plant management

This is the authoritative product direction.

---

### 10. Initial Domain Entities

The domain must explicitly include from the beginning:

1. Caja PON / ONT
2. Botella de Empalme

Rule:

- the system must not be designed as if only one entity exists

---

### 11. CRUD Timing

CRUD for domain entities is **not** part of the controlled clone phase.

Rule:

- defer CRUD until after the technical baseline is stable

---

### 12. Offline Strategy

Offline support is required in the product roadmap, but not in Phase 0.1.

Expected future simplified states:

- pending
- synchronized
- error

---

### 13. Persistence Strategy

Real local persistence is required for the real persistence phase.

Rule:

- do not adopt lightweight placeholder persistence as the product core

However:

- full persistence implementation is deferred beyond Phase 0.1

---

### 14. Map Strategy

Confirmed map technology:

    flutter_map

Rule:

- future map features must be built on flutter_map
- do not introduce an alternative mapping stack

---

## Navigation Decisions

### 15. Navigation Evolution

The application will need a scalable navigation baseline.

Rule:

- this is acknowledged during bootstrap
- but Phase 0.1 does not perform a navigation redesign yet

---

## Platform Decisions

### 16. Supported Platforms

Current supported platforms:

- Web
- Android

Deferred:

- iOS

Rule:

- all bootstrap work must preserve Web + Android compatibility

---

## Repository Hygiene Decisions

### 17. Publication Residue Removal

Inherited publication and release artifacts must be removed from the new repository baseline.

Includes:

- distribution artifacts
- submission bundles
- signing residue
- product-specific publication identity

---

### 18. Signing Isolation

Signing-related inherited artifacts from the original repository must not remain as active operational residue.

Reason:

- avoid accidental release coupling between products

---

## Documentation Decisions

### 19. ZIP as Source of Truth

The attached ZIP is the only authoritative source of truth.

Rules:

- if chat memory conflicts with ZIP → ZIP wins
- docs must reflect ZIP
- implementations must be aligned with ZIP

---

### 20. Documentation Style

Documentation must be:

- cumulative
- incremental
- full-file based
- copy/paste safe

Forbidden:

- placeholders
- destructive summarization
- fragmented markdown delivery

---

### 21. Phase Documentation Requirement

Every phase/subphase must have a dedicated full document.

Rule:

- no phase can be considered complete without documentation

---

## Safety/Change Decisions

### 22. Stability Priority

Bootstrap phases prioritize:

1. runtime stability
2. backend compatibility
3. identity separation
4. safe future extensibility

---

### 23. Minimal Change Principle

Changes should be:

- controlled
- minimal
- justified by current phase scope

Forbidden:

- unnecessary redesign
- speculative cleanup
- broad refactors without phase need

---

### 24. Transitional Tolerance

During bootstrap, the repository may temporarily contain:

- inherited UI
- inherited flows
- non-final product surface

This is acceptable if:

- runtime remains stable
- documentation is explicit
- the final product direction remains clear

---

### 25. Product Surface Transition

Inherited customer-facing screens may remain temporarily while the controlled clone baseline is being established.

Rule:

- do not remove them aggressively before the new product surface is ready

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

---

## Phase 0.2.1 Decisions

### 30. Visible Post-Login Surface Replacement

Decision:

The inherited customer dashboard must stop being the primary visible post-login surface.

Reason:

The new repository already has its own product identity and domain. Keeping the customer dashboard as the visible entrypoint would preserve a false product surface.

Impact:

The application now enters through a Plantel Exterior home surface.

---

### 31. Drawer-Based Main Navigation

Decision:

The first navigation baseline for the new product surface must use a drawer or equivalent simple scalable pattern.

Reason:

The project needs an extensible entry navigation, but the phase must remain low risk and avoid premature complexity.

Impact:

A drawer-based navigation baseline becomes the first visible domain shell.

---

### 32. Both Core Domain Entities Must Exist From the First Visible Domain Phase

Decision:

Phase 0.2.1 must expose both initial domain entities:

- Caja PON / ONT
- Botella de Empalme

Reason:

The product must not be shaped around a single initial entity. Both must be acknowledged from the beginning.

Impact:

Both sections now exist as real navigable screens, even though still in skeleton form.

---

### 33. Skeleton Screens Are Valid at This Stage

Decision:

At this stage, the domain sections may be implemented as functional skeletons instead of full CRUD screens.

Reason:

The objective of the phase is to establish visible product direction and navigation, not complete operational logic.

Impact:

The project gains a real domain shell without introducing premature complexity.

---

### 34. Legacy Modules May Remain Internally While the Visible Surface Changes

Decision:

Inherited modules do not need to be removed yet, as long as they stop being the visible primary surface.

Reason:

Abrupt deletion increases risk and can remove useful technical references.

Impact:

Transition remains controlled and reversible while future phases progressively replace inherited surfaces.

---

### 35. Runtime Ownership Remains Untouched During Visible Surface Transition

Decision:

The visible transition introduced in Phase 0.2.1 must not alter ServiceProvider ownership or backend flow control.

Reason:

The new visible shell is not a justification for runtime redesign.

Impact:

The project preserves its most critical stable subsystem while evolving product identity.

---

## Updated Summary After Phase 0.2.1

Project decisions now establish that:

- Phase 0.1 created the technical clone baseline
- Phase 0.2.1 created the first visible domain shell
- future phases will build on top of that shell instead of returning to the inherited customer dashboard