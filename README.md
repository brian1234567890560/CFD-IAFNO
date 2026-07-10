# CFD + IAFNO Cleanroom Airflow Simulation

This repository records the development of Brian Hsieh's cleanroom airflow project from educational Python CFD prototypes to OpenFOAM simulations, 3D IAFNO surrogate prediction, and Lagrangian particle tracing.

The repository preserves the numbered notebook history because each stage answers a different engineering question. It also distinguishes custom Python simulations from actual OpenFOAM-calculated fields so the animations are not presented as equivalent levels of CFD validation.

## Development timeline

| Stage | Main development | Status |
|---|---|---|
| CFD1 | 2D incompressible velocity solver | Python prototype |
| CFD2 | Absolute-humidity advection–diffusion | Python prototype |
| CFD3 | Temperature/energy transport | Python prototype |
| CFD4 | First inertial Lagrangian particles | Python prototype |
| CFD5 | Revised cleanroom geometry and particle collisions | Python prototype |
| CFD6 | 3D flow, temperature, moving body, and particles | Python prototype |
| CFD7A | CAD converted to a Cartesian obstacle mask | Python prototype |
| CFD7B | First monolithic Python-to-OpenFOAM Track A workflow | OpenFOAM transition |
| CFD8 | Structured OpenFOAM case, CAD meshing, visualization, and particles | OpenFOAM baseline |
| CFD9 | Planned BCM mesh comparison against CFD8 | Deferred to prioritize AI prediction |
| CFD10 | U/p export, 3D IAFNO, physics losses, 10× rollout, and particles | First AI application |
| CFD11 | OpenFOAM U/p/T/passive-H and U/p/T IAFNO | Experimental extension |
| CFD12 | Real DXF Zone 01 geometry, FFU conditions, IAFNO, and particles | Latest development branch |

CFD9 was intentionally postponed when project time became limited. Delivering the first applied IAFNO prediction pipeline was more important than allowing BCM implementation to block further progress. The planned comparison remains documented for future work.

## Repository contents

- [`notebooks/python-prototypes`](notebooks/python-prototypes) — CFD1 through CFD7A.
- [`notebooks/openfoam-iafno`](notebooks/openfoam-iafno) — CFD7B, CFD8, CFD10, CFD11, and CFD12.
- [`assets/gifs`](assets/gifs) — six animations recovered from notebook outputs.
- [`docs/evolution.md`](docs/evolution.md) — complete archive inventory, duplicate analysis, scientific cautions, and cell-by-cell explanation.
- [`docs/mathematics.md`](docs/mathematics.md) — LaTeX explanation of the CFD equations, discretization, OpenFOAM structure, particle mechanics, AFNO/IAFNO, rollout, and training losses.
- [`docs/animations.md`](docs/animations.md) — dedicated gallery for the recovered CFD and IAFNO GIFs.
- [`code`](code) — smaller reusable examples for OpenFOAM export, IAFNO, losses, training, and particle tracing.
- [`index.html`](index.html) — GitHub Pages project presentation.

The two archives contained 16 notebook files but only 11 unique notebooks. Identical CFD7/CFD8 copies were removed while their provenance is recorded in the evolution report.

## Core workflow

1. Define cleanroom geometry, inlets, outlets, CAD obstacles, and physical boundary conditions.
2. Solve airflow using the educational finite-difference prototypes or OpenFOAM.
3. Export calculated fields to a regular 3D NumPy grid.
4. Train IAFNO on five previous field states to predict the next-state increment.
5. Roll the learned model forward beyond the CFD training horizon.
6. Trace Lagrangian particles through CFD or predicted velocity fields.
7. Visualize temperature, humidity, CAD collision, and particle transport.

## Detailed references

- Read [Mathematics and Model Structure](docs/mathematics.md) for the complete rendered-LaTeX formulation.
- Open the [Animation Gallery](docs/animations.md) for all recovered CFD and IAFNO GIFs.

## Environment distinction

The early notebooks run in the Windows Python/Jupyter environment. The OpenFOAM notebooks run inside Ubuntu 22.04 under WSL with OpenFOAM 13 activated:

```bash
wsl -d Ubuntu-22.04
source /opt/openfoam13/etc/bashrc
source ~/cleanroom-venv/bin/activate
cd ~/openfoam_notebooks
python -m notebook --notebook-dir="$HOME/openfoam_notebooks"
```

## Important limitations

- CFD1–CFD7A are educational custom solvers, not OpenFOAM results.
- CFD7A uses a Cartesian CAD mask rather than a body-fitted mesh.
- CFD8 humidity visualization is not a fully coupled OpenFOAM humidity solve.
- CFD11 and CFD12 export humidity, but the saved IAFNO training uses U/p/T only.
- CFD12 ends with a request to add BC and IC losses; those losses are not implemented in the saved notebook.
- Mesh independence, experimental validation, and controlled CFD-versus-IAFNO error benchmarks remain future work.

## Current direction

CFD12 is the latest development branch, not a claim of a fully validated final solver. The next major tasks are BC/IC-loss implementation, modularizing the large DXF/OpenFOAM cells, quantitative CFD-versus-IAFNO validation, and eventually returning to the deferred CFD8-versus-BCM comparison.
