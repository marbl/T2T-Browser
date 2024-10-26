# NUMT

Received from Edmundo Torres-Gonzalez.

Globus: /primate_T2T/numt_annotation/

## Upload
```shell
path=../path.txt
for i in $(seq 1 5)
do
  line=`sed -n ${i}p ../path.txt`
  sn=`echo $line | awk '{print $3}'`
  sp=`echo $line | awk '{print $1}'`

  aws s3 cp --profile=vgp $sp.numts.bb s3://genomeark/species/$sn/$sp/assembly_curated/repeats/${sp}_v2.0.numts_v1.0.bb
done
```

## Rename chroms for mSymSyn1_v2.0-v2.1
Checking mSymSyn1 track, seems like it's neither v2.0 nor v2.1.
Received updated file for v2.1 on Oct. 18

```shell
ln -s ../../src/update_mSymSyn1_tracks.sh
./update_mSymSyn1_tracks.sh mSymSyn1.numts.bb mSymSyn1_v2.0.numts_v1.0.bb -type=bed3 v2.0
ln -s mSymSyn1.numts.bb mSymSyn1_v2.1.numts_v1.0.bb
```

Upload
```shell
module load aws
sn=Symphalangus_syndactylus
sp=mSymSyn1
aws s3 cp --profile=vgp mSymSyn1_v2.0.numts_v1.0.bb s3://genomeark/species/$sn/$sp/assembly_curated/repeats/
aws s3 cp --profile=vgp mSymSyn1_v2.1.numts_v1.0.bb s3://genomeark/species/$sn/$sp/assembly_curated/repeats/
```

## Track Description
Collect URLs
```shell
path=../path.txt
for i in $(seq 1 5)
do
  line=`sed -n ${i}p ../path.txt`
  sn=`echo $line | awk '{print $3}'`
  sp=`echo $line | awk '{print $1}'`
  echo "bigDataUrl https://genomeark.s3.amazonaws.com/species/$sn/$sp/assembly_curated/repeats/${sp}_v2.0.numts_v1.0.bb"
done
```

```
bigDataUrl https://genomeark.s3.amazonaws.com/species/Gorilla_gorilla/mGorGor1/assembly_curated/repeats/mGorGor1_v2.0.numts_v1.0.bb
bigDataUrl https://genomeark.s3.amazonaws.com/species/Pan_paniscus/mPanPan1/assembly_curated/repeats/mPanPan1_v2.0.numts_v1.0.bb
bigDataUrl https://genomeark.s3.amazonaws.com/species/Pan_troglodytes/mPanTro3/assembly_curated/repeats/mPanTro3_v2.0.numts_v1.0.bb
bigDataUrl https://genomeark.s3.amazonaws.com/species/Pongo_abelii/mPonAbe1/assembly_curated/repeats/mPonAbe1_v2.0.numts_v1.0.bb
bigDataUrl https://genomeark.s3.amazonaws.com/species/Pongo_pygmaeus/mPonPyg2/assembly_curated/repeats/mPonPyg2_v2.0.numts_v1.0.bb
bigDataUrl https://genomeark.s3.amazonaws.com/species/Symphalangus_syndactylus/mSymSyn1/assembly_curated/repeats/mSymSyn1_v2.0.numts_v1.0.bb
```
Track description template
```
track numt
shortLabel NUMT
longLabel Nuclear-Mitochondrial DNA Segment
type bigBed 3
visibility dense
group rep
bigDataUrl ...
html ../html/numt.html
priority 27
```

## T2T-CHM13
Track received for CHM13.

Upload:
```shell
module load aws
aws s3 cp CHM13.numts.bb s3://human-pangenomics/T2T/browser/CHM13/bbi/numt_v0.1.bb
```

## Track description
```
track numt
shortLabel NUMT
longLabel Nuclear-Mitochondrial DNA Segment
type bigBed 3
visibility dense
group rep
bigDataUrl https://s3-us-west-2.amazonaws.com/human-pangenomics/T2T/browser/CHM13/bbi/numt_v0.1.bb
html ../html/numt.html
priority 28
```