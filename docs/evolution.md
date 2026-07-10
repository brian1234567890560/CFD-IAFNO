# CFD–IAFNO Notebook Evolution Review

Status: review draft — no GitHub files have been changed yet.

## 1. Archive inventory

The two archives contain 16 notebook files but only 11 unique notebooks.

| Stage | Notebook | Environment | Role | Disposition |
|---|---|---|---|---|
| CFD1 | `CFD1 fluid velocity.ipynb` | Windows Python | Educational 2D incompressible airflow solver | Preserve |
| CFD2 | `CFD2 fluid humidity.ipynb` | Windows Python | Adds absolute-humidity transport | Preserve |
| CFD3 | `CFD3 fluid temperature.ipynb` | Windows Python | Replaces humidity with temperature transport | Preserve |
| CFD4 | `CFD4 lagrangian particle 1.ipynb` | Windows Python | Adds 2D inertial Lagrangian particles | Preserve |
| CFD5 | `CFD5 lagrangian particle 2.ipynb` | Windows Python | Cleanroom geometry and particle refinements | Preserve |
| CFD6 | `CFD6 lagrangian particle 3D.ipynb` | Windows Python | First full 3D Python prototype | Preserve, mark computational prototype |
| CFD7A | `CFD7 3D+CAD+unmesh.ipynb` | Windows Python | Adds CAD masking and three PyVista animations | Preserve one copy |
| CFD7B | `CFD7_TrackA_OpenFOAM_PythonAnimation.ipynb` | WSL/OpenFOAM | First monolithic OpenFOAM conversion | Preserve as transition branch |
| CFD8 | `CFD8 OpenFoam.ipynb` | WSL/OpenFOAM | Cell-separated OpenFOAM + CAD + particle workflow | Preserve one copy |
| CFD9 | No notebook yet | Deferred BCM/OpenFOAM study | Planned comparison with CFD8; postponed to prioritize the first AI predictor | Publish planning/rationale page only |
| CFD10 | `CFD10 CFD+IAFNO+PINO+particle.ipynb` | WSL/OpenFOAM | U/p export, 3D IAFNO, physics losses and particles | Preserve |
| CFD11 | `CFD11 CFD+IAFNO+PINO+TH.ipynb` | WSL/OpenFOAM | Reintroduces temperature and passive humidity | Preserve as experiment |
| CFD12 | `CFD12 final version.ipynb` | WSL/OpenFOAM | Real DXF Zone 01 + U/p/T/H + IAFNO + particles | Preserve as latest, but mark incomplete |

Reserved/deferred stage: no CFD9 notebook exists yet because CFD9 was intentionally planned as a **Building-Cube Method (BCM) mesh comparison** against CFD8. It was postponed when the available project time became limited: establishing the first AI/IAFNO prediction pipeline was the higher-priority milestone, and continuing to implement BCM first would have blocked that progress. The timeline should label CFD9 “planned BCM comparison — deferred to prioritize AI prediction,” not “missing” or “failed.” The repository must not invent results or a completed notebook.

Exact duplicates:

- Three copies of CFD7A are byte-identical.
- Two copies of CFD7B are byte-identical.
- The Windows Downloads and OpenFOAM copies of CFD8 are byte-identical.

## 2. Evolution summary

1. CFD1 establishes a finite-difference projection solver for 2D incompressible airflow.
2. CFD2 adds an Eulerian scalar equation for absolute humidity.
3. CFD3 changes the scalar equation to temperature/energy transport.
4. CFD4 couples the Eulerian flow to inertial Lagrangian particles with deposition.
5. CFD5 changes the room and cleanroom boundary geometry, lowers inlet speed, and refines particle/obstacle handling.
6. CFD6 extends the entire prototype to 3D, adds a moving warm body, trilinear particle interpolation, and PyVista.
7. CFD7A imports CAD as a voxel-style solid mask but still uses the custom Python CFD solver; it is “unmeshed” in the body-fitted sense.
8. CFD7B is the first conversion path from the Python prototype to actual OpenFOAM, but it is a single 1,206-line setup cell.
9. CFD9 was reserved for a controlled comparison between CFD8’s conventional OpenFOAM meshing workflow and a BCM mesh. The work was deferred because of time constraints so the project could reach its first AI prediction milestone instead of remaining blocked on BCM. When resumed, the comparison should measure cell count, preprocessing/mesh-generation time, solver CPU/wall time, memory, convergence, field error, and particle/flow differences on matched geometry and boundary conditions.
10. CFD10 marks the deliberate pivot to the first applied AI version: it stabilizes the machine-learning pipeline by exporting only U/p, training a 3D IAFNO increment model, applying divergence/solid/Lagrangian losses, rolling out 10×, and tracing particles.
11. CFD11 attempts a more physical OpenFOAM Option B workflow with U/p/T/passive H, then trains an U/p/T IAFNO while intentionally ignoring humidity.
12. CFD12 changes from a sample OBJ/CAD cube to the actual cleanroom DXF and Zone 01 FFU/monitor geometry, then carries the U/p/T → IAFNO → temperature/particle animation pipeline forward.

## 3. Notebook-by-notebook cell explanations

### CFD1 — 2D fluid velocity

| Cell | Explanation |
|---|---|
| 1 | Introduces the educational 2D room-airflow problem and notebook workflow. |
| 2 | Lists/imports required scientific Python packages. |
| 3 | Imports NumPy, Matplotlib, animation/display utilities, and progress support. |
| 4 | Explains geometry, grid, fluid properties, and stability controls. |
| 5 | Defines a 4 m × 2 m room, 321 × 161 grid, simplified density/viscosity, inlet/outlet locations, `dt`, pressure iterations, and snapshot settings. Note: `nt` is later overridden from 900 to 500. |
| 6 | Explains the array convention for `u`, `v`, and `p`. |
| 7 | Allocates flow fields and geometric masks/coordinates. |
| 8 | Documents inlet, outlet, wall, and pressure boundary conditions. |
| 9 | Implements velocity and pressure boundary-condition functions. |
| 10 | Explains the pressure Poisson equation used by the projection method. |
| 11 | Builds the Poisson right-hand side and iteratively solves pressure. |
| 12 | Describes the predictor–pressure-correction algorithm. |
| 13 | Advances one Navier–Stokes step: convection, diffusion, provisional velocity, pressure solution, and velocity correction. |
| 14 | Explains the main simulation and snapshot loop. |
| 15 | Resets fields, overrides `nt=500`, runs the solver with progress, and stores velocity snapshots. |
| 16 | Introduces the final velocity-field check. |
| 17 | Plots speed contours, streamlines/quiver-style flow information, inlet/outlet, and the circular obstacle. |
| 18 | Explains the notebook animation. |
| 19 | Builds the Matplotlib velocity animation and update callback. |
| 20 | Introduces optional GIF export. |
| 21 | Saves the animation to the preferred cleanroom animation folder. |
| 22 | Empty trailing cell. |

### CFD2 — 2D humidity transport

| Cell | Explanation |
|---|---|
| 1 | Defines the coupled airflow + absolute-humidity learning objective. |
| 2–3 | Imports NumPy, Matplotlib, animation, path, display, and progress packages. |
| 4–5 | Defines a 4 m × 2 m, 161 × 81 model, 2 m/s inlet, circular aluminum obstacle, humidity diffusivity/values, `dt=0.005`, and `nt=1800`. |
| 6–7 | Allocates U/v/p/H fields and constructs inlet, outlet, and obstacle masks. |
| 8–9 | Implements velocity, pressure, and absolute-humidity boundary conditions, including no flow through the solid. |
| 10–11 | Builds and solves the pressure Poisson system. |
| 12–13 | Performs one incompressible velocity-pressure projection step. |
| 14–15 | Implements Eulerian advection–diffusion of absolute humidity after the velocity update. |
| 16–17 | Runs the coupled flow/humidity loop and stores snapshots. |
| 18–19 | Plots final humidity in g/m³ with physical geometry. |
| 20–21 | Animates the evolving humidity field. |
| 22–23 | Saves the humidity GIF to the preferred Windows folder. |
| 24 | Empty trailing cell. |

### CFD3 — 2D temperature transport

| Cell | Explanation |
|---|---|
| 1 | Reframes the scalar transport problem as airflow + temperature. |
| 2–3 | Imports numerical, plotting, animation, path, and progress tools. |
| 4–5 | Defines geometry and thermophysical inputs, including `alpha=k/(rho*cp)`, inlet/initial/wall/solid temperatures, time step, and run length. |
| 6–7 | Allocates flow and temperature arrays and geometry masks. |
| 8–9 | Implements velocity, pressure, and thermal boundary conditions. |
| 10–11 | Constructs and solves the incompressibility pressure equation. |
| 12–13 | Advances the incompressible flow solution. |
| 14–15 | Derives and implements the temperature advection–diffusion energy equation. |
| 16–17 | Runs the coupled flow/temperature calculation and records snapshots. |
| 18–19 | Plots final temperature in °C. |
| 20–21 | Animates the temperature field. |
| 22–23 | Saves the temperature GIF. |
| 24 | Empty trailing cell. |

### CFD4 — first 2D Lagrangian particle model

| Cell | Explanation |
|---|---|
| 1–13 | Retains the CFD3 airflow and temperature solver, geometry, pressure projection, and boundary conditions. |
| 14 | Documents the temperature equation. |
| 15 | Introduces inertial Lagrangian particle motion, Stokes response time, drag relaxation, left-to-right gravity, deposition, and particle-size distribution. |
| 16 | Implements the temperature step. |
| 17 | Interpolates Eulerian velocity to particle positions; releases particles; advances particle velocity/position; detects walls, outlet, and circular-obstacle contact; and updates particle state. |
| 18–19 | Runs airflow, temperature, particle release, deposition, and snapshot storage together. |
| 20–21 | Plots final temperature plus active/deposited/escaped particle states. |
| 22–23 | Creates the temperature + particle animation with progress reporting. |
| 24–25 | Saves the GIF with a frame-progress callback. |
| 26 | Empty trailing cell. |

### CFD5 — refined 2D cleanroom particle model

| Cell | Explanation |
|---|---|
| 1–4 | Retains the CFD4 educational structure. |
| 5 | Changes the model to a 4 m × 4 m room, 0.45 m/s inlet, `dt=0.007`, and `nt=2700`; introduces updated cleanroom geometry. |
| 6–7 | Allocates fields and replaces the circular-only layout with two rectangular obstacles/outlet geometry. |
| 8–16 | Reuses the pressure-projection and temperature advection–diffusion solver with the revised masks and boundaries. |
| 17 | Refines particle interpolation, release, obstacle collision, deposition, and state tracking for the rectangular layout. |
| 18–19 | Runs the revised coupled model. |
| 20–21 | Draws the final temperature and particle state with rectangular obstacles. |
| 22–23 | Animates the new cleanroom layout and particles. |
| 24–25 | Saves the GIF with progress. |
| 26 | Empty trailing cell. |

### CFD6 — first 3D Python prototype

| Cell | Explanation |
|---|---|
| 1 | Introduces a 4 m cubic cleanroom, 3D airflow, temperature, and particles. |
| 2–3 | Imports NumPy, PyVista, Matplotlib, paths, timing, and progress tools. |
| 4–5 | Defines the 41³ grid, fluid/thermal constants, inlet/outlet, two lower obstacles, a moving warm body, particle sizes, adaptive time step, and run controls. Multiple later `nt` assignments make the effective run length cell-order dependent. |
| 6 | Empty spacer cell. |
| 7–8 | Allocates 3D U/v/w/p/T fields and fixed/moving solid masks. |
| 9–10 | Implements 3D velocity, pressure, and temperature boundary conditions plus neighbor averaging inside solids. |
| 11–12 | Builds the 3D pressure RHS and solves the Poisson equation with Gauss–Seidel iterations. |
| 13–14 | Implements a 3D predictor/projection velocity-pressure step. |
| 15–16 | Implements 3D temperature advection–diffusion with warm-body treatment. |
| 17–18 | Implements particle response time, trilinear velocity interpolation, release, fixed/moving-solid contact, deposition, gravity/drag motion, and release from the moving body when it leaves. |
| 19–20 | Runs the coupled 3D simulation, estimates a particle no-motion stopping condition, reports progress/ETA, and stores snapshots. |
| 21–22 | Creates reusable PyVista geometry for the room, inlet, outlet, obstacles, moving body, and particle points. |
| 23–24 | Saves the 3D particle/boundary animation. |
| 25–26 | Saves the 3D temperature/boundary animation. |
| 27 | Empty trailing cell. |

### CFD7A — 3D Python + CAD mask

| Cell | Explanation |
|---|---|
| 1–4 | Retains the CFD6 3D solver introduction and setup. |
| 5 | Adds the Windows `tinker.obj` path, CAD scale/crop controls, animation folder, and CAD visualization/masking settings. |
| 6 | Empty spacer cell. |
| 7–8 | Loads and scales CAD, selects/crops a 4 m region, maps it into the simulation domain, voxelizes it into a Cartesian solid mask, and clears inlet/outlet cells. This is immersed/voxel masking, not a body-fitted mesh. |
| 9–20 | Reuses the custom 3D pressure-projection, temperature, moving-body, particle, and simulation logic with the CAD mask added to solid collision/BC handling. |
| 21–22 | Builds PyVista room and CAD visualization helpers. |
| 23–24 | Saves the particle + transparent-CAD animation. |
| 25–26 | Saves a temperature animation oriented along x with CAD overlay. |
| 27 | Adds a fixed y–z temperature-slice animation. |
| 28 | Empty trailing cell. |

### CFD7B — Track A monolithic OpenFOAM conversion

| Cell | Explanation |
|---|---|
| 1 | States that the notebook must run inside Ubuntu 22.04 with OpenFOAM. |
| 2 | One 1,206-line setup cell containing imports, geometry/CAD preparation, OpenFOAM dictionary generation, solver execution, VTK conversion, reading calculated fields, and PyVista GIF generation. It proves the end-to-end path but is difficult to debug or maintain. |
| 3 | Calls `main()` to execute the complete workflow. |

### CFD8 — structured OpenFOAM workflow

| Cell | Explanation |
|---|---|
| 1 | Introduces actual OpenFOAM U/p calculation with Python visualization. The title mentions T, but the stable core is U/p. |
| 2 | Imports Python, PyVista/Trimesh, plotting, subprocess, path, and progress dependencies. |
| 3–5 | Defines folders, case path, mesh/output settings, CAD path, and the `USE_SNAPPY_CAD_OBSTACLE` switch. |
| 6–7 | Converts Windows paths to WSL paths, loads/scales CAD, and auto-fits the room. |
| 8–9 | Defines inlet/outlet rectangles and particle settings. |
| 10–11 | Builds mesh planes and writes `blockMeshDict` with exact cell allocation around boundaries. |
| 12–13 | Writes OpenFOAM initial fields for velocity and pressure and optional CAD wall patches. |
| 14–16 | Writes transport properties, exports CAD STL, and checks required OpenFOAM v13 files. |
| 17–19 | Writes `controlDict`, numerical schemes/solution settings, and a v13-compatible `snappyHexMeshDict`. |
| 20–21 | Builds/runs the OpenFOAM case, cleans old time folders, executes commands with logs/progress, optionally meshes CAD, runs `icoFoam`, and converts results to VTK. |
| 22–23 | Provides WSL helper commands and path conversion. |
| 24–25 | Reads actual OpenFOAM vector/scalar internal fields and finds the latest calculated time. |
| 26–28 | Adds auto-scaling, animation progress, and a velocity-slice plot. |
| 29–30 | Builds a humidity y–z visualization path. This is not equivalent to a fully coupled OpenFOAM humidity transport solve in this notebook. |
| 31–32 | Draws geometry and traces particles through the calculated velocity field, with segment–triangle CAD collision checks and GIF output. |
| 33 | Empty trailing cell. |

### CFD10 — U/p OpenFOAM export + 3D IAFNO + particles

| Cell | Explanation |
|---|---|
| 1–20 | Refines the CFD8 OpenFOAM case but intentionally writes/solves only U and p to remove unstable temperature/humidity paths. |
| 21–22 | Reads OpenFOAM time folders and exports U, p, cell centers, regular-grid coordinates, masks, and metadata to a safe 3D `.npz`. |
| 23 | Imports PyTorch and configures IAFNO paths/device. |
| 24 | Loads and validates U/p arrays and masks. |
| 25 | Builds sliding windows: five previous field states are input and the next-state increment is the target. |
| 26 | Defines the 3D AFNO spectral mixer, implicit update block, and IAFNO model. |
| 27 | Defines normalized data loss plus divergence, zero-solid-velocity, and Lagrangian particle-energy losses; includes interpolation and adaptive loss-weight balancing. |
| 28 | Trains the U/p IAFNO with progress, ETA, validation/checkpoint logic, and loss histories. |
| 29 | Autoregressively rolls the trained model out to ten times the CFD horizon. |
| 30 | Loads rollout arrays and prepares 3D animation helpers. |
| 31 | Seeds and integrates 3D particles using rollout velocity. |
| 32 | Saves the trained-model particle animation. |
| 33 | Empty trailing cell. |

### CFD11 — Option B U/p/T/H and U/p/T IAFNO

| Cell | Explanation |
|---|---|
| 1–4 | Retains the structured CAD/OpenFOAM setup. |
| 5 | Adds coupled temperature and passive-humidity settings for the Option B `foamRun` workflow. |
| 6–13 | Retains CAD loading, room fitting, inlet/outlet setup, and block mesh generation. |
| 14 | Writes U, p, T, and H fields for the Option B solver. |
| 15–18 | Writes thermal/transport constants and OpenFOAM system dictionaries for `foamRun fluid`. |
| 19 | Writes the snappyHexMesh configuration. |
| 20–22 | Enables CAD meshing and runs the Option B CFD workflow with extensive solver detection, logging, checks, and retry support. |
| 23 | Diagnoses snappyHexMesh/CAD failures using bounds, candidate interior points, and log excerpts. |
| 24–25 | Exports OpenFOAM U/p/T/H to a regular 3D `.npz`. |
| 26 | Checks vertical-flow direction before ML training. |
| 27 | Imports/configures the IAFNO stage. |
| 28 | Loads U/p/T/H but intentionally ignores H for training because humidity was not yet trusted. |
| 29 | Builds the U/p/T sliding-window increment dataset. |
| 30 | Defines the U/p/T IAFNO and spectral blocks. |
| 31 | Trains a faster stable U/p/T configuration with data/divergence/solid constraints. The numbering skips “IAFNO Cell 5,” showing this is an edited experiment. |
| 32–33 | Rolls out the model and verifies the saved rollout file. |
| 34–35 | Loads rollout temperature and saves a temperature-only x–z slice animation. |
| 36 | Empty trailing cell. |

### CFD12 — DXF Zone 01 final branch

| Cell | Explanation |
|---|---|
| 1 | Defines Linux/Windows paths, Zone 01 dimensions, OpenFOAM/ML settings, and main output locations. |
| 2 | Imports DXF, installs/uses geometry dependencies, filters layers, repairs/extrudes 2D entities into 3D solids, combines geometry, and writes a cleaned STL. At 902 lines, this should later be split into a module. |
| 3 | Defines Option B temperature/humidity constants. |
| 4 | Parses DXF entities/text, identifies Zone 01, converts DXF coordinates to metres, and extracts FFU/monitor regions. |
| 5 | Writes the Zone 01 `blockMeshDict`. |
| 6 | Writes U, p, T, and H fields, including coded FFU boundary conditions. |
| 7 | Writes OpenFOAM constant/physical-property files. |
| 8 | Writes control, discretization, solver, and decomposition files. |
| 9 | Writes snappyHexMesh settings, selects an interior point, runs mesh checks and `foamRun`, and logs progress/errors. |
| 10 | Reads calculated U/p/T/H fields, maps them to a regular 3D grid, creates a CAD mask, and exports `.npz`. |
| 11 | Checks vertical velocity direction and statistics before training. |
| 12 | Loads and normalizes U/p/T while excluding H from IAFNO training. |
| 13 | Builds the five-state input / next-increment U/p/T dataset. |
| 14 | Defines the 3D spectral filter, implicit AFNO block, and IAFNO model. |
| 15 | Trains the model with data and physical solid-velocity constraints plus validation/checkpointing. |
| 16 | Produces autoregressive U/p/T rollout data. |
| 17 | Diagnoses temperature spreading and velocity curl/side motion. |
| 18–19 | Loads rollout temperature and saves an x–z temperature animation. |
| 20 | Traces Lagrangian particles through the IAFNO velocity rollout with CAD/domain checks and configurable particle physics. |
| 21 | Draws room/CAD/particle states and saves the particle GIF. |
| 22 | Contains raw English text (`and add BC loss and IC loss every 10 batches`) rather than valid Python. It proves BC/IC loss was requested but not implemented in this saved notebook. |

## 4. Scientific and engineering cautions

- CFD1–CFD7A are educational/custom finite-difference prototypes, not OpenFOAM results.
- CFD7A CAD is converted to a Cartesian mask; calling it “unmeshed” is acceptable only if the documentation explains that the grid still exists and the CAD is not body-fitted.
- Repeated `nt` assignments in CFD1, CFD6, and CFD7A make results depend on execution order.
- CFD8’s humidity animation should not be described as an OpenFOAM-coupled humidity solution.
- CFD10 includes “PINO” ideas through physics-informed loss terms, but its core architecture is IAFNO; the repository should avoid claiming a separate full PINO solver unless clearly qualified.
- CFD11/CFD12 export H but train on U/p/T only. The timeline must say humidity was intentionally excluded from IAFNO training.
- CFD12 is not fully final: BC/IC loss is absent, the last cell is invalid Python, and the notebook contains very large cells that need modularization.
- No notebook alone proves mesh independence, numerical convergence, experimental validation, or production-grade CFD accuracy. These should be listed as future validation work.

## 5. Proposed GitHub repository structure

```text
CFD-IAFNO/
├── README.md
├── index.html
├── style.css
├── docs/
│   ├── evolution.md
│   ├── numerical-methods.md
│   ├── openfoam-workflow.md
│   ├── bcm-comparison-plan.md
│   ├── iafno-method.md
│   ├── validation-and-limitations.md
│   └── notebooks/
│       ├── CFD01.md ... CFD12.md
├── notebooks/
│   ├── python-prototypes/
│   │   ├── CFD01-fluid-velocity.ipynb
│   │   ├── CFD02-fluid-humidity.ipynb
│   │   ├── CFD03-fluid-temperature.ipynb
│   │   ├── CFD04-lagrangian-particles-v1.ipynb
│   │   ├── CFD05-lagrangian-particles-v2.ipynb
│   │   ├── CFD06-lagrangian-particles-3d.ipynb
│   │   └── CFD07a-cad-mask.ipynb
│   └── openfoam-iafno/
│       ├── CFD07b-openfoam-track-a.ipynb
│       ├── CFD08-openfoam.ipynb
│       ├── CFD09-BCM-PLANNED.md
│       ├── CFD10-iafno-particles.ipynb
│       ├── CFD11-iafno-temperature.ipynb
│       └── CFD12-zone01-final-branch.ipynb
├── code/
│   ├── openfoam_export_pipeline.py
│   ├── iafno_model.py
│   ├── particle_lagrangian_loss.py
│   ├── particle_tracing.py
│   └── train_iafno.py
└── environment/
    ├── windows-requirements.txt
    ├── openfoam-requirements.txt
    └── start-openfoam-jupyter.sh
```

The original notebook bytes should be preserved. Renamed copies may be used for navigation, while an `ORIGINAL_FILENAMES.md` manifest records every source name, archive, duplicate, SHA-256 hash, and canonical destination.

## 6. Proposed GitHub Pages presentation

The page should contain:

1. Project objective: cleanroom airflow, temperature/humidity, and particle transport.
2. A numbered evolution timeline showing CFD9 as a planned BCM-versus-conventional-mesh comparison that was deferred to prioritize the first AI prediction pipeline.
3. “Python prototype” versus “OpenFOAM-calculated” badges to prevent scientific ambiguity.
4. Equations for incompressible Navier–Stokes, scalar advection–diffusion, particle drag/response, AFNO/IAFNO updates, relative L2 data loss, divergence loss, solid loss, and Lagrangian loss.
5. A per-notebook cell guide linking to each notebook.
6. Environment instructions for Windows Python and Ubuntu 22.04/OpenFOAM 13.
7. A limitations/validation section rather than presenting every animation as validated CFD.
8. A “current state” panel identifying CFD12 as the latest branch and listing unfinished BC/IC-loss work.

### Recovered animation assets

Six generated GIFs were embedded in notebook outputs and have been recovered for the GitHub site:

| Stage | GitHub asset | Content | Resolution |
|---|---|---|---|
| CFD8 | `assets/gifs/CFD08-humidity-yz-slice.gif` | Humidity y–z slice visualization | 600×500 |
| CFD8 | `assets/gifs/CFD08-openfoam-particles-cad-collision.gif` | OpenFOAM particle tracing with CAD collision | 800×700 |
| CFD10 | `assets/gifs/CFD10-iafno-particles-10x.gif` | IAFNO 10× rollout particle animation | 800×700 |
| CFD11 | `assets/gifs/CFD11-iafno-temperature-UPT-xz.gif` | U/p/T IAFNO x–z temperature animation | 800×500 |
| CFD12 | `assets/gifs/CFD12-zone01-temperature-UPT-xz.gif` | Zone 01 IAFNO x–z temperature animation | 800×500 |
| CFD12 | `assets/gifs/CFD12-zone01-particles-UPT.gif` | Zone 01 IAFNO Lagrangian particle animation | 800×600 |

The GitHub page should lazy-load these animations and show a static poster/preview before playback because the CFD8 particle GIF is approximately 31 MB.

The standalone GIF files for CFD1–CFD7A were not embedded in the notebook archives. Their code references the following outputs, which can be added later if collected from `C:\Users\brian\OneDrive\桌面\ASE\cleanroom\animation`:

- `educational_2d_cfd_velocity_16080.gif`
- `educational_2d_cfd_humidity_16080.gif`
- `educational_2d_cfd_temperature_16080.gif`
- `educational_2d_cfd_L particles1_16080.gif` (referenced by both CFD4 and CFD5, so one may have overwritten the other)
- `3d_particles_boundary_only.gif`
- `3d_temperature_boundary_only.gif`
- `3d_particles_CAD.gif`
- `3d_temperature_CAD_along_x.gif`
- `3d_temperature_CAD_along_y.gif`

## 7. Recommended publication decision

Publish all 11 unique notebooks, not all 16 archive copies. Preserve duplicate provenance in the manifest. Add a CFD9 planning/rationale page explaining that BCM was deferred because delivering the first IAFNO prediction pipeline was more important under the available time constraint. Do not create a fake notebook or claim BCM benchmark results before the experiment is run. Do not silently repair CFD12 before the historical version is committed; first commit the notebook exactly as received, then create a separate corrected branch/version for BC/IC-loss implementation and cell modularization.
