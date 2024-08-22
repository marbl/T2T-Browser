#!/bin/sh

module load aws
module load ucsc

# Download from aws
aws s3 cp --no-sign-request --recursive s3://garrisonlab/t2t-primates/wfmash-v0.13.0/conservation/approach1/chm13_1/elements/ .
aws s3 cp --no-sign-request --recursive --exclude "*" --include "*.wig" s3://garrisonlab/t2t-primates/wfmash-v0.13.0/conservation/approach1/chm13_1/scores/ .

# chr13 contains duplicated lines. we need to remove them. :(
sed 's/chm13#1#//g' *.bed | awk '{if ($0!=line) { print $0 } line=$0;}' > approach1.most_conserved_v0.1.bed
java -jar -Xmx256m ../../../src/bedToSparseWig.jar approach1.most_conserved_v0.1.bed Approach1 5 > approach1.most_conserved_v0.1.wig
wigToBigWig approach1.most_conserved_v0.1.wig ../../../T2Tgenomes/T2T-CHM13v2.0/chm13v2.0.sizes approach1.most_conserved_v0.1.bw

# bedToBigBed -type=bed6 -tab approach1.most_conserved_v0.1.bed ../../T2Tgenomes/T2T-CHM13v2.0/chm13v2.0.sizes approach1.most_conserved_v0.1.bb
# Max score is 808500

cat *.scores.wig | sed 's/chm13#1#//g' > approach1.scores_v0.1.wig

# Used 33GB mem. Submit as a job with 48g mem
wigToBigWig approach1.scores_v0.1.wig ../../../T2Tgenomes/T2T-CHM13v2.0/chm13v2.0.sizes approach1.scores_v0.1.bw

# Upload
aws s3 cp approach1.most_conserved_v0.1.bw s3://human-pangenomics/T2T/browser/CHM13/bbi/
aws s3 cp approach1.scores_v0.1.bw s3://human-pangenomics/T2T/browser/CHM13/bbi/