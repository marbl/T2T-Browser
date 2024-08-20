#!/bin/sh

module load ucsc
module load aws

database="T2T-CHM13v2.0"
sizes=../../T2Tgenomes/$database/chm13v2.0.sizes
ref=chm13v2

set -e

for qry in hg19 grch38
do
  in=${ref}-${qry}
  out=${qry}_to_$ref

  set -x
  hgLoadChain -noBin -test $database bigChain $in.chain
  # This step creates chain.tab and link.tab

  # Create bigChain.bb
  sed 's/\.000000//' chain.tab |\
  awk 'BEGIN {OFS="\t"} {print $2, $4, $5, $11, 1000, $8, $3, $6, $7, $9, $10, $1}' > ${out}.bigChain
  bedToBigBed -type=bed6+6 -as=../../misc/bigChain.as -tab ${out}.bigChain $sizes ${out}.bigChain.bb

  # Create bigChain.link.bb
  awk 'BEGIN {OFS="\t"} {print $1, $2, $3, $5, $4}' link.tab > bigChain.bigLink
  bedSort bigChain.bigLink bigChain.bigLink.sort
  bedToBigBed -type=bed4+1 -as=../../misc/bigLink.as -tab bigChain.bigLink.sort $sizes ${out}.bigChain.link.bb

  # Upload to aws
  aws s3 cp --no-progress ${out}.bigChain.bb      s3://human-pangenomics/T2T/browser/CHM13/bbi/${out}.bigChain.bb
  aws s3 cp --no-progress ${out}.bigChain.link.bb s3://human-pangenomics/T2T/browser/CHM13/bbi/${out}.bigChain.link.bb

  # Clean up intermediate files
  rm bigChain.bigLink bigChain.bigLink.sort link.tab chain.tab $out.bigChain
  set +x
done
