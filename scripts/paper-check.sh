#!/usr/bin/env bash
# paper-check.sh — structural + label-discipline gate for paper.tex.
# Exit 0 = green. Every check was spiked against a deliberately-broken
# copy before being trusted (see PROGRESS.md).
set -u
HERE="$(cd "$(dirname "$0")" && pwd)"
PAPER="${1:-$HERE/../paper.tex}"
fail=0
red()   { printf '\033[31m%s\033[0m\n' "$*"; }
green() { printf '\033[32m%s\033[0m\n' "$*"; }

[ -f "$PAPER" ] || { red "FAIL: no paper at $PAPER"; exit 1; }

# Paragraph-joined view (line wraps in the source must not defeat the
# semantic checks): expand \dcn{X} to Dcare.X, join contiguous lines into
# one record per paragraph, and normalize LaTeX-escaped underscores.
PAR="$HERE/.par.tmp"
sed 's/\\dcn{\([^}]*\)}/Dcare.\1/g' "$PAPER" \
  | awk 'BEGIN{RS=""; ORS="\n"} {gsub(/\n/," "); gsub(/\\_/,"_"); print}' > "$PAR"

# --- 1. required sections ---
for s in "Introduction" "as a written grammar" "The Care signature" \
         "as ungeneratable shapes" "worked diagrams" "The correspondence, stated precisely" \
         "Related work" "Interpretive remarks" "Conclusion"; do
  if rg -q "\\\\section\{.*$s" "$PAPER"; then green "PASS section: $s"
  else red "FAIL missing section: $s"; fail=1; fi
done

# --- 2. MEASURED discipline: each \meas sits in a paragraph naming a Dcare.* decl ---
bad=0
while IFS= read -r par; do
  case "$par" in
    *Dcare.*) : ;;
    *\\meas\{*) red "FAIL \\meas in a paragraph with no Dcare.* anchor: ${par:0:90}..."; bad=1 ;;
  esac
done < <(rg '.*' "$PAR" | rg '\\meas\{|Dcare\.' || true)
[ "$bad" -eq 1 ] && fail=1
[ "$bad" -eq 0 ] && green "PASS MEASURED label discipline (every \\meas paragraph names a Dcare.* declaration)"

# --- 3. conjecture discipline: bare unrestricted names carry fragment/conjecture/open ---
bad=0
while IFS= read -r par; do
  case "$par" in
    *onjecture*|*ragment*|*open*|*strength*) : ;;
    *) red "FAIL bare conjecture name without status: ${par:0:90}..."; bad=1 ;;
  esac
done < <(sed 's/Dcare\.no_contraction_content/«CC»/g; s/Dcare\.no_vanishing/«NV»/g' "$PAR" \
         | rg '«CC»|«NV»' || true)
[ "$bad" -eq 1 ] && fail=1
[ "$bad" -eq 0 ] && green "PASS conjecture-status discipline"
# the bare names must still BE cited (as conjectures) somewhere:
rg -q 'Dcare\.no_contraction_content' "$PAR" && rg -q 'Dcare\.no_vanishing\b' "$PAR" \
  && green "PASS both unrestricted conjectures named" \
  || { red "FAIL a conjecture is not named"; fail=1; }

# --- 4. interpretive remarks carry non-claim sentences ---
n=$(rg -c 'reading, not a result' "$PAPER" || echo 0)
if [ "${n:-0}" -ge 3 ]; then green "PASS non-claim sentences ($n)"
else red "FAIL non-claim sentences: found ${n:-0}, need >= 3"; fail=1; fi

# --- 5. physics vocabulary confined to the remarks section ---
sec7=$(rg -n '\\section\{Interpretive remarks\}' "$PAPER" | head -1 | cut -d: -f1)
sec8=$(rg -n '\\section\{Conclusion\}' "$PAPER" | head -1 | cut -d: -f1)
if [ -n "$sec7" ] && [ -n "$sec8" ]; then
  bad=0
  while IFS= read -r hit; do
    ln="${hit%%:*}"
    if [ "$ln" -lt "$sec7" ] || [ "$ln" -ge "$sec8" ]; then
      red "FAIL physics term outside remarks: $hit"; bad=1
    fi
  done < <(rg -in 'planck|black.?hole|spacetime|information paradox|quantum gravity|quantum' "$PAPER" || true)
  [ "$bad" -eq 1 ] && fail=1
  [ "$bad" -eq 0 ] && green "PASS physics vocabulary confined to the remarks"
else
  red "FAIL could not locate remarks/conclusion sections"; fail=1
fi

# --- 6. claims discipline: five claims, each with a sketch ---
nc=$(rg -c '\\begin\{claim\}' "$PAPER" || echo 0)
ns=$(rg -c '\\begin\{proofsketch\}' "$PAPER" || echo 0)
if [ "${nc:-0}" -eq 5 ]; then green "PASS five claims"
else red "FAIL claims: found ${nc:-0}, need 5"; fail=1; fi
if [ "${ns:-0}" -ge 4 ]; then green "PASS proof sketches ($ns)"
else red "FAIL proof sketches: ${ns:-0}"; fail=1; fi

# --- 6b. the grammar is the paper's subject: operators, law errors,
#         and the one-line cycle must all be present ---
rg -q 'The five operators' "$PAPER" && green "PASS operator table" \
  || { red "FAIL no five-operator table"; fail=1; }
ne=$(rg -c '\\lawerr\b' "$PAPER" || echo 0)
if [ "${ne:-0}" -ge 2 ]; then green "PASS law-error displays ($ne)"
else red "FAIL law-error displays: ${ne:-0} < 2"; fail=1; fi
rg -q 'schematic form of the' "$PAR" && green "PASS one-line cycle (the schematic display)" \
  || { red "FAIL no one-line cycle schematic"; fail=1; }

# --- 7. related work present and populated ---
if rg -q '\\section\{Related work\}' "$PAPER"; then
  c=$(sed -n '/\\section{Related work}/,/\\section{Interpretive remarks}/p' "$PAPER" | rg -o '\\cite\{' | wc -l)
  if [ "$c" -ge 6 ]; then green "PASS related work cites ($c)"
  else red "FAIL related work cites: $c < 6"; fail=1; fi
fi

# --- 8. availability note ---
rg -q 'AGPL' "$PAPER" && green "PASS availability (AGPL)" || { red "FAIL no AGPL note"; fail=1; }

# --- 9. every figure file referenced exists ---
bad=0
while IFS= read -r f; do
  [ -f "$HERE/../$f.tex" ] || { red "FAIL missing figure file: $f.tex"; bad=1; }
done < <(rg -o '\\input\{figures/[^}]+\}' "$PAPER" -r '$0' | sed 's/\\input{//;s/}//' || true)
[ "$bad" -eq 0 ] && green "PASS figure files exist"
[ "$bad" -eq 1 ] && fail=1

rm -f "$PAR"
echo "----------------------------------------"
[ "$fail" -eq 0 ] && green "PAPER-CHECK: ALL GREEN" || red "PAPER-CHECK: FAILURES ABOVE"
exit $fail
