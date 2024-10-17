#!/bin/bash

module load python
module load ucsc

if [[ $# -lt 3 ]]; then
  echo "Usage: ./gff_to_bb.sh in.gff genome.size out"
  echo "  in.gff       GFF input file"
  echo "  genome.size  size file as in T2Tgenomes/<genome>/<genome>.sizes"
  echo "  out          output prefix"
  exit 0
fi

GFF=$1 # chm13v2.0_RefSeq_Liftoff_v5.2.gff3
COL=${GFF/.gff3/.colors.txt}
TYP=${GFF/.gff3/.geneType.txt}
SYN=${GFF/.gff3/.geneNames.txt}
SIZE=$2 # ../../T2Tgenomes/T2T-CHM13v2.0/chm13v2.0.sizes
OUT=$3 # chm13v2.0_RefSeq_Liftoff_v5.2

if [[ ! -s $GFF ]]; then
  echo "$GFF: File empty or does not exist."
  exit -1
fi

set -e
set -x
python gff3ToExtra.py $GFF

gff3ToGenePred -allowMinimalGenes -processAllGeneChildren \
 -bad=failed -warnAndContinue $GFF stdout |\
 sort -k2,2V -k4,4n - > $OUT.gp

genePredToBigGenePred \
 -colors=$COL -geneType=$TYP -geneNames=$SYN $OUT.gp $OUT.bed

bedToBigBed -extraIndex=name,name2 -type=bed12+8 -tab -as=../../misc/bigGenePred.as \
 $OUT.bed $SIZE $OUT.bb

# Make it searchable:
cat $OUT.bed | awk '{print $4, $17, $18}' > input.txt
ixIxx input.txt $OUT.ix $OUT.ixx

set +x
