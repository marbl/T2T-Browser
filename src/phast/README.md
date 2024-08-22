# PHAST conservation elements and scores

## Original data
Original data downloaded from [GarrisonLab](https://garrisonlab.s3.amazonaws.com/index.html?prefix=t2t-primates/wfmash-v0.13.0/), `conservation`.

```shell
#!/bin/sh

module load aws
module load ucsc

for app in approach1 approach2
do
  mkdir -p $app & cd $app
  # Download from aws
  aws s3 cp --no-sign-request --recursive s3://garrisonlab/t2t-primates/wfmash-v0.13.0/conservation/$app/chm13_1/elements/ .
  aws s3 cp --no-sign-request --recursive --exclude "*" --include "*.wig" s3://garrisonlab/t2t-primates/wfmash-v0.13.0/conservation/$app/chm13_1/scores/ .
  cd ../
done
```

## Approach 1
### Data processing
* chm13#1# was removed to make the file size smaller

#### Most conserved elements
Problems:
* Score in the most_conserved bed file was ranging up to 808,500. UCSC bed format requires score to be between 0 and 1,000.
* Chr13 contains duplicated lines. We need to remove them. :(

Scores were converted to values in wiggle format instead, with duplicated lines in chr13 removed.

```shell
# Most conserved elements
# bedToBigBed -type=bed6 -tab approach1.most_conserved_v0.1.bed ../../T2Tgenomes/T2T-CHM13v2.0/chm13v2.0.sizes approach1.most_conserved_v0.1.bb
# This complains and fails because max score is 808500

sed 's/chm13#1#//g' *.bed | awk '{if ($0!=line) { print $0 } line=$0;}' > approach1.most_conserved_v0.1.bed
java -jar -Xmx256m ../../../src/bedToSparseWig.jar approach1.most_conserved_v0.1.bed Approach1 5 > approach1.most_conserved_v0.1.wig
wigToBigWig approach1.most_conserved_v0.1.wig ../../../T2Tgenomes/T2T-CHM13v2.0/chm13v2.0.sizes approach1.most_conserved_v0.1.bw

# Upload
aws s3 cp approach1.most_conserved_v0.1.bw s3://human-pangenomics/T2T/browser/CHM13/bbi/
```
`TODO`: Need to follow up on how to display the score range.

#### Scores
Concatenate to one file and upload.
```shell
cat *.scores.wig | sed 's/chm13#1#//g' > approach1.scores_v0.1.wig

# Used 33GB mem. This was submitted as a job with 48g mem
wigToBigWig approach1.scores_v0.1.wig ../../../T2Tgenomes/T2T-CHM13v2.0/chm13v2.0.sizes approach1.scores_v0.1.bw

# Upload
aws s3 cp approach1.scores_v0.1.bw s3://human-pangenomics/T2T/browser/CHM13/bbi/
```

## Approach 2
### Data processing
* chm13#1# was removed to make the file size smaller

#### Most conserved elements
* Approach 2 most_conserved scores are all 0 - no need to convert scores to values

```shell
sed 's/chm13#1#//g' *.bed | cut -f1-3 > approach2.most_conserved_v0.1.bed
bedToBigBed -type=bed3 -tab approach2.most_conserved_v0.1.bed ../../../T2Tgenomes/T2T-CHM13v2.0/chm13v2.0.sizes approach2.most_conserved_v0.1.bb

aws s3 cp approach2.most_conserved_v0.1.bb s3://human-pangenomics/T2T/browser/CHM13/bbi/
```

#### Scores
* File size is a bit large
```shell
cat *.scores.wig | sed 's/chm13#1#//g' > approach2.scores_v0.1.wig
wigToBigWig approach2.scores_v0.1.wig ../../../T2Tgenomes/T2T-CHM13v2.0/chm13v2.0.sizes approach2.scores_v0.1.bw
# 7.3G approach2.scores_v0.1.bw

# Upload
aws s3 cp approach2.scores_v0.1.bw s3://human-pangenomics/T2T/browser/CHM13/bbi/approach2.scores_v0.1.bw
```

* Experimental - try with compression; seems like needs to be worked on. Postponding for now.
```shell
java -jar -Xmx256m ../../../src/wigCompress.jar approach2.scores_v0.1.wig > approach2.scores_v0.1.compress.wig
wigToBigWig approach2.scores_v0.1.compress.wig ../../../T2Tgenomes/T2T-CHM13v2.0/chm13v2.0.sizes approach2.scores_v0.1.compress.bw
# Error message: Extra start= setting line 1 of approach2.scores_v0.1.compress.wig
# Apparently, wiggle format doesn't like variableStep with start=
```
