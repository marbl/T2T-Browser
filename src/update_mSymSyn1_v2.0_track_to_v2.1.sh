#!/bin/sh

if [[ "$#" -lt 3 ]]; then
  echo "Usage: ./update_mSymSyn1_v2.0_track_to_v2.1.sh in.bb out.bb bedToBigBedOpt"
  echo "  bedToBigBedOpt :  \"-type=bedN ...\""
  exit 0
fi

in=$1
bed=${in/.bb/.bed}
out=$2
opt=$3
size=../../T2Tgenomes/mSymSyn1_v2.1/mSymSyn1_v2.1.sizes

module load ucsc

set -x
bigBedToBed $in $bed
java -jar -Xmx256m ../../src/txtReplaceWords.jar ../../src/mSymSyn1_v2.0_v2.1.map $bed 1 > $bed.2.1.bed
bedToBigBed -tab $opt $bed.2.1.bed $size $out
set +x
