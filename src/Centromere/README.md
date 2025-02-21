# Centromere

Data provided by Fedor Ryabov on Feb. 8 2024.

Downloaded with
`wget --no-check-certificate --no-parent -r --reject "index.html*" http://185.174.137.241/primates-T2T/AS-SF_annotations/`.

Data was processed, renamed and uploaded to genomeark as below.

## Centromere
```shell
path=../path.txt
for i in $(seq 1 6)
do
  sp=`sed -n ${i}p $path | awk '{print $1}'`
  ss=`sed -n ${i}p $path | awk '{print $2}'`
  sn=`sed -n ${i}p $path | awk '{print $3}'`
  #ln -s $ss/sf.bb ${sp}_v2.0.SF_v1.0.bb
  ln -sf $ss/strand.bb ${sp}_v2.0.Strand_v1.0.bb
  aws s3 cp --profile=vgp ${sp}_v2.0.SF_v1.0.bb s3://genomeark/species/$sn/$sp/assembly_curated/repeats/cen/
  aws s3 cp --profile=vgp ${sp}_v2.0.Strand_v1.0.bb s3://genomeark/species/$sn/$sp/assembly_curated/repeats/cen/
done
```

## Track description
```
track centro
compositeTrack on
visibility dense
superTrack on show
shortLabel Centromere
longLabel Centromere Annotation
type bigBed 9 +
group rep
mouseOverField component
#html ../html/cenSupFam.html
priority 1

    track supFam
    parent centro
    shortLabel SuperFamily
    longLabel Centromere Super Family
    type bigBed 9
    visibility dense
    itemRgb on
    priority 1.2
    bigDataUrl https://genomeark.s3.amazonaws.com/species/_v2.0.SF_v1.0.bb

    track sfStrand
    parent centro
    shortLabel Strand
    longLabel Strand
    type bigBed 9
    visibility dense
    itemRgb on
    priority 1.3
    bigDataUrl https://genomeark.s3.amazonaws.com/species/_v2.0.Strand_v1.0.bb

https://genomeark.s3.amazonaws.com/species/Pan_troglodytes/mPanTro3/assembly_curated/repeats/cen/
```

## CENP-A
```shell
module load aws
module load ucsc

path=../path.txt
for i in $(seq 1 6)
do
  sp=`sed -n ${i}p $path | awk '{print $1}'`
  sn=`sed -n ${i}p $path | awk '{print $3}'`
  set -x
  sp_ver=${sp}_v2.0
  cat primate_cenpa_cutrun/$sp.*a*.cur.*.fasta.CENPA.final.bedgraph > $sp.CENPA.bg  
  bedGraphToBigWig $sp.CENPA.bg ../../T2Tgenomes/$sp_ver/$sp_ver.sizes $sp.CENPA.bw >> $sp.cenpa.log
  aws s3 --profile=vgp cp $sp.CENPA.bw s3://genomeark/species/$sn/$sp/assembly_curated/repeats/cen/
  set +x
done
```

## CENP-B

```shell
path=../path.txt

for i in $(seq 1 5)
do
  sp=`sed -n ${i}p $path | awk '{print $1}'`
  sn=`sed -n ${i}p $path | awk '{print $3}'`
  # wget http://185.174.137.241/primates-T2T/cenpb/$sp.cenpb.bb
  sp_ver=${sp}_v2.0
  aws s3 --profile=vgp cp $sp.cenpb.bb s3://genomeark/species/$sn/$sp/assembly_curated/repeats/cen/${sp}_v2.0.cenpb_sites_v1.0.bb
done
```