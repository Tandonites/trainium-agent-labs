#!/usr/bin/env bash
# Run one testbench against one design.
#   ./run.sh <module_dir> [design.v] [plusargs...] [-P<param>=<value>...]
# Examples:
#   ./run.sh uart_tx                                  # golden.v, default verbosity
#   ./run.sh uart_tx my_uart.v +VERBOSE=2              # per-cycle table of inputs/outputs/expected
#   ./run.sh seq_det_overlap golden.v -Ptb.PATTERN=8\'hAA
#   ./run.sh mem_ctrl golden.v +VERBOSE=0 +VCD         # summary only, dump tb.vcd
# Exit status 0 only when every test passes.
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
dir="$HERE/${1:?module dir}"; shift
design="$dir/golden.v"
if [[ $# -gt 0 && "$1" != +* && "$1" != -P* ]]; then design="$1"; shift; fi
params=(); plus=()
for a in "$@"; do [[ "$a" == -P* ]] && params+=("$a") || plus+=("$a"); done
out="$(mktemp -d)"; trap 'rm -rf "$out"' EXIT
iverilog -g2012 -Wall -Wno-timescale -I "$HERE/common" ${params[@]+"${params[@]}"} \
  -o "$out/sim" "$dir/tb.v" "$design"
log="$(vvp -n "$out/sim" ${plus[@]+"${plus[@]}"})"
echo "$log"
grep -q '^RESULT ' <<<"$log" || exit 2
grep -Eq '^RESULT tests_passed=([0-9]+) tests_total=\1 ' <<<"$log"
