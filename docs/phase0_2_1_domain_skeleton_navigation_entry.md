# Phase 0.2.1 — Domain Skeleton & Navigation Entry

---

## Objective

Create the first real visible product surface for **Mi IP·RED Plantel Exterior** after login, replacing the inherited customer dashboard as the main entrypoint and establishing a clean, scalable, low-risk navigation shell for the outside-plant domain.

This phase must:

- preserve the proven runtime baseline established in Phase 0.1
- avoid deep architectural redesign
- introduce a visible product surface aligned with the new field domain
- make both initial domain entities present from the start:
  - Caja PON / ONT
  - Botella de Empalme

---

## Initial Context

After Phase 0.1, the repository already had a controlled technical identity:

- repository identity normalized
- runtime preserved
- backend preserved
- login preserved
- session preserved
- build validation completed

However, the visible post-login surface still corresponded to the inherited customer-oriented product.

That meant the repository was technically separated, but not yet functionally recognizable as a field operations product.

The missing piece was the first visible domain shell.

---

## Problem Statement

The repository had a mismatch between:

- technical identity
- documented product goal
- visible application entry after login

More specifically:

- the runtime was already aligned with Mi IP·RED Plantel Exterior
- the documentation already established a new product boundary
- but the visible post-login surface still led into inherited customer screens

Without correcting that, the product would remain visually anchored to the wrong domain, increasing confusion and delaying clean domain evolution.

---

## Scope

### Included in this phase

- introduction of a new visible post-login surface for Plantel Exterior
- creation of a main home screen for the new product shell
- creation of a scalable navigation entry using a drawer
- creation of real skeleton screens for:
  - Caja PON / ONT
  - Botella de Empalme
- preservation of runtime, backend, login, and session behavior
- controlled modification of the visible entrypoint in `lib/main.dart`

### Explicitly excluded

- full CRUD
- local persistence implementation
- offline engine
- synchronization flows
- map integration
- camera integration
- deep runtime refactor
- transport refactor
- global router redesign
- aggressive deletion of inherited modules

---

## Root Cause Analysis

The root cause was not a backend or runtime defect.

The root cause was a **surface ownership problem**:

- the repository had already become a new product at the technical level
- but the visible entrypoint still belonged to the inherited customer product surface

Why this happened:

1. Phase 0.1 was intentionally conservative and stopped at technical normalization
2. the inherited dashboard remained the easiest stable visible landing point
3. no dedicated Plantel Exterior entry shell existed yet
4. navigation for future domain growth had not been introduced

As a result, the system still looked like the old product immediately after login.

---

## Files Affected

### Existing file modified

- `lib/main.dart`

### New files added

- `lib/features/plantel_exterior/presentation/providers/plantel_navigation_provider.dart`
- `lib/features/plantel_exterior/presentation/widgets/plantel_exterior_drawer.dart`
- `lib/features/plantel_exterior/presentation/screens/plantel_exterior_home_screen.dart`
- `lib/features/plantel_exterior/presentation/screens/plantel_exterior_home_view.dart`
- `lib/features/plantel_exterior/presentation/screens/cajas_pon_ont_screen.dart`
- `lib/features/plantel_exterior/presentation/screens/botellas_empalme_screen.dart`

### Documentation files updated

- `README.md`
- `docs/index.md`
- `docs/architecture.md`
- `docs/flows.md`
- `docs/decisions.md`
- `docs/phase0_2_1_domain_skeleton_navigation_entry.md`

---

## Implementation Characteristics

### 1. Low-risk implementation

The implementation is intentionally narrow:

- one visible entrypoint change
- one new presentation feature shell
- one local navigation provider
- no runtime redesign

### 2. Runtime preservation first

The implementation preserves:

- ServiceProvider ownership
- notifierServiceProvider integration
- bootstrap/loading sequence
- backend connectivity
- login/session continuity
- logout ownership flow

### 3. Feature encapsulation

The new product surface is encapsulated under:

    lib/features/plantel_exterior/

This keeps the change localized and makes future domain growth cleaner.

### 4. Simple navigation baseline

Navigation is implemented with a drawer and a local provider-based section switch.

This is sufficient for the phase because:

- it is scalable enough for upcoming sections
- it avoids unnecessary routing complexity
- it keeps behavior easy to validate

### 5. Real visible domain presence

Both initial domain entities now exist as real navigable screens, even though still skeleton-based.

This is important because the repository no longer treats the domain as hypothetical.

---

## Detailed Implementation Summary

### Step 1 — New post-login visible shell

A new `PlantelExteriorHomeScreen` is introduced to become the visible main screen after startup/session continuity.

### Step 2 — Local navigation provider

A provider-based navigation model is introduced to control the active section of the new shell.

This includes:

- an enum of visible sections
- a local Riverpod state provider

### Step 3 — Drawer navigation

A drawer is introduced with the following visible entries:

- Inicio
- Cajas PON / ONT
- Botellas de Empalme
- Cerrar sesión

### Step 4 — Product-specific home view

A dedicated home view is introduced to make the application immediately recognizable as Mi IP·RED Plantel Exterior after login.

### Step 5 — Domain skeleton sections

The following screens are added:

- `CajasPonOntScreen`
- `BotellasEmpalmeScreen`

Both are integrated in the visible shell and navigation flow.

### Step 6 — Entry point replacement in main.dart

The inherited visible post-login surface is replaced so that the app now resolves into the new Plantel Exterior shell instead of the customer dashboard.

---

## Validation

### Functional validation expected

After startup and successful login/session continuity:

- the application must no longer display the inherited customer dashboard as the primary surface
- the application must display a Plantel Exterior main shell
- the drawer must open correctly
- the user must be able to navigate between:
  - Inicio
  - Cajas PON / ONT
  - Botellas de Empalme
- logout must remain operational

### Technical validation expected

The following must remain intact:

- startup sequence
- backend connection
- login continuity
- session continuity
- Web compatibility
- Android compatibility

### Visual validation expected

The product must now look like a new operational field application at the first visible level, even though underlying inherited modules may still exist internally.

---

## Release Impact

### Positive impact

- the repository gains a real visible product shell
- the customer-facing inherited surface stops being the main visible identity
- the new domain becomes present in the live UI
- future domain work now has a proper visible anchor point

### Controlled impact

- backend unchanged
- runtime unchanged
- login/session unchanged
- transport unchanged

### Deferred impact

The phase intentionally defers:

- CRUD
- persistence
- offline states
- map and advanced workflows

---

## Risks

### 1. Transitional coexistence risk

Inherited modules still coexist with the new visible shell.  
This is acceptable now, but future phases must continue replacing those surfaces progressively.

### 2. Navigation growth risk

The drawer-based local provider model is appropriate now, but future phases may require a broader navigation strategy if the product surface expands significantly.

### 3. Skeleton perception risk

Because domain sections are still skeleton-based, the visible product identity improves faster than operational depth.  
This is acceptable for the phase but should not remain static for too long.

---

## What it does NOT solve

This phase does **not** solve:

- entity CRUD
- local database integration
- offline persistence
- synchronization
- map UI
- camera/media evidence
- field workflow orchestration
- advanced search/filtering
- relation modeling between outside-plant assets

All of those belong to later phases.

---

## Conclusion

Phase 0.2.1 is the first phase where Mi IP·RED Plantel Exterior becomes visibly recognizable as its own product after login.

It does so by introducing:

- a new post-login home shell
- a scalable navigation entry
- visible presence of both initial domain entities

At the same time, it preserves the most critical technical baseline inherited from Mi IP·RED:

- runtime stability
- backend compatibility
- session continuity
- multiplatform compatibility

This makes Phase 0.2.1 a small but strategically decisive transition from a technically cloned repository into a visibly independent outside-plant operations product.