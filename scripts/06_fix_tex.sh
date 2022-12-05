#!/bin/bash
set -euo pipefail
source common.sh

find "${OUT_PATH}" -name index.md -exec sed -i '{N;s/\$\$\([^$]\+\)\$\$/$\1$/g;ty;P;D;:y}' {} \;
find "${OUT_PATH}" -name index.md -exec sed -i 's/\$\s*\([^$]*[^ $]\)\s*\$/$\1$/g' {} \;
