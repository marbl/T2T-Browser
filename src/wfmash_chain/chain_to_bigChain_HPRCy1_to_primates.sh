#!/bin/sh

module load ucsc
module load aws

path=../path.txt
for i in $(seq 1 6)
do
  set -x
  sp=`sed -n ${i}p $path | awk '{print $1}'`
  sn=`sed -n ${i}p $path | awk '{print $3}'`

  if [[ -s HPRCy1-vs-${sp}#M.p70.aln.chain ]]; then
    # For mGorGor1 and mPanPan1
    python split_by_genome.py HPRCy1-vs-${sp}#M.p70.aln.chain
    python split_by_genome.py HPRCy1-vs-${sp}#P.p70.aln.chain
  else
    # For the rest
    python split_by_genome.py HPRCy1-vs-${sp}#1.p70.aln.chain
    python split_by_genome.py HPRCy1-vs-${sp}#2.p70.aln.chain
  fi
  set +x

  database=${sp}_v2.0
  sizes=../../T2Tgenomes/$database/$database.sizes
  ref=$sp

  for qry in $(ls HG*_to_$sp.chain NA*_to_$sp.chain | awk -F "_" '{print $1}')
  do
    in=${qry}_to_${sp}
    out=${qry}_to_$database

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
    aws s3 --profile=vgp cp --no-progress ${out}.bigChain.bb s3://genomeark/species/$sn/$sp/assembly_curated/comparative/wfmash_v0.13.0_HPRCy1/${out}.bigChain.bb
	  aws s3 --profile=vgp cp --no-progress ${out}.bigChain.link.bb s3://genomeark/species/$sn/$sp/assembly_curated/comparative/wfmash_v0.13.0_HPRCy1/${out}.bigChain.link.bb

    # Clean up intermediate files
    rm bigChain.bigLink bigChain.bigLink.sort link.tab chain.tab $out.bigChain
    set +x
  done

  # Clean up chain files
  rm HG*_to_$sp.chain NA*_to_$sp.chain
done

