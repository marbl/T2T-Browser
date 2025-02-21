# TOGA

Data description and tracks were provided by Michael Hiller on January 30, 2024.

`.bb`, `.ix`, and `.ixx` tracks were re-uploaded to each genome on genomeark following the track definitions provided below.

```shell
# Download
wget --no-check-certificate --no-parent -r --reject "index.html*" https://genome.senckenberg.de/download/forArangTOGA_T2T/HLgorGor7/

# Move
mv genome.senckenberg.de/download/forArangTOGA_T2T/HLgorGor7 mGorGor1
mv genome.senckenberg.de/download/forArangTOGA_T2T/HLpanPan4 mPanPan1
mv genome.senckenberg.de/download/forArangTOGA_T2T/HLpanTro7 mPanTro3
mv genome.senckenberg.de/download/forArangTOGA_T2T/HLponAbe4 mPonAbe1
mv genome.senckenberg.de/download/forArangTOGA_T2T/HLponPyg2 mPonPyg2
mv genome.senckenberg.de/download/forArangTOGA_T2T/HLsymSyn4 mSymSyn1

sp_map=../species.txt
for i in $(seq 1 6)
do
  sp=`sed -n ${i}p $sp_map | awk '{print $1}'`
	sp_name=`sed -n ${i}p $sp_map | awk '{print $2}'`
  cd $sp
  aws s3 cp --profile=vgp --recursive ./ s3://genomeark/species/$sp_name/$sp/assembly_curated/gene/
  cd ../
done
```

## Track description
Track description was handled for mGorGor1 `gen.trackDb.txt` (along with `asm.trackDb.txt`, `reg.trackDb.txt` and copied over to all other species.

```shell
sp_map=../species.txt
for i in $(seq 2 6)
do
  sp=`sed -n ${i}p $sp_map | awk '{print $1}'`
	sp_name=`sed -n ${i}p $sp_map | awk '{print $2}'`
  cd ${sp}_v2.0
  for f in ../mGorGor1_v2.0/gen.trackDb.txt ../mGorGor1_v2.0/asm.trackDb.txt ../mGorGor1_v2.0/reg.trackDb.txt # ../mGorGor1_v2.0/trackDb.txt
  do
    cat $f | sed "s/mGorGor1/$sp/g" | sed "s/Gorilla_gorilla/$sp_name/g" > `basename $f`
  done
  cd ../
done
```

## Big Bed definitions for TOGA
Original track definitions provided by Hiller lab:
```
# TOGA default annotation with hg38 as reference
track HLTOGAannotvsHg38v1BIG
shortLabel HL TOGA hg38 annotations BIG
longLabel TOGA annotations using human hg38 as reference BIG
group genes
priority 2
visibility hide
itemRgb on
type bigBed 12 +
bigDataUrl http://genome.tbg.senckenberg.de/data/$D/HLTOGAannotVsHg38v1.bb
labelFields name
searchIndex name
searchTrix http://genome.tbg.senckenberg.de/data/$D/HLTOGAannotVsHg38v1.ix
searchTable HLTOGAannotvsHg38v1BIG
searchPriority 2.07207
searchType bigBed
searchMethod fuzzy
 
# TOGA default annotation with mm10 as reference
track HLTOGAannotvsMm10v1BIG
shortLabel HL TOGA mm10 annotations BIG
longLabel TOGA annotations using mouse mm10 as reference BIG
group genes
priority 2
visibility hide
itemRgb on
type bigBed 12 +
bigDataUrl http://genome.tbg.senckenberg.de/data/$D/HLTOGAannotVsMm10v1.bb
labelFields name
searchIndex name
searchTrix http://genome.tbg.senckenberg.de/data/$D/HLTOGAannotVsMm10v1.ix
searchTable HLTOGAannotvsMm10v1BIG
searchPriority 2.07207
searchType bigBed
searchMethod fuzzy
```