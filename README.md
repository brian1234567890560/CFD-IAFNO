# CFD + IAFNO Cleanroom Airflow Simulation

This repository develops a research prototype for cleanroom airflow simulation using computational fluid dynamics, neural-operator prediction, and Lagrangian particle tracing. The project combines OpenFOAM-generated velocity fields with an IAFNO-based surrogate model to study whether learned airflow predictions can approximate CFD-based particle motion with improved computational efficiency.

## Project Objective

The objective is to build a fast surrogate workflow for cleanroom airflow prediction. OpenFOAM is used to generate physically grounded CFD velocity fields, while the IAFNO model learns to predict future three-dimensional velocity fields from prior CFD data. Predicted velocity fields are then used for Lagrangian particle tracing and compared against CFD-based particle motion.

## Methodology

1. Generate cleanroom CFD data with OpenFOAM.
2. Export the velocity field `U` from the CFD simulation.
3. Train an IAFNO model on 3D velocity-field data.
4. Predict future airflow fields from previous CFD states.
5. Trace Lagrangian particles through the predicted field.
6. Add particle-energy and smoothness losses to improve motion stability.
7. Visualize airflow behavior, particle trajectories, and CAD obstacles.

## Mathematical Formulation

Eulerian velocity field:

```math
\mathbf{u}(x,y,z,t) = (u,v,w)
```

Lagrangian particle motion:

```math
\frac{d\mathbf{x}_p}{dt} = \mathbf{u}(\mathbf{x}_p,t)
```

Total training loss:

```math
\mathcal{L}_{total}
=
\mathcal{L}_{field}
+
\lambda_E \mathcal{L}_{energy}
+
\lambda_s \mathcal{L}_{smooth}
```

## Current Configuration

- Simulation target: velocity field prediction
- Removed variables: temperature and humidity
- Target 3D resolution: `42 x 42 x 42`
- Target particle count: `50`
- CFD solver: OpenFOAM
- Neural model: IAFNO
- Particle method: Lagrangian tracing

## Known Technical Challenges

- Memory usage increases rapidly at higher 3D resolutions and can crash the kernel.
- Particles may disappear when boundary conditions are not handled correctly.
- Particles may pass through obstacles without explicit collision handling.
- Particle instability can result from noisy interpolation or unstable velocity prediction.

## Final Direction

The intended final system will compare OpenFOAM-based particle trajectories with IAFNO-predicted particle trajectories. The long-term goal is to improve surrogate-model stability through physically informed losses while preserving meaningful airflow and particle-motion behavior.
