#!/usr/bin/env bash
# Yazi opener helper: compresses selected files/dirs into a single .tar.gz
set -euo pipefail

if [ $# -eq 0 ]; then
  echo "No files specified" >&2
  exit 1
fi

first="$(realpath "$1")"
parent="$(dirname "$first")"
name="$(basename "$first")"

items=()
for f in "$@"; do
  items+=("$(basename "$(realpath "$f")")")
done

cd "$parent"
tar -czf "$name.tar.gz" "${items[@]}"
