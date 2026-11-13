#!/usr/bin/env bash
# sync-check.sh — every Dcare.* name cited in paper.tex matches a real
# top-level declaration in /workspace/dcare/lean; every Typed./Term./Ty.
# constructor matches a real constructor. Exit 0 = green.
set -u
HERE="$(cd "$(dirname "$0")" && pwd)"
PAPER="${1:-$HERE/../paper.tex}"
LEAN="/workspace/dcare/lean"
fail=0
red()   { printf '\033[31m%s\033[0m\n' "$*"; }
green() { printf '\033[32m%s\033[0m\n' "$*"; }

[ -f "$PAPER" ] || { red "FAIL: no paper at $PAPER"; exit 1; }

names=$( (rg -o 'Dcare\.[A-Za-z_][A-Za-z0-9_]*(\\_[A-Za-z0-9_]+)*' "$PAPER" \
            | sed 's/^Dcare\.//';
          rg -o '\\dcn\{[^}]+\}' "$PAPER" | sed 's/\\dcn{//;s/}//') | sort -u )
if [ -z "$names" ]; then red "FAIL: no Dcare.* citations found"; exit 1; fi
while IFS= read -r n; do
  [ -z "$n" ] && continue
  if rg -q "^(theorem|def|class|structure|inductive) $n\b" "$LEAN"/Dcare/*.lean; then
    green "PASS Dcare.$n"
  else
    red "FAIL Dcare.$n — no such declaration in $LEAN/Dcare/*.lean"; fail=1
  fi
done <<< "$names"

ctors=$(rg -o '(Typed|Term|Ty)\.[a-z][A-Za-z0-9_]*' "$PAPER" | sort -u)
while IFS= read -r c; do
  [ -z "$c" ] && continue
  base="${c%%.*}"; nm="${c#*.}"
  if rg -q "\| $nm\b" "$LEAN"/Dcare/*.lean || rg -q "^(def|inductive) $nm\b" "$LEAN"/Dcare/*.lean; then
    green "PASS constructor $c"
  else
    red "FAIL constructor $c not found in dcare sources"; fail=1
  fi
done <<< "$ctors"

echo "----------------------------------------"
[ "$fail" -eq 0 ] && green "SYNC-CHECK: ALL GREEN" || red "SYNC-CHECK: FAILURES ABOVE"
exit $fail
