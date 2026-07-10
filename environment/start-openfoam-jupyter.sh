#!/usr/bin/env bash
set -euo pipefail

source /opt/openfoam13/etc/bashrc
source "$HOME/cleanroom-venv/bin/activate"
cd "$HOME/openfoam_notebooks"
python -m notebook --notebook-dir="$HOME/openfoam_notebooks"
