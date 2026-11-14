#!/usr/bin/env bash
# sync-check.sh — every Dcare.* name cited in paper.tex matches a real
# top-level declaration in the mechanization sources (default
# ~/coglib/lean, override with LEAN_DIR); every Typed./Term./Ty.
# constructor matches a real constructor.
#
# The checkout is reported in the summary, because the paper is pinned to the
# mechanization's development state, not to a released tag: against a checkout
# that predates a cited declaration the gate fails and names it. Exit 0 = green.
set -u
HERE="$(cd "$(dirname "$0")" && pwd)"
PAPER="${1:-$HERE/../paper.tex}"
LEAN="${LEAN_DIR:-$HOME/coglib/lean}"
fail=0
pass=0
red()   { printf '\033[31m%s\033[0m\n' "$*"; }
green() { printf '\033[32m%s\033[0m\n' "$*"; }

[ -f "$PAPER" ] || { red "FAIL: no paper at $PAPER"; exit 1; }
[ -d "$LEAN/Dcare" ] || { red "FAIL: no Dcare sources at $LEAN/Dcare (set LEAN_DIR)"; exit 1; }

names=$( (rg -o 'Dcare\.[A-Za-z_][A-Za-z0-9_]*(\\_[A-Za-z0-9_]+)*' "$PAPER" \
            | sed 's/^Dcare\.//';
          rg -o '\\dcn\{[^}]+\}' "$PAPER" | sed 's/\\dcn{//;s/}//') | sort -u )
if [ -z "$names" ]; then red "FAIL: no Dcare.* citations found"; exit 1; fi
while IFS= read -r n; do
  [ -z "$n" ] && continue
  if rg -q "^(theorem|def|class|structure|inductive) $n\b" "$LEAN"/Dcare/*.lean; then
    green "PASS Dcare.$n"; pass=$((pass+1))
  else
    red "FAIL Dcare.$n — no such declaration in $LEAN/Dcare/*.lean"; fail=$((fail+1))
  fi
done <<< "$names"

ctors=$(rg -o '(Typed|Term|Ty)\.[a-z][A-Za-z0-9_]*' "$PAPER" | sort -u)
while IFS= read -r c; do
  [ -z "$c" ] && continue
  base="${c%%.*}"; nm="${c#*.}"
  if rg -q "\| $nm\b" "$LEAN"/Dcare/*.lean || rg -q "^(def|inductive) $nm\b" "$LEAN"/Dcare/*.lean; then
    green "PASS constructor $c"; pass=$((pass+1))
  else
    red "FAIL constructor $c not found in dcare sources"; fail=$((fail+1))
  fi
done <<< "$ctors"

echo "----------------------------------------"
if [ "$fail" -eq 0 ]; then
  green "SYNC-CHECK: $pass pass, 0 fail — ALL GREEN ($LEAN)"
else
  red "SYNC-CHECK: $pass pass, $fail fail — FAILURES ABOVE (checkout: $LEAN)"
  exit 1
fi
