# Documentation Index

This document acts as the central navigation point for all technical and product documentation of the repository.

The documentation set is **cumulative, incremental, and strictly aligned with the real repository state (ZIP as source of truth)**.

---

## Current Stage

- Stage: **Stage 0 — Technical Bootstrap**
- Phase: **Phase 0 — Technical Bootstrap**
- Active subphase: **Phase 0.3.4 — CRUD UX Minimum Layer**

---

## Documentation Principles

All documentation in this repository follows strict rules:

- must be based on the real repository state (ZIP)
- must be incremental (never rewrite history incorrectly)
- must be cumulative (never remove previous valid context)
- must not include placeholders
- must not summarize previous documentation incorrectly
- must remain copy/paste safe (no broken markdown)

---

## Documentation Structure

The documentation is organized into the following core files:

### 1. Architecture

File:

    docs/architecture.md

Purpose:

- describe the real technical architecture of the application
- reflect the actual runtime structure (ServiceProvider, WebSocket, etc.)
- evolve as phases introduce structural changes

---

### 2. Flows

File:

    docs/flows.md

Purpose:

- document runtime flows and system behavior
- include login, session, startup, backend communication
- expand with domain flows in later phases

---

### 3. Decisions

File:

    docs/decisions.md

Purpose:

- capture all confirmed technical and architectural decisions
- serve as the single source of truth for constraints and rules
- avoid re-discussion of already defined decisions

---

### 4. Phase Documentation

Each phase must have its own dedicated document.

Current:

    docs/phase0_1_controlled_clone_technical_identity_baseline.md
    docs/phase0_2_1_domain_skeleton_navigation_entry.md

Purpose:

- describe the phase in full detail
- include:
  - objective
  - scope
  - root cause
  - implementation characteristics
  - validation
  - risks
  - impact

Future phases will follow the same structure.

---

## Phase Tracking Model

Phases are structured hierarchically:

- Stage
- Phase
- Subphase

Example:

- Stage 0
- Phase 0
- Phase 0.1

Each subphase must:

- have a dedicated document
- be fully documented before moving forward
- maintain compatibility with previous phases

---

## Current Documentation Coverage

The current documentation covers:

1. repository/product identity separation
2. preservation of technical runtime baseline
3. architecture inherited from Mi IP·RED
4. runtime-critical flows
5. fixed decisions for Stage 0
6. Phase 0.1 controlled clone baseline

As the project evolves, documentation must progressively shift from inherited baseline description to new domain-specific repository truth.

---

## Repository Source of Truth Rule

All documentation must follow one non-negotiable rule:

> The attached ZIP is the only source of truth.

Implications:

- if a previous assumption contradicts the ZIP, the ZIP wins
- documentation must describe real files, real structure, real behavior
- documentation must not invent architecture or flows that do not exist yet

---

## Current Documentation Maturity

At the current repository stage, the documentation is strongest in:

- technical baseline definition
- runtime preservation rules
- architectural constraints
- product boundary definition

It is intentionally less mature in:

- final domain workflows
- offline model
- map interactions
- local persistence implementation

Those areas will be expanded in later phases.

---

## Why cumulative documentation matters

This repository is not a greenfield project; it is a controlled derivative of an already mature application.

Therefore, documentation must be cumulative because:

- inherited technical behavior still exists
- new product meaning is introduced progressively
- abrupt documentation rewrites could hide important constraints
- technical and product truth must stay aligned across phases

---

## Documentation files and expected role

### `README.md`

High-level repository truth:
- what this product is
- what it is not
- current stage
- baseline rules

### `docs/architecture.md`

Deep technical structure:
- runtime ownership
- application layers
- preserved critical components
- architectural constraints

### `docs/flows.md`

Behavioral/runtime flows:
- startup
- config loading
- session restore
- backend connection
- request/response
- UI interaction

### `docs/decisions.md`

Binding project decisions:
- identity
- architecture
- transport
- persistence direction
- navigation expectations
- domain constraints

### `docs/phase0_1_controlled_clone_technical_identity_baseline.md`

Phase-specific explanation of the controlled clone baseline.

---

## Interpretation rule for inherited repository elements

Because the repository originates from Mi IP·RED:

- some code may still reflect the original product surface
- some architecture names may still belong to inherited implementation
- some UI may still be transitional during bootstrap phases

This does **not** mean the repository remains the original product.

It means:

- it reuses a mature technical base
- it has a **different domain**
- it has a **different identity**

Therefore:

- inherited architecture is valid
- inherited product behavior is not authoritative
- documentation must progressively detach from the original product

---

## Bootstrap Context

During Stage 0:

- the repository may still contain inherited UI and flows
- the product surface is not yet aligned with the final domain
- some inconsistencies are expected temporarily

This is acceptable as long as:

- the technical baseline remains stable
- the documentation reflects the real state
- identity separation is correctly enforced

---

## Documentation Evolution Rules

When updating documentation:

- always include full file content (never partial patches)
- always maintain previous context unless explicitly invalidated
- always align with current phase
- always reflect real implementation

Do NOT:

- remove valid previous information
- introduce placeholders
- simplify critical technical details
- break formatting for copy/paste usage

---

## Immediate Documentation Focus (Phase 0.1)

During this phase, documentation must emphasize:

- controlled clone strategy
- identity separation
- cleanup of inherited publication artifacts
- preservation of runtime integrity
- validation of build after identity changes

---

## Next Documentation Steps

After Phase 0.1:

- architecture.md will evolve to reflect domain layering
- flows.md will incorporate field operations flows
- decisions.md will expand with domain constraints
- new phase documents will define functional expansion

---

## Conclusion

This index defines how documentation is structured, maintained, and evolved.

It ensures that:

- documentation remains reliable
- phases remain traceable
- decisions remain explicit
- implementation remains aligned with reality

All contributors must follow this structure strictly to maintain consistency across the project lifecycle.

---

## Phase 0.2.1 documentation update

Phase 0.2.1 adds the first documentation layer that reflects a **functional visible decoupling** from the inherited customer product surface.

This means the documentation set must now explicitly cover:

- the new post-login visible surface
- the new drawer-based navigation entry
- the first two domain sections:
  - Caja PON / ONT
  - Botella de Empalme
- the fact that runtime and backend remain unchanged while the visible entrypoint changes

### New phase document

The dedicated document for this phase is:

    docs/phase0_2_1_domain_skeleton_navigation_entry.md

### Documentation continuity rule

Phase 0.2.1 does not invalidate Phase 0.1.

Instead:

- Phase 0.1 remains the technical baseline phase
- Phase 0.2.1 becomes the first visible domain-entry phase

Both documents must therefore coexist as cumulative project history.

---

## Phase 0.2.2 documentation update

Phase 0.2.2 extends the repository from a visible field-product shell into a domain-aware application.

This means the documentation set explicitly incorporates:

- first real domain entities
- value objects
- sync state enum
- repository contract baseline
- domain-aware presentation instead of placeholder-only rendering

### New phase document

The dedicated document for this phase is:

    docs/phase0_2_2_domain_modeling_and_contracts_baseline.md

### Documentation continuity rule

Phase 0.2.2 does not invalidate the previous phases.

Instead:

- Phase 0.1 remains the technical baseline phase
- Phase 0.2.1 remains the first visible domain-entry phase
- Phase 0.2.2 becomes the first domain-structure phase

All three documents must coexist as cumulative project history.

---

## Phase 0.2.3 documentation update

Phase 0.2.3 adds the first real persistence layer to the repository.

This means the documentation set must now explicitly cover:

- Drift as the local persistence baseline
- local table definitions for Caja PON / ONT and Botella de Empalme
- a concrete repository implementation
- Riverpod providers connected to persistence
- persistence-backed rendering in the Plantel Exterior UI
- the temporary platform limitation where web persistence remains deferred

### New phase document

The dedicated document for this phase is:

    docs/phase0_2_3_local_persistence_baseline.md

### Documentation continuity rule

Phase 0.2.3 does not invalidate any earlier phase.

Instead:

- Phase 0.1 remains the technical controlled-clone baseline
- Phase 0.2.1 remains the visible Plantel Exterior shell phase
- Phase 0.2.2 remains the domain-model baseline
- Phase 0.2.3 becomes the persistence baseline

All of them must be read cumulatively as part of the same bootstrap sequence.

---

## Phase 0.2.4 documentation update

Phase 0.2.4 extends the persistence baseline to Web-compatible execution.

This means the documentation set must now explicitly cover:

- platform-aware database initialization
- web persistence enablement
- WASM-related runtime adjustments
- concurrency control in seed initialization
- the fact that persistence is now expected to behave consistently across Web and Android

### New phase document

The dedicated document for this phase is:

    docs/phase0_2_4_web_persistence_support.md

### Documentation continuity rule

Phase 0.2.4 does not invalidate any earlier phase.

Instead:

- Phase 0.1 remains the technical controlled-clone baseline
- Phase 0.2.1 remains the visible Plantel Exterior shell phase
- Phase 0.2.2 remains the domain-model baseline
- Phase 0.2.3 remains the local persistence baseline
- Phase 0.2.4 becomes the web persistence extension of that baseline

All of them must be read cumulatively as part of the same bootstrap sequence.

---

## Phase 0.3.1 documentation update

Phase 0.3.1 introduces the first real create operations for the outside-plant domain.

This means the documentation set must now explicitly cover:

- creation forms for Caja PON / ONT
- creation forms for Botella de Empalme
- repository-backed insert operations
- provider invalidation after successful creation
- the transition from persistence-backed viewing to real domain creation

### New phase document

The dedicated document for this phase is:

    docs/phase_0_3_1_create.md

### Documentation continuity rule

Phase 0.3.1 does not invalidate any earlier phase.

Instead:

- the technical bootstrap baseline remains valid
- the shell/navigation baseline remains valid
- the domain baseline remains valid
- the persistence baseline remains valid
- Phase 0.3.1 becomes the first operational CRUD phase

All of them must be read cumulatively as part of the same repository history.

---

## Phase 0.3.2 documentation update

Phase 0.3.2 introduces real update operations for the outside-plant domain.

This means the documentation set must now explicitly cover:

- edit-mode reuse of creation forms
- data preloading for existing entities
- persistent update behavior
- timestamp continuity and entity identity preservation

### New phase document

The dedicated document for this phase is:

    docs/phase_0_3_2_update.md

### Documentation continuity rule

Phase 0.3.2 does not invalidate any earlier phase.

Instead:

- all technical and persistence baselines remain valid
- Phase 0.3.1 remains the create baseline
- Phase 0.3.2 becomes the update baseline

Both must coexist as cumulative CRUD history.

---

## Phase 0.3.3 documentation update

Phase 0.3.3 introduces real delete operations for the outside-plant domain.

This means the documentation set must now explicitly cover:

- delete operations in the repository
- confirmation dialogs in UI
- persistent removal of entities
- list refresh after deletion

### New phase document

The dedicated document for this phase is:

    docs/phase_0_3_3_delete.md

### Documentation continuity rule

Phase 0.3.3 does not invalidate any earlier phase.

Instead:

- previous phases remain valid
- Phase 0.3.3 completes the CRUD baseline over local persistence

All of them must be read cumulatively.

---

## Phase 0.3.4 documentation update

Phase 0.3.4 adds the first minimum usability layer on top of the CRUD baseline.

This means the documentation set must now explicitly cover:

- form validation improvements
- better feedback for success/error states
- loading state handling
- improved empty states
- minimum operational UX expectations for local CRUD flows

### New phase document

The dedicated document for this phase is:

    docs/phase_0_3_4_crud_ux.md

### Documentation continuity rule

Phase 0.3.4 does not invalidate any earlier phase.

Instead:

- all prior bootstrap, domain, persistence, and CRUD documents remain valid
- Phase 0.3.4 becomes the minimum UX layer over the local CRUD stack

All of them must be read cumulatively before moving into backend synchronization.



---

## Phase 0.4.1 Additions

The repository now includes the first synchronization foundation for the outside-plant module.

New implementation scope added in this subphase:

- local sync queue persisted in Drift database lifecycle through custom migration SQL
- sync repository contract dedicated to queue persistence and future transport decoupling
- feature sync service responsible for coordinating local CRUD plus queue trace generation
- create/update snapshot capture for Caja PON / ONT and Botella de Empalme
- delete tombstone capture before local removal
- pending queue count provider for future UX and runtime visibility

New phase document:

- `docs/phase_0_4_1_sync_foundations.md`
