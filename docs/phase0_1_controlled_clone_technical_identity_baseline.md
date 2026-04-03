# Phase 0.1 — Controlled Clone & Technical Identity Baseline

---

## Objective

Establish a clean and controlled technical baseline for the new product **Mi IP·RED Plantel Exterior** by:

- separating the repository identity from the original Mi IP·RED product
- preserving the proven runtime architecture and backend connectivity
- removing all inherited publication and release artifacts
- ensuring the project compiles and runs correctly after identity normalization

This phase is strictly technical and does not introduce domain functionality.

---

## Initial Context

The repository is derived from an existing, production-ready application (Mi IP·RED) which includes:

- a stable runtime orchestrated by ServiceProvider
- WebSocket-based backend communication (GERYON)
- login and session continuity
- cross-platform support (Web + Android)
- mature architecture and utilities

However, the original repository also contains:

- customer-facing product flows (dashboard, billing)
- publication artifacts (distribution, submission bundles)
- signing configurations and keystore references
- product identity tied to the original application

The goal of this phase is to **retain the technical maturity while removing product identity and operational residue**.

---

## Problem Statement

Cloning a mature application without control introduces several risks:

1. Identity conflict:
   - same package name
   - same applicationId
   - ambiguity between products

2. Publication leakage:
   - reuse of signing keys
   - leftover distribution artifacts
   - Play Store metadata contamination

3. Architectural instability:
   - accidental modification of runtime
   - breaking backend compatibility

4. Documentation inconsistency:
   - mismatch between real code and documented state

Without a controlled clone, the new product would inherit unintended behaviors and risks.

---

## Scope

### Included in this phase

- controlled project cloning
- Dart package renaming (`pubspec.yaml`)
- Android identity normalization:
  - applicationId
  - namespace
  - application label
- minimal Web branding adjustment
- removal of:
  - distribution artifacts
  - submission bundles
  - signing configuration files
  - keystore references
- validation of project build after changes

---

### Explicitly excluded

- domain functionality (Caja PON, Botella de Empalme)
- CRUD operations
- navigation redesign
- map integration
- offline system
- database integration
- runtime refactor
- backend contract changes

---

## Root Cause Analysis

The need for this phase arises from:

- reuse of a production-grade codebase without separation of identity
- coupling between codebase and publication environment
- absence of a clean baseline for a new product domain

Key root causes:

- technical and product identity are intertwined in the source project
- release artifacts are embedded in repository state
- signing configurations are not environment-isolated
- documentation reflects original product, not the new one

---

## Files Affected

### Identity-related

- pubspec.yaml
- android/app/build.gradle or build.gradle.kts
- android/app/src/main/AndroidManifest.xml
- web/index.html

---

### Repository cleanup

- distribution/
- dist/
- android/key.properties
- keystore files under android/app/
- submission bundles and release metadata

---

### Documentation

- README.md
- docs/index.md
- docs/architecture.md
- docs/flows.md
- docs/decisions.md
- this phase document

---

## Implementation Characteristics

This phase follows a **controlled and minimal-change strategy**:

- no changes to runtime logic
- no changes to ServiceProvider
- no changes to backend communication
- no structural refactors

Changes are limited to:

- identity normalization
- repository hygiene
- documentation alignment

---

## Validation

After implementation, the following must be verified:

### Build validation

    flutter clean
    flutter pub get
    flutter analyze
    flutter run -d chrome
    flutter build apk

---

### Functional validation

- application starts correctly
- ServiceProvider initializes without errors
- backend connection is established
- login flow remains operational
- session restore works as before

---

### Repository validation

- no distribution artifacts remain
- no signing files from original project remain
- no conflicting package names exist
- documentation matches current repository state

---

## Release Impact

This phase does not produce a release candidate.

Impact:

- internal only
- establishes baseline for future development
- removes risk for future publication

No deployment or store submission is expected at this stage.

---

## Risks

### 1. Accidental Runtime Breakage

Mitigation:

- do not modify ServiceProvider
- do not alter transport layer

---

### 2. Incomplete Cleanup

Mitigation:

- explicitly remove all known artifact directories
- verify repository manually

---

### 3. Identity Inconsistency

Mitigation:

- ensure all references are updated:
  - Dart package
  - Android applicationId
  - visible app name

---

### 4. Hidden Dependencies on Old Identity

Mitigation:

- test full build
- test runtime initialization

---

## What This Phase Does NOT Solve

This phase does not:

- implement plantel exterior domain
- define UI for field operations
- introduce offline capability
- implement local database
- redesign navigation
- remove all inherited UI components
- optimize architecture

These concerns are intentionally deferred to later phases.

---

## Expected System State After Phase 0.1

After completion, the system must:

- behave identically at runtime compared to the original app
- have a completely new technical identity
- be free from publication artifacts
- be safe to evolve into a new product

Temporary inconsistencies (acceptable):

- inherited UI still present
- domain not yet implemented
- original flows still visible

---

## Strategic Outcome

This phase creates a **safe technical fork** of the original system.

It enables:

- independent product evolution
- clean release pipeline in future
- controlled domain introduction
- risk reduction during transformation

---

## Next Phase Direction

After Phase 0.1, the project will move toward:

- domain modeling (Caja PON / Botella de Empalme)
- navigation restructuring
- local database integration
- offline state handling
- map-based interactions
- progressive UI replacement

---

## Conclusion

Phase 0.1 is a foundational step that prioritizes:

- identity separation
- runtime preservation
- repository hygiene

It ensures that the new product starts from a **stable, clean, and controlled baseline**, avoiding risks associated with directly modifying a production-derived codebase.

All future work depends on the correctness and completeness of this phase.