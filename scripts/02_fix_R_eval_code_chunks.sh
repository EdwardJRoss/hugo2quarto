#!/bin/bash
set -euo pipefail
source common.sh


# Fix code chunks that Quarto thinks need to be rendered
find "${OUT_PATH}" -name '*.md' -exec sed -i 's/^```{[rR]}/```R/' {} \;
