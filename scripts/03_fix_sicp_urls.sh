#!/bin/bash
set -euo pipefail
source common.sh

# Fix URLs for SICP
#  1. URL has moved
#  2. The % should be %25 (URL encoded); raises issues in Quarto
find "${OUT_PATH}" -name '*.md' -exec \
  sed -i 's|https://mitpress.mit.edu/sites/default/files/sicp/full-text/book/\([^%]*\)%|https://mitp-content-server.mit.edu/books/content/sectbyfn/books_pres_0/6515/sicp.zip/full-text/book/\1%25|g' {} \;
