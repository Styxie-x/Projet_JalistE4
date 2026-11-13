#!/usr/bin/env bash

# Config
ROOT="."
README="README.md"
[ -n "$1" ] && ROOT="$1"
[ -n "$2" ] && README="$2"

START_TAG="<!-- Tree Start -->"
END_TAG="<!-- Tree End"
END_MARKER="<!-- Tree End -->"

# 1. Generate the clean tree
TREE_CONTENT=$(tree -d -L 5 -I 'node_modules|.git|CMakeFiles|build|.pio' "$ROOT")

# 2. Extract the README content outside the tree block
TEMP_HEADER=$(mktemp)
TEMP_FOOTER=$(mktemp)
trap 'rm -f "$TEMP_HEADER" "$TEMP_FOOTER" "${README}.new"' EXIT

awk -v start="$START_TAG" -v end="$END_TAG" '
    index($0, start) { found_start = 1; next }
    !found_start { print }
' "$README" > "$TEMP_HEADER"

awk -v start="$START_TAG" -v end="$END_TAG" '
    index($0, start) { in_tree = 1; next }
    index($0, end) { in_tree = 0; found_end = 1; next }
    found_end { print }
' "$README" > "$TEMP_FOOTER"

if ! grep -Fq "$START_TAG" "$README" || ! grep -Fq "$END_TAG" "$README"; then
    echo "README is missing the tree markers." >&2
    exit 1
fi

# 3. Build the new README
{
    cat "$TEMP_HEADER"
    echo "$START_TAG"
    echo '```bash'
    echo "$TREE_CONTENT"
    echo '```'
    echo "$END_MARKER"
    cat "$TEMP_FOOTER"
} > "${README}.new"

mv "${README}.new" "$README"

echo "Treeview updated successfully in $README."
