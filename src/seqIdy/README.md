# Sequence Identity

Sequence identity tracks for each primate genomes to CHM13. Received from Steven Solar.

## For across-species, on primate coordinates:
`$projects2/acro_comparisons/heatmap_beds/across_species/m*/m*.to.chm13.bb`

```shell
for f in $(ls $projects2/acro_comparisons/heatmap_beds/across_species/m*/m*.to.chm13.bb)
do
  ln -s $f
done

module load aws

path=../path.txt
for i in $(seq 1 5)
do
  ln=`sed -n ${i}p $path`
  sp=`echo $ln | awk '{print $1}'`
  sn=`echo $ln | awk '{print $3}'`
  echo $sp $sn
  aws s3 cp --profile=vgp $sp.to.chm13.bb s3://genomeark/species/$sn/$sp/assembly_curated/repeats/seqIdy_v1.1/CHM13v2.0_to_${sp}v2.0.bb
  echo "https://genomeark.s3.amazonaws.com/species/$sn/$sp/assembly_curated/repeats/seqIdy_v1.1/CHM13v2.0_to_${sp}v2.0.bb"
done

i=6
ln=`sed -n ${i}p $path`
sp=`echo $ln | awk '{print $1}'`
echo $sp
aws s3 cp --profile=vgp $sp.to.chm13.bb s3://genomeark/species/$sn/$sp/assembly_curated/repeats/seqIdy_v1.1/CHM13v2.0_to_${sp}v2.1.bb
echo "https://genomeark.s3.amazonaws.com/species/$sn/$sp/assembly_curated/repeats/seqIdy_v1.1/CHM13v2.0_to_${sp}v2.1.bb"
```

### URL
```
https://genomeark.s3.amazonaws.com/species/Gorilla_gorilla/mGorGor1/assembly_curated/repeats/seqIdy_v1.1/CHM13v2.0_to_mGorGor1v2.0.bb
https://genomeark.s3.amazonaws.com/species/Pan_paniscus/mPanPan1/assembly_curated/repeats/seqIdy_v1.1/CHM13v2.0_to_mPanPan1v2.0.bb
https://genomeark.s3.amazonaws.com/species/Pan_troglodytes/mPanTro3/assembly_curated/repeats/seqIdy_v1.1/CHM13v2.0_to_mPanTro3v2.0.bb
https://genomeark.s3.amazonaws.com/species/Pongo_abelii/mPonAbe1/assembly_curated/repeats/seqIdy_v1.1/CHM13v2.0_to_mPonAbe1v2.0.bb
https://genomeark.s3.amazonaws.com/species/Pongo_pygmaeus/mPonPyg2/assembly_curated/repeats/seqIdy_v1.1/CHM13v2.0_to_mPonPyg2v2.0.bb
https://genomeark.s3.amazonaws.com/species/Pongo_pygmaeus/mSymSyn1/assembly_curated/repeats/seqIdy_v1.1/CHM13v2.0_to_mSymSyn1v2.1.bb
```

### Template
```
track seqidyCHM13
shortLabel SeqIdy (T2T-CHM13)
longLabel Sequence Identity in 10kb, to T2T-CHM13
group rep
type bigBed 9
itemRgb on
visibility dense
mouseOverField name
bigDataUrl 
html ../html/seqIdy.html
priority 25.6
```

## On T2T-CHM13v2.0 coordinates

`$projects2/acro_comparisons/heatmap_beds/across_species/CHM13/CHM13.to.*.bb`

```shell
for f in $(ls $projects2/acro_comparisons/heatmap_beds/across_species/CHM13/CHM13.to.*.bb)
do
  ln -s $f
done

module load aws

path=../path.txt
for i in $(seq 1 5)
do
  ln=`sed -n ${i}p $path`
  sp=`echo $ln | awk '{print $1}'`
  echo $sp
  aws s3 cp CHM13.to.$sp.bb s3://human-pangenomics/T2T/browser/CHM13/bbi/seqIdy_v1.1/${sp}v2.0_to_CHM13.bb
  echo "https://s3-us-west-2.amazonaws.com/T2T/browser/CHM13/bbi/seqIdy_v1.1/${sp}v2.0_to_CHM13.bb"
done

```

### URLs
```
https://s3-us-west-2.amazonaws.com/T2T/browser/CHM13/bbi/seqIdy_v1.1/mGorGor1v2.0_to_CHM13.bb
https://s3-us-west-2.amazonaws.com/T2T/browser/CHM13/bbi/seqIdy_v1.1/mPanPan1v2.0_to_CHM13.bb
https://s3-us-west-2.amazonaws.com/T2T/browser/CHM13/bbi/seqIdy_v1.1/mPanTro3v2.0_to_CHM13.bb
https://s3-us-west-2.amazonaws.com/T2T/browser/CHM13/bbi/seqIdy_v1.1/mPonAbe1v2.0_to_CHM13.bb
https://s3-us-west-2.amazonaws.com/T2T/browser/CHM13/bbi/seqIdy_v1.1/mPonPyg2v2.0_to_CHM13.bb
```

### Template
```
track seqidyPrimates
superTrack on
visibility dense
shortLabel SeqIdy (Primates)
longLabel Sequence Identity in 10kb, T2T-Primate Genomes with Human Orthologs
group rep
type bigBed 9
itemRgb on
mouseOverField name
html ../html/seqIdy.html
priority 24.50

  track seqIdyGorGor1
  parent seqidyPrimates
  shortLabel Gorilla
  longLabel mGorGor1 GGO (Gorilla)
  bigDataUrl https://s3-us-west-2.amazonaws.com/T2T/browser/CHM13/bbi/seqIdy_v1.1/mGorGor1v2.0_to_CHM13.bb
  priority 24.51

  track seqIdyPanPan1
  parent seqidyPrimates
  shortLabel Bonobo
  longLabel mPanPan1v2.0 PPA (Bonobo)
  bigDataUrl https://s3-us-west-2.amazonaws.com/T2T/browser/CHM13/bbi/seqIdy_v1.1/mPanPan1v2.0_to_CHM13.bb
  priority 24.52

  track seqIdyPanTro3
  parent seqidyPrimates
  shortLabel Chimpanzee
  longLabel mPanTro3v2.0 PTR (Chimpanzee)
  bigDataUrl https://s3-us-west-2.amazonaws.com/T2T/browser/CHM13/bbi/seqIdy_v1.1/mPanTro3v2.0_to_CHM13.bb
  priority 24.53

  track seqIdyPonAbe1
  parent seqidyPrimates
  shortLabel S_Orang
  longLabel mPonAbe1v2.0 PAB (Sumatran orangutan)
  bigDataUrl https://s3-us-west-2.amazonaws.com/T2T/browser/CHM13/bbi/seqIdy_v1.1/mPonAbe1v2.0_to_CHM13.bb
  priority 24.54

  track seqIdyPonPyg2
  parent seqidyPrimates
  shortLabel B_Orang
  longLabel mPonPyg2v2.0 PPY (Bornean orangutan)
  bigDataUrl https://s3-us-west-2.amazonaws.com/T2T/browser/CHM13/bbi/seqIdy_v1.1/mPonPyg2v2.0_to_CHM13.bb
  priority 24.55

#  track seqIdySymSyn1
#  parent seqidyPrimates
#  shortLabel S_Gibbon
#  longLabel mSymSyn1v2.0 SSY (Siamang Gibbon)
#  bigDataUrl https://s3-us-west-2.amazonaws.com/T2T/browser/CHM13/bbi/seqIdy_v1.1/mSymSyn1v2.0_to_CHM13.bb
#  priority 24.56
```