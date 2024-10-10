#!/bin/bash

#IN=/data/Phillippy2/projects/acro_comparisons/heatmap_beds/same_species/all_tracks
IN=/data/Phillippy2/projects/acro_comparisons/heatmap_beds/same_species/all_tracks/seqIdy
OUT=/data/Phillippy2/projects/T2T-Browser/incoming/seqIdy
#cd $OUT

module load ucsc
module load aws

path=../path.txt

:<<'END'
for i in $(seq 1 6)
do
  sp=`sed -n ${i}p $path | awk '{print $1}'`
  sn=`sed -n ${i}p $path | awk '{print $3}'`
  sp_ver=${sp}_v2.0
  SIZE=../../T2Tgenomes/$sp_ver/$sp_ver.sizes
  for hap in $(cut -f1 $SIZE | grep -v "random" | sort -k1,1V | grep chr)
  do
    out=$sp.$hap
    echo $out
    for track in $(ls $IN/$sp/all/chr*.$hap.bed)
    do
      echo $track
      cat $track | awk '{print $1"\t"$2"\t"$3"\t"$5"\t0\t"$6"\t"$7"\t"$8"\t"$9}' >> $out.bed
    done
    set -x
    bedToBigBed -tab -type=bed9 $out.bed $SIZE $out.bb
    set +x
    rm $out.bed
  done
done


# Upload v1.0
for i in $(seq 1 6)
do
  sp=`sed -n ${i}p $path | awk '{print $1}'`
  sn=`sed -n ${i}p $path | awk '{print $3}'`
  sp_ver=${sp}_v2.0
  echo "Uploading $sp_ver"
  src=$IN/$sp
  aws s3 --profile=vgp cp --recursive --exclude "*" --include "chr*.bb" $src s3://genomeark/species/$sn/$sp/assembly_curated/repeats/seqIdy/
done


for i in $(seq 1 6)
do
  sp=`sed -n ${i}p $path | awk '{print $1}'`
  sn=`sed -n ${i}p $path | awk '{print $3}'`
  sp_ver=${sp}_v2.0
  SIZE=../../T2Tgenomes/$sp_ver/$sp_ver.sizes
  rm $sp.rep.trackDb.txt
  j=10
  for hap in $(cut -f1 $SIZE | grep -v "random" | sort -k1,1V | grep chr)
  do
    out=$sp.$hap
    echo $out
    echo "
    track seqIdy$hap
    parent seqidy
    type bigBed 9
    shortLabel $hap
    longLabel ${sp}#$hap
    visibility dense
    bigDataUrl https://genomeark.s3.amazonaws.com/species/$sn/$sp/assembly_curated/repeats/seqIdy/$out.bb
    priority 25.$j" >> $sp.rep.trackDb.txt
    j=$((j+1))
  done
done
END

# Upload v1.1. Rename the prior seqIdy/ to seqIdy_v1.0 after editing the rep.trackDb.txt file.
for i in $(seq 1 6)
do
  sp=`sed -n ${i}p $path | awk '{print $1}'`
  sn=`sed -n ${i}p $path | awk '{print $3}'`
  sp_ver=${sp}_v2.0
  echo "Uploading $sp_ver"
  src=$IN/$sp
  aws s3 --profile=vgp cp --recursive --exclude "*" --include "chr*.bb" $src s3://genomeark/species/$sn/$sp/assembly_curated/repeats/seqIdy_v1.1/
  sed -i "s/seqIdy\/$sp\./seqIdy_v1.1\//g" ../../T2Tgenomes/$sp_ver/rep.trackDb.txt

  # Move the prior seqIdy to seqIdy_v1.0
  aws s3 --profile=vgp mv --recursive s3://genomeark/species/$sn/$sp/assembly_curated/repeats/seqIdy/ s3://genomeark/species/$sn/$sp/assembly_curated/repeats/seqIdy_v1.0/
done

# CHM13
src=$IN/chm13
aws s3 cp --recursive --exclude "*" --include "chr*.bb" $src s3://human-pangenomics/T2T/browser/CHM13/bbi/seqIdy_v1.1/

sp=CHM13v2.0

# Acro
j=10
rm trackDb/$sp.rep.trackDb.txt
for hap in chr13 chr14 chr15 chr21 chr22 chrY
do
  echo $hap
  echo "
  track seqIdy$hap
  parent seqidyAcro
  shortLabel $hap
  longLabel $hap
  bigDataUrl https://s3-us-west-2.amazonaws.com/human-pangenomics/T2T/browser/CHM13/bbi/seqIdy_v1.1/$hap.bb
  priority 24.$j" >> trackDb/$sp.rep.trackDb.txt
  j=$((j+1))
done

# Non-Acro
j=30
for i in $(seq 1 12) $(seq 16 20) X
do
  hap="chr$i"
  echo $hap
  echo "
  track seqIdy$hap
  parent seqidy
  shortLabel $hap
  longLabel $hap
  bigDataUrl https://s3-us-west-2.amazonaws.com/human-pangenomics/T2T/browser/CHM13/bbi/seqIdy_v1.1/$hap.bb
  priority 24.$j" >> trackDb/$sp.rep.trackDb.txt
  j=$((j+1))
done
