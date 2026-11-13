# citations.md — the notation lane's citation ledger

One row per external reference. Status `verified` = DOI resolved against
Crossref (this session, 2026-11-13) or against the isomorphism lane's
ledger (isomorphism-paper/citations.md, resolved 2026-11-10/11 against
Crossref/Zenodo). No row ships unverified; no reference is invented.

| key | used for | reference | status |
|---|---|---|---|
| girard1987 | linear logic; proof nets | Girard, J.-Y. (1987). *Linear logic.* Theoretical Computer Science 50(1), 1–101. DOI 10.1016/0304-3975(87)90045-4 | verified (program ledger) |
| danos1989 | proof-net correctness criteria | Danos, V., & Regnier, L. (1989). *The structure of multiplicatives.* Archive for Mathematical Logic 28, 181–203. DOI 10.1007/BF01622878 | verified (Crossref, 2026-11-13) |
| joyal1991 | planar/symmetric string diagrams | Joyal, A., & Street, R. (1991). *The geometry of tensor calculus, I.* Advances in Mathematics 88(1), 55–112. DOI 10.1016/0001-8708(91)90003-P | verified (Crossref, 2026-11-13) |
| jsv1996 | feedback as trace | Joyal, A., Street, R., & Verity, D. (1996). *Traced monoidal categories.* Math. Proc. Camb. Phil. Soc. 119(3), 447–468. DOI 10.1017/S0305004100074338 | verified (Crossref, 2026-11-13) |
| lafont1997 | cut as interaction | Lafont, Y. (1997). *Interaction combinators.* Information and Computation 137(1), 69–101. DOI 10.1006/inco.1997.2643 | verified (Crossref, 2026-11-13) |
| bsz2014 | signal-flow props (closest kin) | Bonchi, F., Sobociński, P., & Zanasi, F. (2014). *A categorical semantics of signal flow graphs.* CONCUR 2014, LNCS 8704, 435–450. DOI 10.1007/978-3-662-44584-6_30 | verified (Crossref, 2026-11-13) |
| nakano2000 | the later modality | Nakano, H. (2000). *A modality for recursion.* LICS 2000, 255–266. DOI 10.1109/LICS.2000.855774 | verified (Crossref DOI record; issued-year field empty on Crossref, venue+DOI fix 2000) |
| birkedal2012 | guarded fixpoint semantics | Birkedal, L., Møgelberg, R. E., Schwinghammer, J., & Støvring, K. (2012). *First steps in synthetic guarded domain theory.* LMCS 8(4). DOI 10.2168/LMCS-8(4:1)2012 | verified (program ledger; 4th author corrected there from a wrong Kristoffersen) |
| selinger2011 | graphical-language survey | Selinger, P. (2011). *A survey of graphical languages for monoidal categories.* In New Structures for Physics, LNP 813, 289–355. DOI 10.1007/978-3-642-12821-9_4 | verified (Crossref, 2026-11-13; record issued 2010, volume published 2011) |
| polakow2017 | ordered (non-exchange) logic | Polakow, J. (2017). *Uniform atomic ordered linear logic.* LFMTP 2017, 15–23. DOI 10.1145/3130261.3130264 | verified (Crossref, 2026-11-13) |
| lustre1991 | guarded feedback / causality kinship | Halbwachs, N., Caspi, P., Raymond, P., & Pilaud, D. (1991). *The synchronous data flow programming language LUSTRE.* Proc. IEEE 79(9), 1305–1320. DOI 10.1109/5.97300 | verified (Crossref, 2026-11-13) |
| abramsky2004 | comonoid reading of the laws | Abramsky, S., & Coecke, B. (2004). *A categorical semantics of quantum protocols.* LICS 2004, 415–425. DOI 10.1109/LICS.2004.1319636 | verified (program ledger) |
| wootters1982 | no-cloning anchor (remark only) | Wootters, W. K., & Zurek, W. H. (1982). *A single quantum cannot be cloned.* Nature 299, 802–803. DOI 10.1038/299802a0 | verified (program ledger) |
| pati2000 | no-deleting anchor (remark only) | Pati, A. K., & Braunstein, S. L. (2000). *Impossibility of deleting an unknown quantum state.* Nature 404, 164–165. DOI 10.1038/404130b0 | verified (Crossref, 2026-11-13) |
| dcarecompanion | the calculus + mechanization | Marshall, J. T. *The Care Calculus: a mechanized linear type theory for safe agents.* Companion mechanization (Lean 4 `Dcare`), in preparation. | internal (the companion draft exists at dcare/paper/paper.md; author/ORCID verified against the program's Zenodo deposits) |

## Verification notes

- Every DOI above was resolved through the Crossref REST API with
  title/author/venue/volume/pages compared field-by-field (2026-11-13),
  except the four marked "program ledger", which were verified on
  2026-11-10/11 by the isomorphism lane against Crossref, the Zenodo
  record API, and library catalogues (that lane's citations.md carries
  the full trail, including two corrections: the Birkedal fourth author
  and a Lindahl DOI that was a confabulation — both fixed there).
- Declined: Kahn networks (no clean Crossref record located this
  session; LUSTRE and BSZ carry the dataflow lineage), the
  Polakow–Pfenning ICLP 1999 paper (not Crossref-indexed; the verified
  2017 LFMTP paper carries the ordered-logic anchor), and Metzinger /
  contemplative-science citations (out of this paper's scope).
