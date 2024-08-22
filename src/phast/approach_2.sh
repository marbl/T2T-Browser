#!/bin/sh

module load aws

# Download from aws
#aws s3 cp --no-sign-request --recursive s3://garrisonlab/t2t-primates/wfmash-v0.13.0/conservation/approach2/chm13_1/elements/ .
aws s3 cp --no-sign-request --recursive --exclude "*" --include "*.wig" s3://garrisonlab/t2t-primates/wfmash-v0.13.0/conservation/approach2/chm13_1/scores/ .

# Approach 2 most_conserved scores are all 0
sed 's/chm13#1#//g' *.bed | cut -f1-3 > approach2.most_conserved_v0.1.bed
# java -jar -Xmx256m ../../../src/bedToSparseWig.jar approach2.most_conserved_v0.1.bed Approach1 5 > approach2.most_conserved_v0.1.wig
bedToBigBed -type=bed3 -tab approach2.most_conserved_v0.1.bed ../../../T2Tgenomes/T2T-CHM13v2.0/chm13v2.0.sizes approach2.most_conserved_v0.1.bb

cat *.scores.wig | sed 's/chm13#1#//g' > approach2.scores_v0.1.wig
wigToBigWig approach2.scores_v0.1.wig ../../../T2Tgenomes/T2T-CHM13v2.0/chm13v2.0.sizes approach2.scores_v0.1.original.bw
# Before compression:
# -rw-rw-r-- 1 rhiea Phillippy 7.3G Aug 21 22:29 approach2.scores_v0.1.original.bw

# Let's try with compression
java -jar -Xmx256m ../../../src/wigCompress.jar approach2.scores_v0.1.wig > approach2.scores_v0.1.compress.wig
wigToBigWig approach2.scores_v0.1.compress.wig ../../../T2Tgenomes/T2T-CHM13v2.0/chm13v2.0.sizes approach2.scores_v0.1.bw

# Upload
aws s3 cp approach2.most_conserved_v0.1.bb s3://human-pangenomics/T2T/browser/CHM13/bbi/
aws s3 cp approach2.scores_v0.1.original.bw s3://human-pangenomics/T2T/browser/CHM13/bbi/approach2.scores_v0.1.bw