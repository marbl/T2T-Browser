#!/bin/bash

sp_map="../species.txt"
ver=v2.0

cd browser

module load ucsc

set -x

for i in $(seq 3 6)
do
  sp=`sed -n ${i}p $sp_map | awk '{print $1}'`
	sp_name=`sed -n ${i}p $sp_map | awk '{print $2}'`
  sp_n1=`echo $sp_name | awk -F "_" '{print $1}'`
  sp_n2=`echo $sp_name | awk -F "_" '{print $2}'`
  genome=${sp}_${ver}
  fa=$projects2/primate_T2T/polishing/pattern/$genome.fa

  mkdir -p $genome && cd $genome
  faToTwoBit -long $fa $genome.2bit
  faSize -tab -detailed $fa > $genome.sizes

  # copy over files from mGorGor1
  for f in $(find ../mGorGor1_v2.0/ -maxdepth 1 -type f -not -name 'mGorGor1_v2.0.*')
  do
    cat $f | sed "s/mGorGor1/$sp/g" | sed "s/Gorilla_gorilla/$sp_name/g" | sed "s/Gorilla/$sp_n1/g" | sed "s/gorilla/$sp_n2/g" > `basename $f`
  done

  mkdir -p html && cd html
  for f in $(find ../../mGorGor1_v2.0/html/ -maxdepth 1 -type f)
  do
    cat $f | sed "s/mGorGor1/$sp/g" | sed "s/Gorilla_gorilla/$sp_name/g" | sed "s/Gorilla/$sp_n1/g" | sed "s/gorilla/$sp_n2/g" > `basename $f`
  done
  cd ../../
done

set +x
