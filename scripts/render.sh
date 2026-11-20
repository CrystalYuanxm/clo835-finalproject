#!/usr/bin/env bash
# Render templates/ into manifests/ and kind/, replacing __SID__ with the student ID.
# Usage: ./scripts/render.sh [studentID]
set -euo pipefail   # stop on errors, unset variables, and pipe failures

# Repo root (works no matter where the script is run from)
ROOT="$(cd "$(dirname "$0")/.." && pwd)"

# Load STUDENT_ID from config.env; a command-line argument overrides it
source "$ROOT/config.env"
STUDENT_ID="${1:-$STUDENT_ID}"

# render_dir <template subdir> <output dir>
render_dir () {
  mkdir -p "$2"
  for f in "$ROOT/templates/$1"/*.yaml; do
    [ -e "$f" ] || continue   # skip if the folder is empty
    sed "s/__SID__/${STUDENT_ID}/g" "$f" > "$2/$(basename "$f")"
  done
}

render_dir a    "$ROOT/manifests/a"
render_dir b    "$ROOT/manifests/b"
render_dir jobs "$ROOT/manifests/jobs"
render_dir kind "$ROOT/kind"

echo "Rendered manifests for STUDENT_ID=${STUDENT_ID}"

