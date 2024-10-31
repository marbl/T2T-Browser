# PHAST conservation elements and scores

## Original data

* Updated version received on Oct. 24, 2024 - from [here](https://garrisonlab.s3.amazonaws.com/index.html?prefix=t2t-primates/wfmash-v0.13.0/conservation/approach2_with_cds_all_chroms_together/chm13_1/). Keeping as approach2_v0.2
* Updated version received on Oct. 30, 2024 - keeping as approach2_v0.3
  >Elements: https://garrisonlab.s3.amazonaws.com/t2t-primates/wfmash-v0.13.0/conservation/approach2_with_cds/chm13_1/elements/approach2.most_conserved_v0.3.bb
  >Scores: https://garrisonlab.s3.amazonaws.com/t2t-primates/wfmash-v0.13.0/conservation/approach2_with_cds/chm13_1/scores/approach2.scores_v0.3.bw

## Approach2 v0.3
Upload as-is on aws genomeark
```shell
module load aws

mkdir approach2_v0.3 & cd approach2_v0.3

aws s3 cp --no-sign-request s3://garrisonlab/t2t-primates/wfmash-v0.13.0/conservation/approach2_with_cds/chm13_1/elements/approach2.most_conserved_v0.3.bb .
aws s3 cp --no-sign-request s3://garrisonlab/t2t-primates/wfmash-v0.13.0/conservation/approach2_with_cds/chm13_1/scores/approach2.scores_v0.3.bw .

aws s3 cp approach2.most_conserved_v0.3.bb s3://human-pangenomics/T2T/browser/CHM13/bbi/
aws s3 cp approach2.scores_v0.3.bw s3://human-pangenomics/T2T/browser/CHM13/bbi/
```


## Approach2 v0.2
```shell
# under incoming/phast/
mkdir approach2_update && cd approach2_update

module load aws

# Scores
aws s3 cp --no-sign-request --recursive --exclude "*.bw" s3://garrisonlab/t2t-primates/wfmash-v0.13.0/conservation/approach2_with_cds_all_chroms_together/chm13_1/scores/ .

cat *.scores.wig | sed 's/chm13#1#//g' > approach2.scores_v0.2.wig
rm *.scores.wig

module load ucsc
wigToBigWig approach2.scores_v0.2.wig ../../../T2Tgenomes/T2T-CHM13v2.0/chm13v2.0.sizes approach2.scores_v0.2.bw

# Upload
aws s3 cp approach2.scores_v0.2.bw s3://human-pangenomics/T2T/browser/CHM13/bbi/

# Elements
aws s3 cp --no-sign-request --recursive s3://garrisonlab/t2t-primates/wfmash-v0.13.0/conservation/approach2_with_cds_all_chroms_together/chm13_1/elements/ .
sed 's/chm13#1#//g' *.bed | cut -f1-4 > approach2.most_conserved_v0.2.bed

bedToBigBed -type=bed4 -tab approach2.most_conserved_v0.2.bed ../../../T2Tgenomes/T2T-CHM13v2.0/chm13v2.0.sizes approach2.most_conserved_v0.2.bb
rm *.most_conserved.bed

aws s3 cp approach2.most_conserved_v0.2.bb s3://human-pangenomics/T2T/browser/CHM13/bbi/
```
Most Conserved Element: https://s3-us-west-2.amazonaws.com/human-pangenomics/T2T/browser/CHM13/bbi/approach2.most_conserved_v0.2.bb
Scores: https://s3-us-west-2.amazonaws.com/human-pangenomics/T2T/browser/CHM13/bbi/approach2.scores_v0.2.bw

* Original data downloaded from [GarrisonLab](https://garrisonlab.s3.amazonaws.com/index.html?prefix=t2t-primates/wfmash-v0.13.0/), `conservation`.



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

## Approach 1 v0.1
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

#### Scores v0.1
Concatenate to one file and upload.
```shell
cat *.scores.wig | sed 's/chm13#1#//g' > approach1.scores_v0.1.wig

# Used 33GB mem. This was submitted as a job with 48g mem
wigToBigWig approach1.scores_v0.1.wig ../../../T2Tgenomes/T2T-CHM13v2.0/chm13v2.0.sizes approach1.scores_v0.1.bw

# Upload
aws s3 cp approach1.scores_v0.1.bw s3://human-pangenomics/T2T/browser/CHM13/bbi/
```

## Approach 2 v0.1
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
