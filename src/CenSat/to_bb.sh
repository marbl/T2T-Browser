#!/bin/sh

module load ucsc
module load aws
module load python

path=path.txt

ver=v1.2 #v1.1

for i in $(seq 1 5)
do
  sp=`sed -n ${i}p $path | awk '{print $1}'`
  nn=`sed -n ${i}p $path | awk '{print $2}'`
  sn=`sed -n ${i}p $path | awk '{print $3}'`

  ## v0.1
  ## cat $nn/${nn}.cenSatv0.1.bed | awk '$1!="track"' > ${sp}_v2.0_CenSat_v0.1.bed

  ## v1.1 - recoloring
  #cat $nn/${nn}_rm.cenSatv1.0.bed | awk '$1!="track"' | java -jar -Xmx256m ../../../src/txtReplaceWords.jar recolor.map - 9 > ${sp}_v2.0_CenSat_${ver}.bed
  #python fix_rDNA_gap.py ${sp}_v2.0_CenSat_${ver}.bed > ${sp}_v2.0_CenSat_${ver}.rDNAfix.bed
  #bedToBigBed -type=bed9 -tab ${sp}_v2.0_CenSat_${ver}.rDNAfix.bed ../../../T2Tgenomes/${sp}_v2.0/${sp}_v2.0.sizes ${sp}_v2.0_CenSat_${ver}.rDNAfix.bb
  #aws s3 cp --profile=vgp ${sp}_v2.0_CenSat_${ver}.rDNAfix.bb s3://genomeark/species/$sn/$sp/assembly_curated/repeats/
  aws s3 cp --profile=vgp ${nn}/${nn}_rm.cenSat${ver}.bb s3://genomeark/species/$sn/$sp/assembly_curated/repeats/${sp}_v2.0_CenSat_${ver}.bb

  ## cat $nn/${nn}_rm.cenSatStrandv0.1.bed | awk '$1!="track" {print $1"\t"$2"\t"$3-2"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8-2"\t"$9}' > ${sp}_v2.0_CenSatStrand_v0.1.bed
  ## bedToBigBed -type=bed9 -tab ${sp}_v2.0_CenSatStrand_v0.1.bed ../../../T2Tgenomes/${sp}_v2.0/${sp}_v2.0.sizes ${sp}_v2.0_CenSatStrand_${ver}.bb
  # Uploading v1.0 as they are as v1.1
  aws s3 cp --profile=vgp ${nn}/${nn}_rm.cenSatStrand${ver}.bb s3://genomeark/species/$sn/$sp/assembly_curated/repeats/${sp}_v2.0_CenSatStrand_${ver}.bb
done

# For mSynSyn1_2.1
for i in 6
do
  sp=`sed -n ${i}p $path | awk '{print $1}'`
  nn=`sed -n ${i}p $path | awk '{print $2}'`
  sn=`sed -n ${i}p $path | awk '{print $3}'`

  set -x
  
  ## v0.1
  ## cat $nn/${nn}.cenSatv0.1.bed | awk '$1!="track"' > ${sp}_v2.0_CenSat_v0.1.bed

  ## v1.1
  ##cat $nn/${nn}_rm.cenSatv1.0.bed | awk '$1!="track"' | java -jar -Xmx256m ../../../src/txtReplaceWords.jar recolor.map - 9 > ${sp}_v2.1_CenSat_${ver}.bed
  ##bedToBigBed -type=bed9 -tab ${sp}_v2.1_CenSat_${ver}.bed ../../../T2Tgenomes/${sp}_v2.1/${sp}_v2.1.sizes ${sp}_v2.1_CenSat_${ver}.bb
  ##aws s3 cp --profile=vgp ${sp}_v2.1_CenSat_${ver}.bb s3://genomeark/species/$sn/$sp/assembly_curated/repeats/

  ## v1.1 rDNA fix
  #java -jar -Xmx256m ../../../src/txtReplaceWords.jar ${sp}_v2.1_to_v2.0.txt ${sp}_v2.1_CenSat_${ver}.bed 1 > ${sp}_v2.0_CenSat_${ver}.bed
  #python fix_rDNA_gap.py ${sp}_v2.0_CenSat_${ver}.bed > ${sp}_v2.0_CenSat_${ver}.rDNAfix.bed
  #bedToBigBed -type=bed9 -tab ${sp}_v2.0_CenSat_${ver}.rDNAfix.bed ../../../T2Tgenomes/${sp}_v2.0/${sp}_v2.0.sizes ${sp}_v2.0_CenSat_${ver}.rDNAfix.bb
  #aws s3 cp --profile=vgp ${sp}_v2.0_CenSat_${ver}.rDNAfix.bb s3://genomeark/species/$sn/$sp/assembly_curated/repeats/
  aws s3 cp --profile=vgp ${nn}/${nn}_rm.cenSat${ver}.bb s3://genomeark/species/$sn/$sp/assembly_curated/repeats/${sp}_v2.1_CenSat_${ver}.bb

  ## Make track for v2.0 assembly: swap chr12 and chr19
  java -jar -Xmx256m ../../../src/txtReplaceWords.jar ${sp}_v2.1_to_v2.0.txt ${nn}/${nn}_rm.cenSat${ver}.bed 1 | grep -v "track" > ${sp}_v2.0_CenSat_${ver}.bed
  bedToBigBed -type=bed9 -tab ${sp}_v2.0_CenSat_${ver}.bed ../../../T2Tgenomes/${sp}_v2.0/${sp}_v2.0.sizes ${sp}_v2.0_CenSat_${ver}.bb
  aws s3 cp --profile=vgp ${sp}_v2.0_CenSat_${ver}.bb s3://genomeark/species/$sn/$sp/assembly_curated/repeats/${sp}_v2.0_CenSat_${ver}.bb

  ## v0.1 Strand
  ## cat $nn/${nn}_rm.cenSatStrandv0.1.bed | awk '$1!="track" {print $1"\t"$2"\t"$3-2"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8-2"\t"$9}' > ${sp}_v2.0_CenSatStrand_v0.1.bed
  ## bedToBigBed -type=bed9 -tab ${sp}_v2.0_CenSatStrand_v0.1.bed ../../../T2Tgenomes/${sp}_v2.0/${sp}_v2.0.sizes ${sp}_v2.0_CenSatStrand_${ver}.bb
  
  # Uploading v1.0 as they are as v1.1
  #aws s3 cp --profile=vgp ${sp}_v2.0_CenSatStrand_v0.1.bb s3://genomeark/species/$sn/$sp/assembly_curated/repeats/
  #aws s3 cp --profile=vgp ${nn}/${nn}_rm.cenSatStrandv1.0.bb s3://genomeark/species/$sn/$sp/assembly_curated/repeats/${sp}_v2.1_CenSatStrand_v1.1.bb
  aws s3 cp --profile=vgp ${nn}/${nn}_rm.cenSatStrand${ver}.bb s3://genomeark/species/$sn/$sp/assembly_curated/repeats/${sp}_v2.1_CenSatStrand_${ver}.bb

  ## Make track for v2.0 assembly
  java -jar -Xmx256m ../../../src/txtReplaceWords.jar ${sp}_v2.1_to_v2.0.txt ${nn}/${nn}_rm.cenSatStrand${ver}.bed 1 | grep -v "track" > ${sp}_v2.0_CenSatStrand_${ver}.bed
  bedToBigBed -type=bed9 -tab ${sp}_v2.0_CenSatStrand_${ver}.bed ../../../T2Tgenomes/${sp}_v2.0/${sp}_v2.0.sizes ${sp}_v2.0_CenSatStrand_${ver}.bb
  aws s3 cp --profile=vgp ${sp}_v2.0_CenSatStrand_${ver}.bb s3://genomeark/species/$sn/$sp/assembly_curated/repeats/${sp}_v2.0_CenSatStrand_${ver}.bb

  set +x
done

