#!/bin/bash
set -euo pipefail

IN_PATH="./data"
OUT_PATH="./output"

write_post () {
    FILENAME="$1"
    EXTENSION="${FILENAME##*.}"
    STEM=$(basename -- "$FILENAME" ."$EXTENSION")

    DEST="${OUT_PATH}/${STEM}"

    mkdir -p "${DEST}"
    ./convert_post.py "$FILENAME" "${DEST}/index.md"
}


# Clean output path
rm -rf "${OUT_PATH}"

# Start new directory
quarto create-project "${OUT_PATH}" --type website:blog

# Only output markdown
sed -i 's|contents:.*|contents: ["/*/*.md", "!notebooks/*"]|' "${OUT_PATH}/index.qmd"

# Delete sample posts
rm -rf "${OUT_PATH}/posts/"

# Convert the Markdown posts
find "${IN_PATH}/content/post" -name '*.mmark' -type f | \
  while read file; do write_post "$file"; done

# Fix code chunks that Quarto thinks need to be rendered
find "${OUT_PATH}" -name '*.md' -exec sed -i 's/^```{[rR]}/```R/' {} \;

# Fix URLs for SICP
#  1. URL has moved
#  2. The % should be %25 (URL encoded); raises issues in Quarto
find "${OUT_PATH}" -name '*.md' -exec \
  sed -i 's|https://mitpress.mit.edu/sites/default/files/sicp/full-text/book/\([^%]*\)%|https://mitp-content-server.mit.edu/books/content/sectbyfn/books_pres_0/6515/sicp.zip/full-text/book/\1%25|g' {} \;

# Copy assets
for asset in images notebooks post resources; do
    cp -r "${IN_PATH}/static/${asset}" "${OUT_PATH}/${asset}"
done

# Render the output
quarto render "${OUT_PATH}"
