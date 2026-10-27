#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p build
run_all() {
  local test status passed=0 failed=0 index=0
  local -a tests=(tb_encoder_decoder tb_comma_alignment tb_serdes_loopback)
  local -a results=()
  echo '============================================================'
  echo '8b/10b SerDes verification -- Verilog-2005'
  echo '============================================================'
  echo '[RUN ] Compilation: iverilog -g2005 -Wall (all three testbenches)'
  if bash scripts/compile.sh 2>&1 | tee build/compile.log; then
    echo '[PASS] Compilation'
  else
    echo '[FAIL] Compilation -- see build/compile.log'
    echo 'Simulation results: 0 PASS, 0 FAIL, 3 NOT RUN (compilation failed)'
    return 1
  fi
  for test in "${tests[@]}"; do
    echo
    echo "[RUN ] $test"
    if vvp "build/$test.vvp" 2>&1 | tee "build/$test.log"; then
      if grep -q "^PASS $test" "build/$test.log"; then status=PASS;
      else status=FAIL; echo '[FAIL] Missing testbench completion marker'; fi
    else
      status=FAIL
    fi
    results+=("$status")
    if [[ "$status" == PASS ]]; then passed=$((passed+1)); else failed=$((failed+1)); fi
    echo "[$status] $test -- log: build/$test.log"
  done
  echo
  echo '============================================================'
  echo 'FINAL TEST RESULTS'
  echo '============================================================'
  for test in "${tests[@]}"; do
    printf '[%-4s] %s\n' "${results[$index]}" "$test"
    index=$((index+1))
  done
  echo "TOTAL: ${#tests[@]} | PASS: $passed | FAIL: $failed"
  echo 'Detailed results: build/test_summary.log'
  if (( failed != 0 )); then echo 'OVERALL: FAIL'; return 1; fi
  echo 'OVERALL: PASS'
}
run_all 2>&1 | tee build/test_summary.log
