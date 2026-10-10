#!/usr/bin/env bash
# Run every testbench against golden.v (and alt_*.v, which must also pass) and every broken/*.v
# (which must fail), across parameter sweeps. Prints one row per design.
#   ./run_all.sh            # all modules
#   ./run_all.sh uart_tx    # one module
set -uo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
cd "$HERE"

configs() {   # parameter sets per module, one per line
  case "$1" in
    seq_det_*) for p in B5 AA 00 FF 01 80 E7 6D; do echo "-Ptb.PATTERN=8'h$p"; done ;;
    uart_tx)   for c in 1 2 3 4 16; do echo "-Ptb.CPB=$c"; done ;;
    mem_ctrl)  for c in "4 8 1" "4 8 2" "4 8 3" "2 8 2" "6 16 4"; do set -- $c; echo "-Ptb.AW=$1 -Ptb.DW=$2 -Ptb.L=$3"; done ;;
  esac
}

mods=("$@"); [[ ${#mods[@]} -eq 0 ]] && mods=(seq_det_overlap seq_det_nonoverlap uart_tx mem_ctrl)
bad=0
for m in "${mods[@]}"; do
  echo "== $m"
  for d in "$m"/golden.v "$m"/alt_*.v "$m"/broken/*.v; do
    [[ -f "$d" ]] || continue
    want=pass; [[ "$d" == */broken/* ]] && want=fail
    row=""; any_fail=0; all_pass=1; failing=""
    while read -r cfg; do
      # shellcheck disable=SC2086
      log="$(./run.sh "$m" "$HERE/$d" +VERBOSE=0 $cfg 2>&1)"
      res="$(grep '^RESULT' <<<"$log" | sed -E 's/.*tests_passed=([0-9]+) tests_total=([0-9]+).*/\1\/\2/')"
      [[ -z "$res" ]] && res="ERR"
      if grep -Eq '^RESULT tests_passed=([0-9]+) tests_total=\1 ' <<<"$log"; then :; else
        any_fail=1; all_pass=0
        failing+=" $(grep '^TEST .* FAIL' <<<"$log" | awk '{print $2}' | tr '\n' ' ')"
      fi
      row+=" ${cfg//-Ptb./} $res |"
    done < <(configs "$m")
    if [[ $want == pass && $all_pass == 1 ]] || [[ $want == fail && $any_fail == 1 ]]; then ok=ok; else ok=UNEXPECTED; bad=1; fi
    printf "  %-10s %-42s %s\n" "$ok" "$d" "$row"
    if [[ $want == fail && -n "$failing" ]]; then
      echo "             caught by: $(tr ' ' '\n' <<<"$failing" | grep . | sort | uniq -c | sort -rn | awk '{print $2}' | head -5 | tr '\n' ' ')"
    fi
  done
done
exit $bad
