#!/bin/sh

module load ucsc
module load aws

path=../../path.txt

# Data received from globus:
# primate_T2T/repeats/TrackFiles/
# Symlinked under incoming/RM/
# Extracted with tar xvf, creates directory forArang
# cd forArang

# For the non-trio genomes, v1.1
for i in $(seq 3 6)
do
  sp=`sed -n ${i}p $path | awk '{print $1}'`
  ss=`sed -n ${i}p $path | awk '{print $2}'`
  sn=`sed -n ${i}p $path | awk '{print $3}'`

  echo "Make ${sp}_v2.0.RepeatMasker_v1.1.bed"
  bigBedToBed ${ss}_hap1.bb ${ss}_hap1.bed
  bigBedToBed ${ss}_hap2.bb ${ss}_hap2.bed
  cat ${ss}_hap1.bed >  ${sp}_v2.0.RepeatMasker_v1.1.bed
  cat ${ss}_hap2.bed >> ${sp}_v2.0.RepeatMasker_v1.1.bed

  bedToBigBed -type=bed9+5 -as=bigRmskBed.as -tab ${sp}_v2.0.RepeatMasker_v1.1.bed ../../../T2Tgenomes/${sp}_v2.0/${sp}_v2.0.sizes ${sp}_v2.0.RepeatMasker_v1.1.bb

  # For .align.bb
  bigBedToBed ${ss}_hap1.align.bb ${ss}_hap1.align.bed
  bigBedToBed ${ss}_hap2.align.bb ${ss}_hap2.align.bed

  echo "Make ${sp}_v2.0.RepeatMasker_v1.1.align.bed"
  cat ${ss}_hap1.align.bed | LC_ALL=C sort -k1,1 -k2,2n - >  ${sp}_v2.0.RepeatMasker_v1.1.align.bed
  cat ${ss}_hap2.align.bed | LC_ALL=C sort -k1,1 -k2,2n - >> ${sp}_v2.0.RepeatMasker_v1.1.align.bed

  bedToBigBed -type=bed3+14 -as=bigRmskAlignBed.as -tab ${sp}_v2.0.RepeatMasker_v1.1.align.bed ../../../T2Tgenomes/${sp}_v2.0/${sp}_v2.0.sizes ${sp}_v2.0.RepeatMasker_v1.1.align.bb

  echo "Upload"
  aws s3 cp --profile=vgp ${sp}_v2.0.RepeatMasker_v1.1.bb s3://genomeark/species/$sn/$sp/assembly_curated/repeats/
  aws s3 cp --profile=vgp ${sp}_v2.0.RepeatMasker_v1.1.align.bb s3://genomeark/species/$sn/$sp/assembly_curated/repeats/

  # Fix Penelope to PLE, v1.2
  set -x
  echo "Rename Penelope for $sp"
  sed 's/LINE\/Penelope/PLE/g' ${sp}_v2.0.RepeatMasker_v1.1.bed > ${sp}_v2.0.RepeatMasker_v1.2.bed

  sed 's/LINE\/Penelope/PLE/g' ${sp}_v2.0.RepeatMasker_v1.1.align.bed > ${sp}_v2.0.RepeatMasker_v1.2.align.bed

  bedToBigBed -type=bed9+5 -as=bigRmskBed.as -tab ${sp}_v2.0.RepeatMasker_v1.2.bed ../../../T2Tgenomes/${sp}_v2.0/${sp}_v2.0.sizes ${sp}_v2.0.RepeatMasker_v1.2.bb

  bedToBigBed -type=bed3+14 -as=bigRmskAlignBed.as -tab ${sp}_v2.0.RepeatMasker_v1.2.align.bed ../../../T2Tgenomes/${sp}_v2.0/${sp}_v2.0.sizes ${sp}_v2.0.RepeatMasker_v1.2.align.bb

  echo "Upload"
  aws s3 cp --profile=vgp --no-progress ${sp}_v2.0.RepeatMasker_v1.2.bb       s3://genomeark/species/$sn/$sp/assembly_curated/repeats/
  aws s3 cp --profile=vgp --no-progress ${sp}_v2.0.RepeatMasker_v1.2.align.bb s3://genomeark/species/$sn/$sp/assembly_curated/repeats/
  set +x
done


# Fix mPanPan1 to use pri and alt, alt extracted from hap1 and hap2 (while waiting for alt)

for i in $(seq 2 2)
do
  set -x
  sp=`sed -n ${i}p $path | awk '{print $1}'`
  ss=`sed -n ${i}p $path | awk '{print $2}'`
  sn=`sed -n ${i}p $path | awk '{print $3}'`
  
  echo "Extract pri, hap1 and hap2"
  bigBedToBed PanPan_primary.bb PanPan_primary.bed
  bigBedToBed ${ss}_hap1.bb ${ss}_hap1.bed
  bigBedToBed ${ss}_hap2.bb ${ss}_hap2.bed
  
  echo "Extract alt chromosomes"
  java -jar -Xmx256m ../../../src/txtContains.jar PanPan_hap1.bed mPanPan1_alt_mat.list 1 > ${ss}_alt.bed
  java -jar -Xmx256m ../../../src/txtContains.jar PanPan_hap2.bed mPanPan1_alt_pat.list 1 >> ${ss}_alt.bed
  
  cat ${ss}_primary.bed | sed 's/LINE\/Penelope/PLE/g' >  ${sp}_v2.0.RepeatMasker_v1.2.bed
  cat ${ss}_alt.bed     | sed 's/LINE\/Penelope/PLE/g' >> ${sp}_v2.0.RepeatMasker_v1.2.bed

  bedToBigBed -type=bed9+5 -as=bigRmskBed.as -tab ${sp}_v2.0.RepeatMasker_v1.2.bed ../../../T2Tgenomes/${sp}_v2.0/${sp}_v2.0.sizes ${sp}_v2.0.RepeatMasker_v1.2.bb
  
  # For .align.bb
  bigBedToBed ${ss}_primary.align.bb ${ss}_primary.align.bed
  bigBedToBed ${ss}_hap1.align.bb ${ss}_hap1.align.bed
  bigBedToBed ${ss}_hap2.align.bb ${ss}_hap2.align.bed
  
  echo "Extract alt chromosomes"
  java -jar -Xmx256m ../../../src/txtContains.jar PanPan_hap1.align.bed mPanPan1_alt_mat.list 1 > ${ss}_alt.align.bed
  java -jar -Xmx256m ../../../src/txtContains.jar PanPan_hap2.align.bed mPanPan1_alt_pat.list 1 >> ${ss}_alt.align.bed
  cat ${ss}_primary.align.bed | sed 's/LINE\/Penelope/PLE/g' >  ${sp}_v2.0.RepeatMasker_v1.2.align.bed
  cat ${ss}_alt.align.bed     | sed 's/LINE\/Penelope/PLE/g' >> ${sp}_v2.0.RepeatMasker_v1.2.align.bed
  
  bedToBigBed -type=bed3+14 -as=bigRmskAlignBed.as -tab ${sp}_v2.0.RepeatMasker_v1.2.align.bed ../../../T2Tgenomes/${sp}_v2.0/${sp}_v2.0.sizes ${sp}_v2.0.RepeatMasker_v1.2.align.bb
  
  echo "Upload"
  aws s3 cp --profile=vgp ${sp}_v2.0.RepeatMasker_v1.2.bb       s3://genomeark/species/$sn/$sp/assembly_curated/repeats/
  aws s3 cp --profile=vgp ${sp}_v2.0.RepeatMasker_v1.2.align.bb s3://genomeark/species/$sn/$sp/assembly_curated/repeats/

  set +x
done
#END

# Received newer alt for mPanPan; hopefully this fixes it.
# Increasing version to v1.2.1

for i in $(seq 2 2)
do
  set -x
  sp=`sed -n ${i}p $path | awk '{print $1}'`
  ss=`sed -n ${i}p $path | awk '{print $2}'`
  sn=`sed -n ${i}p $path | awk '{print $3}'`
  
  echo "Extract pri, hap1 and hap2"
  #bigBedToBed PanPan_primary.bb PanPan_primary.bed
  bigBedToBed ${ss}_alt.bb ${ss}_alt.bed
  
  cat ${ss}_primary.bed | sed 's/LINE\/Penelope/PLE/g' >  ${sp}_v2.0.RepeatMasker_v1.2.1.bed
  cat ${ss}_alt.bed     | sed 's/LINE\/Penelope/PLE/g' >> ${sp}_v2.0.RepeatMasker_v1.2.1.bed

  bedToBigBed -type=bed9+5 -as=bigRmskBed.as -tab ${sp}_v2.0.RepeatMasker_v1.2.1.bed ../../../T2Tgenomes/${sp}_v2.0/${sp}_v2.0.sizes ${sp}_v2.0.RepeatMasker_v1.2.1.bb
  
  # For .align.bb
  # bigBedToBed ${ss}_primary.align.bb ${ss}_primary.align.bed
  bigBedToBed ${ss}_alt.align.bb ${ss}_alt.align.bed
  cat ${ss}_primary.align.bed | sed 's/LINE\/Penelope/PLE/g' >  ${sp}_v2.0.RepeatMasker_v1.2.1.align.bed
  cat ${ss}_alt.align.bed     | sed 's/LINE\/Penelope/PLE/g' >> ${sp}_v2.0.RepeatMasker_v1.2.1.align.bed
  
  bedToBigBed -type=bed3+14 -as=bigRmskAlignBed.as -tab ${sp}_v2.0.RepeatMasker_v1.2.1.align.bed ../../../T2Tgenomes/${sp}_v2.0/${sp}_v2.0.sizes ${sp}_v2.0.RepeatMasker_v1.2.1.align.bb
  
  echo "Upload"
  aws s3 cp --profile=vgp ${sp}_v2.0.RepeatMasker_v1.2.1.bb       s3://genomeark/species/$sn/$sp/assembly_curated/repeats/
  aws s3 cp --profile=vgp ${sp}_v2.0.RepeatMasker_v1.2.1.align.bb s3://genomeark/species/$sn/$sp/assembly_curated/repeats/

  set +x
done