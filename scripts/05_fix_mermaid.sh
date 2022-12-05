#!/bin/bash
set -euo pipefail
source common.sh

find "${OUT_PATH}" -name 'index.md' -exec sed -i -e 's|^{{ *<mermaid> *}}|```{mermaid}|' -e 's|^{{< */mermaid *>}}|```|' {} \;

# They are now executable: rename to .qmd
find output -name 'index.md' | xargs -n1 grep -l '```{mermaid}' | xargs -n1 sh -c 'mv "$0" "${0%.md}.qmd"'
