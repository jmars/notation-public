# PROGRESS.md — the Guarded Syntax lane (/workspace/notation)

Plan of record: memory node `handoff-guarded-syntax-plan` rev 5–6
(the lane moved to ./notation per user directive; identity = a real,
working notation for type theorists — planarity, correspondence claims,
mandatory related work).

## Log

- **2026-11-13 (session 1).** Lane scaffolded and the paper drafted in
  full. Anchors: every `Dcare.*` name swept against
  /workspace/dcare/lean before writing (22 declarations verified, incl.
  the two unrestricted conjectures at Linearity.lean — cited as
  conjectures with fragment ladders only). Citations: 15 rows, all
  verified this session via Crossref or inherited verified from the
  isomorphism lane's ledger (two rows re-verified: pati2000, selinger).
  eptcs.cls v1.7 + eptcs.bst fetched from eptcs.org. texlive installed
  (basic/latex/pictures/latexextra/fontsrecommended). Files: paper.tex,
  guarded-syntax.sty, figures/{fig-core,fig-signature,fig-laws,fig-cycle,
  fig-cut,fig-swap}.tex, refs.bib, citations.md,
  scripts/{paper-check,sync-check,build}.sh, PROGRESS.md (this file).
- **2026-11-13 (session 1, cont).** COMPLETE first draft: BUILD clean
  (13 pages, 0 errors, worst overfull 9.9pt), paper-check ALL GREEN,
  sync-check ALL GREEN (21 Dcare names + constructors). Gate bugs found
  and fixed during spiking (the record, per the lane's discipline):
  (1) checks printed FAIL but never set the exit flag — caught because a
  spiked "failing" run exited 0; (2) a malformed ${par:0:90]} expansion
  aborted the bad=1 assignment mid-line — caught by bash -x after a
  spike landed but did not fire; (3) escaped underscores (\_) defeated
  three checks silently — fixed by normalizing in the paragraph view;
  (4) the \dcn{} breakable-name macro hid names from both gates — both
  now expand it. SPIKES (all verified to fire, exit != 0): meas-without-
  anchor, bare-conjecture-without-status, physics-outside-remarks,
  dropped non-claim sentence, missing section, dropped AGPL, fake
  Dcare name (\texttt and \dcn forms). LaTeX fixes: EPTCS defines no
  \keywords (removed — none invented); abstract is an ENVIRONMENT in the
  document body, not a preamble command; eptcs.bst's fallback \doi
  chokes on underscores — \doi pre-defined via \nolinkurl; fig-core
  labels needed math mode.

## Gate discipline

- `scripts/build.sh` — pdflatex + bibtex + 2x pdflatex, 0 errors, PDF
  produced (the compile gate; latexmk vanished from the image mid-session
  and is not assumed).
- `scripts/paper-check.sh` — sections, MEASURED-label discipline
  (every \meas paragraph names a Dcare.* declaration), conjecture-status
  discipline (bare unrestricted names carry fragment/conjecture/open
  language, and both ARE named), non-claim sentences in the remarks,
  physics vocabulary confined to §7, five claims + sketches, related-work
  density, AGPL note, figure files exist.
- `scripts/sync-check.sh` — Dcare.* names (both \texttt{Dcare.x\_y} and
  \dcn{x_y} forms) and Typed./Term./Ty. constructors exist in the
  mechanization.

## Known open items

- The submission contact email (TODO marked in paper.tex; no email on
  record for the author — none invented).
- Claim 5 (equivalence/completeness of the move set) is honestly open in
  the paper; a future unit could prove the soundness claim mechanically
  (diagram → derivation checker).
- No commits made (the human's call).
