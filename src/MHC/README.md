# MHC Annotation

Obtained from MHC.S1 and MHC.S2 from the T2T primate autosome paper. These tables were created by Joana Malukiewicz and Tobias Lenz.

Color codes were followed as in Extended Data Fig. 3.

## Convert to bb

This script takes the input .txt files as was shown in MHC.S1/S2 tables. The sequence, start, end, name, strand have been adjusted to match the bed format. Score is set to 0. The `colors.txt` file was created by extracting the color codes from ED Fig. 3.
Pseudogenes are temporarily converted to "p", and for Coding genes, the last letter(s) after `-` were taken from col 3 in the last column. These are then converted based on the mappings in `colors.txt`.

```shell
module load ucsc
module load aws

path=../path.txt
for i in $(seq 1 6)
do
  ln=`sed -n ${i}p $path`
  sp=`echo $ln | awk '{print $1}'`
  sn=`echo $ln | awk '{print $3}'`

  cat ${sp}_MHC_manual_v0.1.txt | awk -F "\t" 'BEGIN {OFS="\t"} \
    {if ($3=="Pseudogene") COL="p"; else { split($2, a, "-") ; COL=a[2] } \
    {print $1,$5-1,$6,$2,"0",$NF,$5-1,$6,COL} }' | \
    awk 'BEGIN {OFS = "\t"} FNR==NR {  mapping[$1] = $2; next } \
      { if ( $NF in mapping ) { $NF = mapping[$NF]; };  print $0 }' colors.txt - | \
      sort -k1,1 -k2,2n > ${sp}_MHC_manual_v0.1.bed
  bedToBigBed -tab -type=bed9 ${sp}_MHC_manual_v0.1.bed ../../T2Tgenomes/${sp}_v2.0/${sp}_v2.0.sizes ${sp}_MHC_manual_v0.1.bb
  aws s3 cp --profile=vgp ${sp}_MHC_manual_v0.1.bb s3://genomeark/species/$sn/$sp/assembly_curated/gene/${sp}_v2.0.MHC_manual_v0.1.bb
done
```
Confirmed mSymSyn1 chr12 and chr19 has no MHC annotation, therefore the mSymSyn1_v2.0.MHC_manual_v0.1.bb can be used for mSymSyn1_v2.1 as well.

## URL
```shell
module load aws
path=../path.txt
for i in $(seq 1 6)
do
  ln=`sed -n ${i}p $path`
  sp=`echo $ln | awk '{print $1}'`
  sn=`echo $ln | awk '{print $3}'`
  echo "https://genomeark.s3.amazonaws.com/species/$sn/$sp/assembly_curated/gene/${sp}_v2.0.MHC_manual_v0.1.bb"
done
```

```
https://genomeark.s3.amazonaws.com/species/Gorilla_gorilla/mGorGor1/assembly_curated/gene/mGorGor1_v2.0.MHC_manual_v0.1.bb
https://genomeark.s3.amazonaws.com/species/Pan_paniscus/mPanPan1/assembly_curated/gene/mPanPan1_v2.0.MHC_manual_v0.1.bb
https://genomeark.s3.amazonaws.com/species/Pan_troglodytes/mPanTro3/assembly_curated/gene/mPanTro3_v2.0.MHC_manual_v0.1.bb
https://genomeark.s3.amazonaws.com/species/Pongo_abelii/mPonAbe1/assembly_curated/gene/mPonAbe1_v2.0.MHC_manual_v0.1.bb
https://genomeark.s3.amazonaws.com/species/Pongo_pygmaeus/mPonPyg2/assembly_curated/gene/mPonPyg2_v2.0.MHC_manual_v0.1.bb
https://genomeark.s3.amazonaws.com/species/Symphalangus_syndactylus/mSymSyn1/assembly_curated/gene/mSymSyn1_v2.0.MHC_manual_v0.1.bb
```

## TrackDb.txt
```
track mhcGene
type bigBed 9
visibility dense
group genes
bigDataUrl ...
itemRgb on
shortLabel MHC
longLabel MHC Genes, manually curated
html ../html/mhcGene.html
priority 45
```

## Description
Convert R,G,B codes to hexa codes in `colors.txt`
```shell
cat colors.txt | tr ',' '\t' |
  awk '
  function rgb_to_hex(r, g, b) {
      return sprintf("#%02X%02X%02X", r, g, b)
  }
  { COL=rgb_to_hex($2,$3,$4); print "<li><span style=background-color:"COL";>&nbsp;&nbsp;&nbsp;<\/span> - "$1 }' -
```