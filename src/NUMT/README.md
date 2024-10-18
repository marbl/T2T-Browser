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

## Rename chroms for mSymSyn1_v2.1
Checking mSymSyn1 track, seems like it's neither v2.0 nor v2.1.

```shell
bigBedToBed mSymSyn1.numts.bb mSymSyn1_v2.0.numts.bed
size=../../T2Tgenomes/mSymSyn1_v2.0/mSymSyn1_v2.0.sizes
bedToBigBed mSymSyn1_v2.0.numts.bed $size mSymSyn1_v2.0.numts.bb
# End coordinate 113282327 bigger than chr12_hap2 size of 101944316 line 141 of mSymSyn1_v2.0.numts.bed

size=../../T2Tgenomes/mSymSyn1_v2.1/mSymSyn1_v2.1.sizes
bedToBigBed mSymSyn1_v2.0.numts.bed $size mSymSyn1_v2.0.numts.bb
# End coordinate 98079278 bigger than chr19_hap1 size of 98029838 line 403 of mSymSyn1_v2.0.numts.bed
```

Waiting to be resolved. Trek conversion can be done with

```shell
update_mSymSyn1_v2.0_track_to_v2.1.sh in.bb out.bb -type=bed3
```

## bigDataUrl
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
```
track numt
shortLabel NUMT
longLabel Nuclear-Mitochondrial DNA segment
type bigBed 3
visibility dense
group rep
bigDataUrl ...
html ../html/numt.html
priority 27
```