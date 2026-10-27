#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p build
for test in tb_encoder_decoder tb_comma_alignment tb_serdes_loopback; do
  iverilog -g2005 -Wall -s "$test" -o "build/$test.vvp" rtl/*.v "tb/$test.v"
done
