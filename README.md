# The Guarded Syntax

Artifact for the paper `paper.tex`:

> *The Guarded Syntax: A Notation for Linear Resource Calculi*

**Published: concept doi [10.5281/zenodo.24221796](https://doi.org/10.5281/zenodo.24221796)** —
it always resolves to the latest archived version. Cite the paper by the concept DOI;
[v1.2.0](https://doi.org/10.5281/zenodo.24232695) is the current archived version;
[v1.1.0](https://doi.org/10.5281/zenodo.24226078) and
[v1.0.0](https://doi.org/10.5281/zenodo.24221797) are the earlier ones.

The **Guarded Syntax** is a written notation for the Care Calculus, a multi-sorted
ordered linear logic with coalgebraic generators and guarded recursion, mechanized
in Lean 4. The notation has five operators: the knower `⦿`, the one Cartesian
source; the linear wire `⊸`, which consumes the left and produces the right exactly
once; the guard `▷`, one interval of delay; the feed `↺`, which binds a delayed
output back into its own definition (the `+1`); and the sink `⊥`, the archive where
content is recorded and never read (the `-1`). Agent definitions are one-line
expressions of this grammar — the notation's operators of consumption, delay and
feedback answer exactly the calculus's three structural questions, typographically.

The calculus's two linearity laws appear as expressions that fail to type: a cloner
and an eraser are unwritable, while the archive is legal, and that difference is
load-bearing. The laws' theorem statements and their machine-checked fragment
strengths sit alongside. The correspondence is stated precisely: well-formed
expressions translate to derivations and back; the linear cut is the rewrite rule
that splices a pending binder into the hole it closes; and the feed is legal exactly
when guarded.

Well-formedness is compositional — there is no global correctness criterion, and the
two linearity laws are not forbidden moves to be checked after writing but shapes
the grammar simply cannot generate: a linear wire has no junction, and a content
wire has no bare end. Every expression in the paper is drawn from a named,
machine-checked derivation. The notation-level correspondence is stated as claims
with proof sketches, not mechanized; the paper says so in its own voice.

## Layout

| path | contents |
|---|---|
| `paper.tex` | the paper (LaTeX, EPTCS document class — the source of truth): §2 gives the grammar, its five operators and its two laws |
| `paper.pdf` | the compiled paper, built by `scripts/build.sh` |
| `guarded-syntax.sty` | the notation's LaTeX macros — the five operators, the law-error marks, and the display environments the paper is written in |
| `eptcs.cls`, `eptcs.bst` | the EPTCS class and bibliography style (v1.7, from eptcs.org) |
| `refs.bib` | the bibliography |
| `citations.md` | the citation ledger — one row per citation, with the claim it supports, its source, and its verification status; no reference ships in the paper without a row |
| `scripts/build.sh` | the compile gate: `pdflatex` + `bibtex` + `pdflatex` ×2, exit 0 only on a clean build |
| `scripts/paper-check.sh` | the structural gate: required sections, the `\meas` label discipline (every measured paragraph names a `Dcare.*` declaration), the conjecture-status discipline, the non-claim sentences of the interpretive remarks, physics vocabulary confined to the remarks, five claims with sketches, related-work density, the availability note — and that the paper carries **zero** figures or drawings |
| `scripts/sync-check.sh` | the paper-anchor gate: every `Dcare.*` name the paper cites (20 of them) must be a real declaration in a `Dcare` Lean 4 checkout; the `Typed.`/`Term.`/`Ty.` constructor check covers the case where the paper cites one |

Each check in `paper-check.sh` was spiked against a deliberately-broken copy of the
paper before it was trusted.

## Gates

`paper-check.sh` is self-contained — it reads `paper.tex` and nothing else:

```
./scripts/paper-check.sh        # exit 0 = all green
```

`build.sh` needs a TeX installation with `pdflatex` and `bibtex`:

```
./scripts/build.sh              # exit 0 = clean build, prints the page count
```

`sync-check.sh` resolves the paper's machine-checked anchors against the Lean
sources, so it needs a `Dcare` checkout. The root defaults to `~/coglib/lean` and
is overridden with `LEAN_DIR`:

```
LEAN_DIR=/path/to/dcare/lean ./scripts/sync-check.sh   # exit 0 = all green
```

The gate reports the checkout it used, because the paper is anchored to the
mechanization's *development* state rather than to a released tag. Two of the 20
anchors — `Dcare.no_vanishing_fix_conditional` and
`Dcare.no_vanishing_fixfree_conditional`, both declared in `Dcare/Chase.lean` —
postdate the `Chase.lean` in the public `coglib` checkout, so against that
checkout the gate fails and names them. This is the gate working: it is how a
reader learns that the two anchors are unverified against the published
mechanization. Against a checkout that carries them the gate is green (20 pass,
0 fail).

## License

GNU Affero General Public License, version 3.0 or later — see `LICENSE`. This
covers the paper's LaTeX source, its macros, the compiled PDF,
and the gate scripts, matching the paper's own Artifact availability paragraph
(§1: "The Lean 4 development `Dcare` and the complete LaTeX source of this paper,
including the diagram macros of `guarded-syntax.sty`, are available under GNU
AGPL-3.0").

The copyright holder is Jaye Timothy Marshall, ORCID
[0009-0002-5209-8161](https://orcid.org/0009-0002-5209-8161) — the same name and
ORCID iD as the paper's author line and the Zenodo metadata (`.zenodo.json`).

## Status

Prepared for public release as a preprint with its LaTeX source and gates.

The companion Lean 4 mechanization the paper's anchors refer to is not part of this
repository; it is developed separately, and `scripts/sync-check.sh` is how the
paper's anchors are checked against a checkout of it. The diagram-level
correspondence is stated as claims with proof sketches, not mechanized, and the
paper is explicit about that boundary.
