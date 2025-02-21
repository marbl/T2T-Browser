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

For the alignments between the primate genomes, the following was run.
```shell
module load ucsc
module load aws

path=../path.txt
for i in $(seq 1 2)
do
  set -x
  sp=`sed -n ${i}p $path | awk '{print $1}'`
  sn=`sed -n ${i}p $path | awk '{print $3}'`
  
  # For mGorGor1 and mPanPan1
  python split_by_genome.py ${sp}#M.p70.aln.chain
  python split_by_genome.py ${sp}#P.p70.aln.chain
  
  # For the rest
  # python split_by_genome.py ${sp}#1.p70.aln.chain
  # python split_by_genome.py ${sp}#2.p70.aln.chain

  # Following https://genome.ucsc.edu/goldenPath/help/bigChain.html
  SIZE=${sp}_v2.0.sizes
  ln -s ../../browser/${sp}_v2.0/$SIZE
  set +x
done

# rename to clear off the naming
rename -v chm13hap1 CHM13 chm13hap1*
rename -v grch38hap1 GRCh38 grch38hap1*
rename -v hg002 HG002 hg002*_to_*.chain
rename -v hapM mat *hapM_to_*.chain
rename -v hapP pat *hapP_to_*.chain

ver=v0.13.0
path=../path.txt
for i in $(seq 1 6)
do 
  for qry in CHM13 GRCh38 HG002mat HG002pat mGorGor1mat mGorGor1pat mPanPan1mat mPanPan1pat mPanTro3hap1 mPanTro3hap2 mPonAbe1hap1 mPonAbe1hap2 mPonPyg2hap1 mPonPyg2hap2 mSymSyn1hap1 mSymSyn1hap2
  do
    sp=`sed -n ${i}p $path | awk '{print $1}'`
    sn=`sed -n ${i}p $path | awk '{print $3}'`
    out=${qry}_to_${sp}
    echo "===${out}==="
    
    # This step generates chain.tab and link.tab
    hgLoadChain -noBin -test ${sp}_v2.0 bigChain $out.chain

    sed 's/\.000000//' chain.tab | awk 'BEGIN {OFS="\t"} {print $2, $4, $5, $11, 1000, $8, $3, $6, $7, $9, $10, $1}' > ${out}_v2.0.bigChain
    bedToBigBed -type=bed6+6 -as=bigChain.as -tab ${out}_v2.0.bigChain ${sp}_v2.0.sizes ${out}_v2.0.bigChain.bb

    awk 'BEGIN {OFS="\t"} {print $1, $2, $3, $5, $4}' link.tab > bigChain.bigLink
    
    bedSort bigChain.bigLink bigChain.bigLink.sort
    bedToBigBed -type=bed4+1 -as=bigLink.as -tab bigChain.bigLink.sort ${sp}_v2.0.sizes ${out}_v2.0.bigChain.link.bb
    
    # Upload
    aws s3 --profile=vgp cp ${out}_v2.0.bigChain.bb s3://genomeark/species/$sn/$sp/assembly_curated/comparative/${out}_v2.0.wfmash_$ver.bigChain.bb
    aws s3 --profile=vgp cp ${out}_v2.0.bigChain.link.bb s3://genomeark/species/$sn/$sp/assembly_curated/comparative/${out}_v2.0.wfmash_$ver.bigChain.link.bb    
    rm bigChain.bigLink bigChain.bigLink.sort link.tab chain.tab
  done
done
```

## trackDb.txt
Now, we need to create the corresponding trackDb.txt to go under group Comparative Genomics.
```shell
python make_trackDb.py
```
This script uses `trackTemplate_hprc_to_chm13.txt` for the WFMASH-HPRCy1 tracks for CHM13, replacing variables as needed.
Output file for CHM13 trackDb.txt will be `HPRCy1.CHM13.trackDb.txt`.

Primates use `trackTemplate_hprc_to_primates.txt`, output files written as `HPRCy1.${sp}.trackDb.txt`.

Add group definition to com.trackDb.txt:
```
track wfmashHPRCy1
superTrack on
visibility dense
shortLabel WFMASH-HPRCy1
longLabel wfmash v0.13.0 HPRCy1
group compGeno
type bigChain
mouseOverField name
html https://raw.githubusercontent.com/T2T-apes/ape_pangenome/main/alignment/wfmash.html
priority 230
```

Append to com.trackDb.txt and move hal.trackDb.txt to the end
```shell
for sp in mPanPan1 mPanTro3 mPonAbe1 mPonPyg2 mSymSyn1
do
  cat HPRCy1.${sp}.trackDb.txt >> ../../T2Tgenomes/${sp}_v2.0/com.trackDb.txt
done
```

## Tracks for CHM13 and HG002 hubs
```shell
# Extract chains
python split_by_genome.py chm13#1.p70.aln.chain
python split_by_genome.py hg002#M.p70.aln.chain
python split_by_genome.py hg002#P.p70.aln.chain

# Rename
rename -v chm13hap1 CHM13 chm13hap1*
rename -v grch38hap1 GRCh38 grch38hap1*
rename -v hg002 HG002 hg002*_to_*.chain
rename -v hapM mat *hapM_to_*.chain
rename -v hapP pat *hapP_to_*.chain
rename -v chm13 CHM13 *_to_chm13.chain
rename -v hg002 HG002 *_to_hg002.chain

sp=CHM13
ref=chm13v2.0
# No CHM13 self qry
for qry in GRCh38 HG002mat HG002pat mGorGor1mat mGorGor1pat mPanPan1mat mPanPan1pat mPanTro3hap1 mPanTro3hap2 mPonAbe1hap1 mPonAbe1hap2 mPonPyg2hap1 mPonPyg2hap2 mSymSyn1hap1 mSymSyn1hap2
do
    out=${qry}_to_${sp}
    echo "===${out}==="
    
    # This step generates chain.tab and link.tab
    hgLoadChain -noBin -test $ref bigChain $out.chain

    sed 's/\.000000//' chain.tab | awk 'BEGIN {OFS="\t"} {print $2, $4, $5, $11, 1000, $8, $3, $6, $7, $9, $10, $1}' > ${out}.bigChain
    bedToBigBed -type=bed6+6 -as=bigChain.as -tab ${out}.bigChain $ref.sizes ${out}.bigChain.bb

    awk 'BEGIN {OFS="\t"} {print $1, $2, $3, $5, $4}' link.tab > bigChain.bigLink
    
    bedSort bigChain.bigLink bigChain.bigLink.sort
    bedToBigBed -type=bed4+1 -as=bigLink.as -tab bigChain.bigLink.sort $ref.sizes ${out}.bigChain.link.bb
    
    # Upload
    aws s3 cp ${out}.bigChain.bb s3://human-pangenomics/T2T/$sp/browser/bbi/wfmash_$ver.${qry}.bigChain.bb
    aws s3 cp ${out}.bigChain.link.bb s3://human-pangenomics/T2T/$sp/browser/bbi/wfmash_$ver.${qry}.bigChain.link.bb
    rm bigChain.bigLink bigChain.bigLink.sort link.tab chain.tab
done

## For HG002
sp=HG002
ref=hg002v1.0
ln -s /data/Phillippy2/projects/HG002_diploid/assembly_hub/v1.0/nhgri_hub/hg002v1.0/v1.0.sizes hg002v1.0.sizes

for qry in CHM13 HG002mat HG002pat GRCh38 mGorGor1mat mGorGor1pat mPanPan1mat mPanPan1pat mPanTro3hap1 mPanTro3hap2 mPonAbe1hap1 mPonAbe1hap2 mPonPyg2hap1 mPonPyg2hap2 mSymSyn1hap1 mSymSyn1hap2
do
    out=${qry}_to_${sp}
    echo "===${out}==="
    
    # This step generates chain.tab and link.tab
    hgLoadChain -noBin -test $ref bigChain $out.chain

    sed 's/\.000000//' chain.tab | awk 'BEGIN {OFS="\t"} {print $2, $4, $5, $11, 1000, $8, $3, $6, $7, $9, $10, $1}' > ${out}.bigChain
    bedToBigBed -type=bed6+6 -as=bigChain.as -tab ${out}.bigChain $ref.sizes ${out}.bigChain.bb

    awk 'BEGIN {OFS="\t"} {print $1, $2, $3, $5, $4}' link.tab > bigChain.bigLink
    
    bedSort bigChain.bigLink bigChain.bigLink.sort
    bedToBigBed -type=bed4+1 -as=bigLink.as -tab bigChain.bigLink.sort $ref.sizes ${out}.bigChain.link.bb
    
    # Upload
    aws s3 cp ${out}.bigChain.bb s3://human-pangenomics/T2T/$sp/assemblies/annotation/browserchains/wfmash_$ver/${qry}.bigChain.bb
    aws s3 cp ${out}.bigChain.link.bb s3://human-pangenomics/T2T/$sp/assemblies/annotation/browserchains/wfmash_$ver/${qry}.bigChain.link.bb
    rm bigChain.bigLink bigChain.bigLink.sort link.tab chain.tab
done
```