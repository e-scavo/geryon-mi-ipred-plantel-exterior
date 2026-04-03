# Documentation Index

This document acts as the central navigation point for all technical and product documentation of the repository.

The documentation set is **cumulative, incremental, and strictly aligned with the real repository state (ZIP as source of truth)**.

---

## Current Stage

- Stage: **Stage 0 — Technical Bootstrap**
- Phase: **Phase 0 — Technical Bootstrap**
- Active subphase: **Phase 0.1 — Controlled Clone & Technical Identity Baseline**

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

## Source of Truth Policy

The only valid source of truth for:

- code
- architecture
- flows
- models
- runtime behavior

is the **real repository (ZIP)**.

Implications:

- documentation must be validated against the ZIP
- assumptions are not allowed if they contradict the code
- inferred behavior must be clearly justified
- historical context must not override real implementation

---

## Relationship with Source Product (Mi IP·RED)

This repository originates from Mi IP·RED, but:

- it is a **new product**
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