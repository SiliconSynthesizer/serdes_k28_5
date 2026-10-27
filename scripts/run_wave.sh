#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
wave="build/${1:-tb_serdes_loopback}.vcd"
if [[ ! -f "$wave" ]]; then bash scripts/run_tests.sh; fi
exec gtkwave "$wave"
