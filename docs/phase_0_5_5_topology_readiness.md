# Phase 0.5.5 — Topology Readiness

Objective
- Introduce a derived local topological reading layer over existing outside plant relationships without changing persistence.

Scope
- Derived topology summary model.
- Riverpod provider that computes immediate neighbors and grouped relationship counts.
- Reusable topology summary section integrated into the inspection dialog.
- Contextual navigation between directly connected entities.

Implementation Notes
- No new tables or sync contracts were introduced.
- The summary is built from current cajas, botellas and relationship entities already consolidated in 0.5.2.x and 0.5.4.
- Navigation remains modal-based to preserve the current runtime and route structure.

Delivered
- outside_plant_topology_summary.dart
- outsidePlantTopologySummaryProvider
- outside_plant_topology_summary_section.dart
- Integration into outside_plant_detail_dialog.dart

Out of Scope
- Graph rendering
- Map/GIS visualization
- Multi-hop traversal
- Physical path inference
- Backend topology contracts
