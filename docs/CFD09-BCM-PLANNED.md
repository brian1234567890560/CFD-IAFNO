# CFD9 — Planned BCM Mesh Comparison

CFD9 was reserved for a controlled comparison between CFD8's conventional OpenFOAM meshing workflow and a Building-Cube Method (BCM) mesh.

The experiment was intentionally deferred when project time became limited. Reaching the first applied AI/IAFNO prediction pipeline in CFD10 was the more important milestone, and completing BCM first would have blocked that progress. CFD9 is therefore a planned stage, not a failed or missing simulation.

When resumed, CFD8 and CFD9 should use matched geometry, boundary conditions, physical properties, end time, output interval, and convergence criteria. The comparison should report:

- total and local cell counts;
- mesh-generation/preprocessing time;
- solver CPU and wall-clock time;
- peak memory consumption;
- residual and convergence behavior;
- velocity and pressure differences at defined probes/slices;
- particle-trajectory and deposition differences;
- accuracy-versus-computational-cost conclusions.

No BCM benchmark results are claimed in this repository yet.

