#!/bin/bash
set -euo pipefail
source common.sh

write_post () {
    FILENAME="$1"
    EXTENSION="${FILENAME##*.}"
    STEM=$(basename -- "$FILENAME" ."$EXTENSION")

    DEST="${OUT_PATH}/${STEM}"

    mkdir "${DEST}"
    ./convert_post.py "$FILENAME" "${DEST}/index.md"
}


# Clean output path
rm -rf "${OUT_PATH}"

# Start new directory
quarto create-project "${OUT_PATH}" --type website:blog

# Only output markdown
sed -i 's|contents:.*|contents: ["/*/*.md", "!notebooks/*"]|' "${OUT_PATH}/index.qmd"

# Delete sample posts
mv "${OUT_PATH}/posts/_metadata.yml" "${OUT_PATH}/_metadata.yml"
rm -rf "${OUT_PATH}/posts/"

# Convert the Markdown posts
find "${IN_PATH}/content/post" -name '*.mmark' -o -name '*.md' | \
  while read file; do write_post "$file"; done


# Convert the Markdown posts
find "${IN_PATH}/content/post" -name '*.Rmd' | \
    while read file; do mkdir "${OUT_PATH}"/$(basename -- "$file" .Rmd) && cp "$file" "${OUT_PATH}"/$(basename -- "$file" .Rmd)/index.Rmd; done

# Copy assets
for asset in images notebooks post resources; do
    cp -r "${IN_PATH}/static/${asset}" "${OUT_PATH}/${asset}"
done
