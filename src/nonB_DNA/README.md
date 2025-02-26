# Non-B DNA

written by Linnea Smeds lbs5874@psu.edu
Files generated by Linnea Smeds and Kaivan Kamali

## Annotation
Non-B motifs of APR, DR, IR, MR, STR and Z were annotated by gfa (https://github.com/abcsFrederick/non-B_gfa), described in detail here: https://github.com/kxk302/non-B_gfa. TRI was added later.

G-quadruplexes were annotated with Quadron (https://github.com/aleksahak/Quadron/tree/master), using a docker image: https://github.com/kxk302/Quadron_Docker.

## Non-B abbreviations
* APR - A-phased repeats
* DR - Direct repeats 
* GQ - G-quadruplexes
* IR - Inverted repeats 
* MR - Mirror repeats
* TRI - Triplex repeats (subset of mirror repeats)
* STR - Short tandem repeats
* Z - Z-DNA


### Note
Gfa does not give a score for the non-B DNA motifs, but Quadron does for the GQs. These are not integers, but were rounded to the closest integer and added to the score column of the bedfile. The original scores from Quadron are found in the fourth bed column. "NA" and negative scores were filtered out. 

## Processing
Files received for pri.cur and alt.cur; need to merge pri + alt for the primates.

```shell
module load ucsc

path=../path.txt

for i in $(seq 1 5)
do
  sp=`sed -n ${i}p $path | awk '{print $1}'`
  sn=`sed -n ${i}p $path | awk '{print $3}'`
  dd=`sed -n ${i}p $path | awk '{print $7}'`
  
  for nonB in TRI # APR DR IR MR STR Z GQ
  do
    echo $sp
    set -x
    bigBedToBed nonB_DNA/$sp.pri.cur.$dd.$nonB.bb ${sp}_v2.0.pri.nonB_$nonB.bed
	  bigBedToBed nonB_DNA/$sp.alt.cur.$dd.$nonB.bb ${sp}_v2.0.alt.nonB_$nonB.bed
	  cat ${sp}_v2.0.pri.nonB_$nonB.bed ${sp}_v2.0.alt.nonB_$nonB.bed > ${sp}_v2.0.nonB_$nonB.bed
	  rm ${sp}_v2.0.pri.nonB_$nonB.bed ${sp}_v2.0.alt.nonB_$nonB.bed

    SIZE=../../T2Tgenomes/${sp}_v2.0/${sp}_v2.0.sizes
    if [[ "$nonB" == "GQ" ]]; then
      # GQ has scores and names
      bedToBigBed -type=bed6 -tab ${sp}_v2.0.nonB_$nonB.bed $SIZE ${sp}_v2.0.nonB_$nonB.bb
    else
      bedToBigBed -type=bed3 -tab ${sp}_v2.0.nonB_$nonB.bed $SIZE ${sp}_v2.0.nonB_$nonB.bb
    fi
    set +x
  done
done
```

### mSymSyn1
For mSymSyn1, we need for both versions v2.0 and v2.1

```shell
path=../path.txt
i=6
ver=v2.1

sp=`sed -n ${i}p $path | awk '{print $1}'`
sn=`sed -n ${i}p $path | awk '{print $3}'`
dd=`sed -n ${i}p $path | awk '{print $7}'`

for nonB in TRI # APR DR IR MR STR Z GQ
do
  ver=v2.1
  echo $sp
  set -x

#:<<"SKIP"
  bigBedToBed nonB_DNA/$sp.pri.cur.$dd.$nonB.bb ${sp}_$ver.pri.nonB_$nonB.bed
  bigBedToBed nonB_DNA/$sp.alt.cur.$dd.$nonB.bb ${sp}_$ver.alt.nonB_$nonB.bed
  cat ${sp}_$ver.pri.nonB_$nonB.bed ${sp}_$ver.alt.nonB_$nonB.bed > ${sp}_$ver.nonB_$nonB.bed
  rm ${sp}_$ver.pri.nonB_$nonB.bed ${sp}_$ver.alt.nonB_$nonB.bed

  SIZE=../../T2Tgenomes/${sp}_$ver/${sp}_$ver.sizes
  if [[ "$nonB" == "GQ" ]]; then
    # GQ has scores and names
    bedToBigBed -type=bed6 -tab ${sp}_$ver.nonB_$nonB.bed $SIZE ${sp}_$ver.nonB_$nonB.bb
  else
    bedToBigBed -type=bed3 -tab ${sp}_$ver.nonB_$nonB.bed $SIZE ${sp}_$ver.nonB_$nonB.bb
  fi
#SKIP

  # Convert back from v2.1 to v2.0
  java -jar -Xmx256m ../../src/txtReplaceWords.jar ../../chain/mSymSyn1_v2.1_to_v2.0.txt ${sp}_$ver.nonB_$nonB.bed 1 > ${sp}_v2.0.nonB_$nonB.bed
  ver=v2.0

  SIZE=../../T2Tgenomes/${sp}_$ver/${sp}_$ver.sizes
  if [[ "$nonB" == "GQ" ]]; then
    # GQ has scores and names
    bedToBigBed -type=bed6 -tab ${sp}_$ver.nonB_$nonB.bed $SIZE ${sp}_$ver.nonB_$nonB.bb
  else
    bedToBigBed -type=bed3 -tab ${sp}_$ver.nonB_$nonB.bed $SIZE ${sp}_$ver.nonB_$nonB.bb
  fi
  set +x
done

```

## Upload to AWS
```shell
module load aws

path=../path.txt
ver=v2.0

for i in $(seq 1 6)
do
  sp=`sed -n ${i}p $path | awk '{print $1}'`
  sn=`sed -n ${i}p $path | awk '{print $3}'`

  for nonB in TRI # APR DR IR MR STR Z GQ
  do
    set -x
    aws s3 cp --profile=vgp ${sp}_$ver.nonB_$nonB.bb s3://genomeark/species/$sn/$sp/assembly_curated/repeats/
    set +x
  done
done
```
Also for mSymSyn1 v2.1
```shell
path=../path.txt
ver=v2.1

i=6
sp=`sed -n ${i}p $path | awk '{print $1}'`
sn=`sed -n ${i}p $path | awk '{print $3}'`

for nonB in TRI # APR DR IR MR STR Z GQ
do
  set -x
  aws s3 cp --profile=vgp ${sp}_$ver.nonB_$nonB.bb s3://genomeark/species/$sn/$sp/assembly_curated/repeats/
  set +x
done

```

## Upload CHM13
```shell

for nonB in TRI # APR DR IR MR STR Z GQ
do
  # aws s3 cp nonB_DNA/chm13v2.0.$nonB.bb s3://human-pangenomics/T2T/browser/CHM13/bbi/nonB_$nonB.bb
  set -x
  aws s3 cp chm13v2.0.$nonB.bb s3://human-pangenomics/T2T/browser/CHM13/bbi/nonB_$nonB.bb
  set +x
done

```


