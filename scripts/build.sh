#!/usr/bin/env bash
# build.sh — the compile gate: pdflatex + bibtex + pdflatex x2, clean exit.
# (latexmk is not assumed present; the loop is explicit.)
set -u
cd "$(dirname "$0")/.."
rm -f paper.aux paper.bbl paper.blg paper.out paper.log paper.toc
pdflatex -interaction=nonstopmode paper.tex >/dev/null 2>&1 || true
bibtex paper >/dev/null 2>&1 || true
pdflatex -interaction=nonstopmode paper.tex >/dev/null 2>&1 || true
pdflatex -interaction=nonstopmode paper.tex > /tmp/build-final.log 2>&1
errs=$(grep -c '^!' paper.log || true)
if [ -f paper.pdf ] && [ "$errs" -eq 0 ]; then
  pages=$(grep -o 'Output written on paper.pdf ([0-9]* pages' paper.log | grep -o '[0-9]*')
  echo "BUILD: clean ($pages pages)"
  exit 0
else
  echo "BUILD: FAIL ($errs errors)"
  grep '^!' paper.log | sort | uniq -c | sort -rn | head -10
  exit 1
fi
