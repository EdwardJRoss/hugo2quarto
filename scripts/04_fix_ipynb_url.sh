#!/bin/bash
set -euo pipefail
source common.sh

find "$OUT_PATH" -name 'index.md' -exec sed -i 's|(/notebooks/\([^)]\+\).ipynb)|(https://nbviewer.org/github/EdwardJRoss/skeptric/blob/master/static/notebooks/\1.ipynb)|g' {} \;
