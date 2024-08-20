# wfmash chain files

wfmash v0.14.0 chain files were downloaded from [Garrison lab S3](https://garrisonlab.s3.amazonaws.com/index.html?prefix=t2t-primates/wfmash-v0.13.0/chains/).

```shell
# Download
aws s3 cp --no-sign-request --recursive --exclude "*" --include "HPRCy1*.chain.gz" s3://garrisonlab/t2t-primates/wfmash-v0.13.0/chains/ .

# Unzip
pigz -d *.chain.gz
```

## Binary format of the chain files
Each chain file was generated using the pan-genome accessions (genome#hap#sequence), by aligning all query sequences to the reference.

Unfortunately, the files couldn't be used directly for 2 reasons:
  * genome#hap# part is not compatible with the browser hub
  * We want each haplotype to be shown as its own track

Therefore, each track has been split with the genome#hap# part stripped out.

```shell
for chain in $(ls HPRCy1*.chain)
do
  python split_by_genome.py $chain
done
```

Both HG002 and hg002 exists in the output files - HG002 is the HPRCy1 version, while hg002 is the T2T-HG002v1.0.1 version.

Let's make the HPRCy1 bigChain tracks for T2T-CHM13v2.0. Following https://genome.ucsc.edu/goldenPath/help/bigChain.html, bigChain.as and bigLink.as has been downloaded and saved under `../../misc`.

```shell
module load ucsc
module load aws

ref=chm13
database=T2T-CHM13v2.0 # Match the hub genome name under T2Tgenomes/
sizes=../../T2Tgenomes/$database/chm13v2.0.sizes

for qry in $(ls HG*_to_$ref.chain NA*_to_$ref.chain | awk -F "_" '{print $1}')
do
	in=${qry}_to_${ref}
	out=${qry}_to_CHM13v2.0
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
	aws s3 cp ${out}.bigChain.bb      s3://human-pangenomics/T2T/browser/CHM13/bbi/wfmash_v0.13.0_HPRCy1/
	aws s3 cp ${out}.bigChain.link.bb s3://human-pangenomics/T2T/browser/CHM13/bbi/wfmash_v0.13.0_HPRCy1/

	# Clean up intermediate files
	rm bigChain.bigLink bigChain.bigLink.sort link.tab chain.tab $out.bigChain
done
```

## Primates
Repeat the same procedure for the primates. Both haplotypes has to be run with `split_by_genome.py` before proceeding to the next genome. The script creates files per genome and concatenates when the same file already exists. This helps to create merged tracks for the diploid genome in one shot.

```shell
module load ucsc
module load aws

path=../path.txt
for i in $(seq 1 1)
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
  done

  # Clean up chain files
  rm HG*_to_$sp.chain NA*_to_$sp.chain
done
```

## trackDb.txt
Now, we need to create the corresponding trackDb.txt to go under group Comparative Genomics.
```shell
python make_trackDb.py > HPRCy1.trackDb.txt
```
This script uses trackTemplate_hprc_to_chm13.txt for the WFMASH-HPRCy1 tracks, replacing variables as needed.