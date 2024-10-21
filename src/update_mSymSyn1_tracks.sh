#!/bin/sh

if [[ "$#" -lt 4 ]]; then
  echo "Usage: ./update_mSymSyn1_tracks.sh in.bb out.bb bedToBigBedOpt dest_ver"
  echo "  bedToBigBedOpt :  \"-type=bedN ...\""
  echo "  dest_ver       :  v2.0 or v2.1"
  exit 0
fi

in=$1
bed=${in/.bb/.bed}
out=$2
opt=$3
ver=$4
size=../../T2Tgenomes/mSymSyn1_${ver}/mSymSyn1_${ver}.sizes

echo "Convert $in to $out, to ${ver}"

module load ucsc

set -x
bigBedToBed $in $bed
java -jar -Xmx256m ../../src/txtReplaceWords.jar ../../src/mSymSyn1_v2.0_v2.1.map $bed 1 > $bed.2.1.bed
bedToBigBed -tab $opt $bed.2.1.bed $size $out
set +x
