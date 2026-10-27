#!/usr/bin/env bash
set -euo pipefail
project_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
build_dir="$project_dir/build"
removed=0
shopt -s nullglob
for generated_file in "$build_dir"/*.vvp "$build_dir"/*.vcd "$build_dir"/*.fst "$build_dir"/*.log; do
  if [[ -f "$generated_file" ]]; then
    rm -- "$generated_file"
    removed=$((removed+1))
  fi
done
printf '[PASS] Cleaned %d generated build files; source files and build/.gitkeep preserved.\n' "$removed"
