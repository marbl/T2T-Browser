#!/bin/bash

module load python
module load ucsc

python gff3ToExtra.py chm13v2.0_RefSeq_Liftoff_v5.1.gff3

gff3ToGenePred -allowMinimalGenes -processAllGeneChildren -bad=failed -warnAndContinue chm13v2.0_RefSeq_Liftoff_v5.1.gff3 chm13v2.0_curGene.useId.genePred

genePredToBigGenePred \
 -colors=chm13v2.0_RefSeq_Liftoff_v5.1.colors.txt \
 -geneType=chm13v2.0_RefSeq_Liftoff_v5.1.geneType.txt \
 chm13v2.0_curGene.useId.genePred stdout | sort -k1,1V -k2,2n > chm13v2.0_curGene.bgpInput

bedToBigBed -type=bed12+8 -tab -as=bigGenePred.as \
 chm13v2.0_curGene.bgpInput \
 ../browser/T2T-CHM13v2.0/chm13v2.0.sizes \
 chm13v2.0_curGene.bb
