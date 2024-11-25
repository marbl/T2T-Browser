# Sequence Identity

Sequence identity tracks for each primate genomes to CHM13. Received from Steven Solar.

For across-species, on primate coordinates:
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

## URL
```
https://genomeark.s3.amazonaws.com/species/Gorilla_gorilla/mGorGor1/assembly_curated/repeats/seqIdy_v1.1/CHM13v2.0_to_mGorGor1v2.0.bb
https://genomeark.s3.amazonaws.com/species/Pan_paniscus/mPanPan1/assembly_curated/repeats/seqIdy_v1.1/CHM13v2.0_to_mPanPan1v2.0.bb
https://genomeark.s3.amazonaws.com/species/Pan_troglodytes/mPanTro3/assembly_curated/repeats/seqIdy_v1.1/CHM13v2.0_to_mPanTro3v2.0.bb
https://genomeark.s3.amazonaws.com/species/Pongo_abelii/mPonAbe1/assembly_curated/repeats/seqIdy_v1.1/CHM13v2.0_to_mPonAbe1v2.0.bb
https://genomeark.s3.amazonaws.com/species/Pongo_pygmaeus/mPonPyg2/assembly_curated/repeats/seqIdy_v1.1/CHM13v2.0_to_mPonPyg2v2.0.bb
https://genomeark.s3.amazonaws.com/species/Pongo_pygmaeus/mSymSyn1/assembly_curated/repeats/seqIdy_v1.1/CHM13v2.0_to_mSymSyn1v2.1.bb
```

Template
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