# Assembly Issues

Added during revision. Data available on `https://github.com/marbl/Primates/tree/main/issues`.
Available on `/data/Phillippy2/projects/primate_T2T/polishing/issues_v2.0/`

## Convert to bb, upload as v1.0

```shell
module load bedtools
module load ucsc
module load aws

path=../path.txt
for i in $(seq 1 6)
do
  ln=`sed -n ${i}p $path`
  sp=`echo $ln | awk '{print $1}'`
  sn=`echo $ln | awk '{print $3}'`
  
  ver=${sp}_v2.0

  iss=/data/Phillippy2/projects/primate_T2T/polishing/issues_v2.0/${ver}.issues.bed
  end=/data/Phillippy2/projects/primate_T2T/polishing/issues_v2.0/${ver}.end.bed
  mrg=/data/Phillippy2/projects/primate_T2T/polishing/issues_v2.0/${ver}.issues.100k_mrg.bed

  # Exclude issues overlapping within 100k of tel ends
  cat $end | cut -f1-3 | sort -k1,1 -k2,2n | bedtools intersect -u -a $mrg -b - > ${ver}.issues.100k_mrg.end.bed
  bedtools subtract -A -a $iss -b ${ver}.issues.100k_mrg.end.bed > ${ver}.issues.no_end.bed
  iss=${ver}.issues.no_end.bed
  out=${ver}.issues_v1.0.bb

  bedToBigBed -tab -type=bed9 $iss ../../T2Tgenomes/$ver/$ver.sizes $out
done

# mSymSynv2.1
iss=mSymSyn1_v2.0.issues.no_end.bed
ver=mSymSyn1_v2.1
awk 'BEGIN {OFS = "\t"} FNR==NR {  map[$1] = $2; next } \
      { if ( $1 in map ) { $1 = map[$1]; };  print $0 }' ../../src/mSymSyn1_v2.0_v2.1.map $iss | \
  sort -k1,1 -k2,2n > mSymSyn1_v2.1.issues.no_end.bed
iss=${ver}.issues.no_end.bed
out=${ver}.issues_v1.0.bb
bedToBigBed -tab -type=bed9 $iss ../../T2Tgenomes/$ver/$ver.sizes $out

# Upload
path=../path.txt
for i in $(seq 1 6)
do
  ln=`sed -n ${i}p $path`
  sp=`echo $ln | awk '{print $1}'`
  sn=`echo $ln | awk '{print $3}'`
  
  ver=${sp}_v2.0
  out=${ver}.issues_v1.0.bb
  aws s3 cp --profile=vgp $out s3://genomeark/species/$sn/$sp/assembly_curated/issues/

  #restore the one accidentally removed for mGorGor1
  #ln -s /data/Phillippy2/projects/primate_T2T/polishing/issues_v2.0/$ver.issues.no_rDNA.no_end.bb
  #aws s3 cp --profile=vgp $ver.issues.no_rDNA.no_end.bb s3://genomeark/species/$sn/$sp/assembly_curated/issues/
done
out=${ver}.issues_v1.0.bb
aws s3 cp --profile=vgp $out s3://genomeark/species/$sn/$sp/assembly_curated/issues/
```

## URL
```shell
path=../path.txt
for i in $(seq 1 6)
do
  ln=`sed -n ${i}p $path`
  sp=`echo $ln | awk '{print $1}'`
  sn=`echo $ln | awk '{print $3}'`
  
  ver=${sp}_v2.0
  echo https://genomeark.s3.amazonaws.com/species/$sn/$sp/assembly_curated/issues/${ver}.issues_v1.0.bb
done

ver=${sp}_v2.1
echo https://genomeark.s3.amazonaws.com/species/$sn/$sp/assembly_curated/issues/${ver}.issues_v1.0.bb
```

```
https://genomeark.s3.amazonaws.com/species/Gorilla_gorilla/mGorGor1/assembly_curated/issues/mGorGor1_v2.0.issues_v1.0.bb
https://genomeark.s3.amazonaws.com/species/Pan_paniscus/mPanPan1/assembly_curated/issues/mPanPan1_v2.0.issues_v1.0.bb
https://genomeark.s3.amazonaws.com/species/Pan_troglodytes/mPanTro3/assembly_curated/issues/mPanTro3_v2.0.issues_v1.0.bb
https://genomeark.s3.amazonaws.com/species/Pongo_abelii/mPonAbe1/assembly_curated/issues/mPonAbe1_v2.0.issues_v1.0.bb
https://genomeark.s3.amazonaws.com/species/Pongo_pygmaeus/mPonPyg2/assembly_curated/issues/mPonPyg2_v2.0.issues_v1.0.bb
https://genomeark.s3.amazonaws.com/species/Symphalangus_syndactylus/mSymSyn1/assembly_curated/issues/mSymSyn1_v2.0.issues_v1.0.bb

https://genomeark.s3.amazonaws.com/species/Symphalangus_syndactylus/mSymSyn1/assembly_curated/issues/mSymSyn1_v2.1.issues_v1.0.bb
```

## trackDb.txt template
```
  track issues
  parent validation
  shortLabel HiFI & ONT Issues
  longLabel Assembly Issues by both HiFi and ONT
  visibility dense
  itemRgb on
  maxItems 100000
  type bigBed 9
  bitDataUrl https://genomeark.s3.amazonaws.com/species/Symphalangus_syndactylus/mSymSyn1/assembly_curated/issues/mSymSyn1_v2.1.issues_v1.0.bb
  html https://raw.githubusercontent.com/marbl/CHM13-issues/main/description.html
  priority 18.5
```