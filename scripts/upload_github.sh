#!/usr/bin/env bash
# Usage: bash scripts/upload_github.sh [--create-private|--create-public] REPOSITORY_URL [NEW_LOCAL_DIRECTORY]
# Uploads a standalone copy of the portable project to an EMPTY repository.
set -euo pipefail
project_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
create_visibility=""
case "${1:-}" in
  --create-private) create_visibility=private; shift ;;
  --create-public) create_visibility=public; shift ;;
esac
if (( $# < 1 || $# > 2 )); then
  echo "Usage: bash $0 [--create-private|--create-public] REPOSITORY_URL [NEW_LOCAL_DIRECTORY]" >&2
  echo 'Example: bash scripts/upload_github.sh https://github.com/SiliconSynthesizer/serdes_k28_5.git' >&2
  exit 2
fi
repo_url="$1"
export_dir="${2:-${project_dir}_github}"
command -v git >/dev/null || { echo 'ERROR: Install git first.' >&2; exit 1; }
if [[ -e "$export_dir" ]]; then
  echo "ERROR: Destination already exists: $export_dir. Choose a new directory." >&2
  exit 1
fi
if [[ -n "$create_visibility" ]]; then
  command -v gh >/dev/null || { echo 'ERROR: Install GitHub CLI: sudo apt-get install gh' >&2; exit 1; }
  if ! gh auth status --hostname github.com; then
    echo 'ERROR: Run gh auth login --hostname github.com, then gh auth setup-git.' >&2
    exit 1
  fi
  case "$repo_url" in
    https://github.com/*) repo_slug="${repo_url#https://github.com/}" ;;
    git@github.com:*) repo_slug="${repo_url#git@github.com:}" ;;
    *) echo 'ERROR: Repository creation requires a github.com HTTPS or SSH URL.' >&2; exit 1 ;;
  esac
  repo_slug="${repo_slug%.git}"
  if [[ ! "$repo_slug" =~ ^[A-Za-z0-9_-]+/[A-Za-z0-9_.-]+$ ]]; then
    echo 'ERROR: Expected a GitHub URL containing OWNER/REPOSITORY.' >&2; exit 1
  fi
  echo '[RUN] Verify project before creating the repository'
  bash "$project_dir/scripts/run_tests.sh"
  echo "[RUN] Create $create_visibility GitHub repository: $repo_slug"
  gh repo create "$repo_slug" "--$create_visibility" --description 'Verilog-2005 8b/10b SerDes with K28.5 alignment and self-checking Icarus tests'
fi
# Check access and refuse to overwrite a repository containing any refs.
echo '[CHECK] Remote repository access and empty-repository requirement'
if ! remote_refs="$(git ls-remote -- "$repo_url")"; then
  echo 'ERROR: Repository is missing, inaccessible, or Git authentication/network access failed.' >&2
  echo 'To create it first, rerun with --create-private (or --create-public).' >&2
  exit 1
fi
if [[ -n "$remote_refs" ]]; then
  echo 'ERROR: Remote is not empty. Create a new empty repository without README, license or .gitignore.' >&2
  exit 1
fi
if [[ -z "$create_visibility" ]]; then
  echo '[RUN] Verify project before preparing upload'
  bash "$project_dir/scripts/run_tests.sh"
fi
mkdir -p -- "$export_dir"
export_dir="$(cd "$export_dir" && pwd)"
cp -- "$project_dir/README.md" "$project_dir/.gitignore" "$export_dir/"
cp -R -- "$project_dir/rtl" "$project_dir/tb" "$project_dir/docs" "$project_dir/scripts" "$export_dir/"
mkdir -p -- "$export_dir/build"
touch "$export_dir/build/.gitkeep"
# All git writes below target the new standalone copy.
git -C "$export_dir" init -b main
git -C "$export_dir" var GIT_AUTHOR_IDENT >/dev/null
git -C "$export_dir" add -- README.md .gitignore rtl tb docs scripts build/.gitkeep
git -C "$export_dir" commit -m 'Add verified Verilog-2005 8b/10b SerDes TX/RX project'
git -C "$export_dir" remote add origin "$repo_url"
echo '[RUN] Push main to the requested repository'
git -C "$export_dir" push -u origin main
echo "[PASS] Uploaded project. Standalone checkout: $export_dir"
echo 'Future updates: edit this checkout, run tests, then git add, git commit and git push.'
