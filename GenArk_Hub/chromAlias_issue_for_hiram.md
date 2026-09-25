# chromAlias apparently ignored for hubs attaching to existing GenArk assemblies by accession

## Summary

We built a contributed-tracks hub (per the new `contribTracks.claude.html` guidelines)
with `genome GCA_018852615.3` / `genome GCA_018852605.3` stanzas (HG002v1.1 MAT/PAT)
that attach to the existing GenArk assemblies rather than defining our own
`twoBitPath`. Our trackDb data all uses `chr1_MATERNAL`/`chr1_PATERNAL`-style names
(matching the original T2T project hub and what users expect to type in the position
box), while the GenArk-hosted assemblies' native sequence names are genbank
accessions (e.g. `CP139523.2`).

We added a `chromAlias <accession>/chromAlias.txt` line to our genome stanzas,
pointing at a 2-column file mapping native accession -> our name (e.g.
`CP139523.2	chr1_MATERNAL`). `hubCheck` accepts it with no errors, but the browser's
behavior is completely unchanged before/after adding it -- it still resolves only
the accession name (e.g. shows "CP139523.2" under the ruler even when the position
box says "chr1") and shows no track data at all. It seems like a hub-supplied
`chromAlias` is ignored once a genome is attached by accession/db name to an
already-registered assembly (native db or existing GenArk hub) rather than being
defined directly by the attaching hub itself.

The docs list `chromAlias`/`chromAliasBb` under "Assembly hub 'genome' settings"
(https://genome-test.gi.ucsc.edu/goldenPath/help/trackDb/trackDbHub.html) without
calling out this limitation for attached-by-name genomes. Could this be clarified
in the docs, or better, could hub-level chromAlias overrides be honored in this
case?

## Request: add our naming as an official alias on the two GenArk assemblies

Could you add our `chr#_MATERNAL`/`chr#_PATERNAL` naming as an official alias
column on `GCA_018852615.3`/`GCA_018852605.3`'s hosted `chromAlias.txt`? Below is
the exact mapping, cross-verified against the official `<accession>.chrom.sizes.txt`
by sequence length.

### MAT (GCA_018852615.3)

| genbank | t2t alias |
| --- | --- |
| CP139523.2 | chr1_MATERNAL |
| CP139519.2 | chr2_MATERNAL |
| CP139518.2 | chr3_MATERNAL |
| CP139517.2 | chr4_MATERNAL |
| CP139516.2 | chr5_MATERNAL |
| CP139515.2 | chr6_MATERNAL |
| CP139514.2 | chr7_MATERNAL |
| CP139513.2 | chr8_MATERNAL |
| CP139512.2 | chr9_MATERNAL |
| CP139533.2 | chr10_MATERNAL |
| CP139532.2 | chr11_MATERNAL |
| CP139531.2 | chr12_MATERNAL |
| CP139530.2 | chr13_MATERNAL |
| CP139529.2 | chr14_MATERNAL |
| CP139528.2 | chr15_MATERNAL |
| CP139527.2 | chr16_MATERNAL |
| CP139526.2 | chr17_MATERNAL |
| CP139525.2 | chr18_MATERNAL |
| CP139524.2 | chr19_MATERNAL |
| CP139522.2 | chr20_MATERNAL |
| CP139521.2 | chr21_MATERNAL |
| CP139520.2 | chr22_MATERNAL |
| CP139511.2 | chrX_MATERNAL |
| CP139510.1 | chrM |

### PAT (GCA_018852605.3)

| genbank | t2t alias |
| --- | --- |
| CP139546.2 | chr1_PATERNAL |
| CP139542.2 | chr2_PATERNAL |
| CP139541.2 | chr3_PATERNAL |
| CP139540.2 | chr4_PATERNAL |
| CP139539.2 | chr5_PATERNAL |
| CP139538.2 | chr6_PATERNAL |
| CP139537.2 | chr7_PATERNAL |
| CP139536.2 | chr8_PATERNAL |
| CP139535.2 | chr9_PATERNAL |
| CP139556.2 | chr10_PATERNAL |
| CP139555.2 | chr11_PATERNAL |
| CP139554.2 | chr12_PATERNAL |
| CP139553.2 | chr13_PATERNAL |
| CP139552.2 | chr14_PATERNAL |
| CP139551.2 | chr15_PATERNAL |
| CP139550.2 | chr16_PATERNAL |
| CP139549.2 | chr17_PATERNAL |
| CP139548.2 | chr18_PATERNAL |
| CP139547.2 | chr19_PATERNAL |
| CP139545.2 | chr20_PATERNAL |
| CP139544.2 | chr21_PATERNAL |
| CP139543.2 | chr22_PATERNAL |
| CP139534.2 | chrY_PATERNAL |

(Same mapping is also saved locally as two-column tab-separated files at
`GenArk_Hub/GCA_018852615.3/chromAlias.txt` and
`GenArk_Hub/GCA_018852605.3/chromAlias.txt` in this repo.)

## Aside: MAT vs PAT official alias files are inconsistent

While you're in there -- the two officially-hosted `chromAlias.txt` files
(`https://hgdownload.soe.ucsc.edu/hubs/GCA/018/852/615/GCA_018852615.3/GCA_018852615.3.chromAlias.txt`
and the `.../605/GCA_018852605.3/...` equivalent) are inconsistent with each
other:

- MAT's `ucsc` column has friendly names: `chr1`..`chr22`, `chrX`, `chrM`.
- PAT's third column (also nominally `ucsc`) instead has raw pseudo-names like
  `CP139534v2` rather than `chr1`..`chr22`, `chrY`.

Worth reconciling those regardless of whether the `_MATERNAL`/`_PATERNAL` alias
request above is picked up.
