# Methylation tracks

Received from Ryan (Dongmin) Son via globus: `primate_T2T/browser/5mC_DNAmethylationTrack_20241028/`

```
1_hg002_Human_hg002v1.1_ONT_5mC_modkitCpGprocessed_new_20241028.bw
1_mGorGor1_Gorilla_v2_ONT_5mC_modkitCpGprocessed_new_20241028.bw
1_mPanPan1_Bonobo_v2_ONT_5mC_modkitCpGprocessed_new_20241028.bw
1_mPanTro3_Chimpanzee_v2_ONT_5mC_modkitCpGprocessed_new_20241028.bw
1_mPonAbe1_SOrang_v2_ONT_5mC_modkitCpGprocessed_new_20241028.bw
1_mPonPyg2_BOrang_v2_ONT_5mC_modkitCpGprocessed_new_20241028.bw
1_mSymSyn1_Siamang_v2.1_ONT_5mC_modkitCpGprocessed_new_20241028.bw
Yilab_CpGMethylationTrack_20241028_new.html
```

## Merge description
Merge description into `epigenetics.html`

## Link, rename
```shell
ln -s /data/Phillippy2/t2t-share/primate_T2T/browser/5mC_DNAmethylationTrack_20241028
postfix=".ONT_Guppy6.3.8_5mC.winnowmap_modkit_5mC_CpG_v1.0.bw"

ln -s 5mC_DNAmethylationTrack_20241028/1_hg002_Human_hg002v1.1_ONT_5mC_modkitCpGprocessed_new_20241028.bw HG002v1.1$postfix

ln -s 5mC_DNAmethylationTrack_20241028/1_mGorGor1_Gorilla_v2_ONT_5mC_modkitCpGprocessed_new_20241028.bw mGorGor1_v2.0$postfix
ln -s 5mC_DNAmethylationTrack_20241028/1_mPanPan1_Bonobo_v2_ONT_5mC_modkitCpGprocessed_new_20241028.bw mPanPan1_v2.0$postfix
ln -s 5mC_DNAmethylationTrack_20241028/1_mPanTro3_Chimpanzee_v2_ONT_5mC_modkitCpGprocessed_new_20241028.bw mPanTro3_v2.0$postfix
ln -s 5mC_DNAmethylationTrack_20241028/1_mPonAbe1_SOrang_v2_ONT_5mC_modkitCpGprocessed_new_20241028.bw mPonAbe1_v2.0$postfix
ln -s 5mC_DNAmethylationTrack_20241028/1_mPonPyg2_BOrang_v2_ONT_5mC_modkitCpGprocessed_new_20241028.bw mPonPyg2_v2.0$postfix
ln -s 5mC_DNAmethylationTrack_20241028/1_mSymSyn1_Siamang_v2.1_ONT_5mC_modkitCpGprocessed_new_20241028.bw mSymSyn1_v2.1$postfix

```

## Convert mSymSyn1 v2.1 to v2.0

```shell
module load ucsc
bigWigToBedGraph mSymSyn1_v2.1.ONT_Guppy6.3.8_5mC.winnowmap_modkit_5mC_CpG_v1.0.bw mSymSyn1_v2.1.ONT_Guppy6.3.8_5mC.winnowmap_modkit_5mC_CpG_v1.0.bg
awk 'BEGIN {OFS = "\t"} FNR==NR {  mapping[$1] = $2; next } \
{ if ( $1 in mapping ) { $1 = mapping[$1]; };  print $0 }' ../../src/mSymSyn1_v2.0_v2.1.map mSymSyn1_v2.1.ONT_Guppy6.3.8_5mC.winnowmap_modkit_5mC_CpG_v1.0.bg > mSymSyn1_v2.0.ONT_Guppy6.3.8_5mC.winnowmap_modkit_5mC_CpG_v1.0.bg
bedGraphToBigWig mSymSyn1_v2.0.ONT_Guppy6.3.8_5mC.winnowmap_modkit_5mC_CpG_v1.0.bg ../../T2Tgenomes/mSymSyn1_v2.0/mSymSyn1_v2.0.sizes mSymSyn1_v2.0.ONT_Guppy6.3.8_5mC.winnowmap_modkit_5mC_CpG_v1.0.bw
```

## Upload

```shell
module load aws
path=../path.txt
for i in $(seq 1 6)
do
  ln=`sed -n ${i}p $path`
  sp=`echo $ln | awk '{print $1}'`
  sn=`echo $ln | awk '{print $3}'`
  # aws s3 cp --profile=vgp ${sp}_v2.0.ONT_Guppy6.3.8_5mC.winnowmap_modkit_5mC_CpG_v1.0.bw s3://genomeark/species/$sn/$sp/assembly_curated/epi/
  aws s3 rm --profile=vgp s3://genomeark/species/$sn/$sp/assembly_curated/epi/${sp}_v2.0.ONT_Guppy3.6.8_5mC.winnowmap_modkit_5mC_CpG_v1.0.bw
  echo "https://genomeark.s3.amazonaws.com/species/$sn/$sp/assembly_curated/epi/${sp}_v2.0.ONT_Guppy6.3.8_5mC.winnowmap_modkit_5mC_CpG_v1.0.bw"
done

i=6
ln=`sed -n ${i}p $path`
sp=`echo $ln | awk '{print $1}'`
sn=`echo $ln | awk '{print $3}'`
# aws s3 cp --profile=vgp ${sp}_v2.1.ONT_Guppy6.3.8_5mC.winnowmap_modkit_5mC_CpG_v1.0.bw s3://genomeark/species/$sn/$sp/assembly_curated/epi/
echo "https://genomeark.s3.amazonaws.com/species/$sn/$sp/assembly_curated/epi/${sp}_v2.1.ONT_Guppy6.3.8_5mC.winnowmap_modkit_5mC_CpG_v1.0.bw"
```
URL Links
```
https://genomeark.s3.amazonaws.com/species/Gorilla_gorilla/mGorGor1/assembly_curated/epi/mGorGor1_v2.0.ONT_Guppy6.3.8_5mC.winnowmap_modkit_5mC_CpG_v1.0.bw
https://genomeark.s3.amazonaws.com/species/Pan_paniscus/mPanPan1/assembly_curated/epi/mPanPan1_v2.0.ONT_Guppy6.3.8_5mC.winnowmap_modkit_5mC_CpG_v1.0.bw
https://genomeark.s3.amazonaws.com/species/Pan_troglodytes/mPanTro3/assembly_curated/epi/mPanTro3_v2.0.ONT_Guppy6.3.8_5mC.winnowmap_modkit_5mC_CpG_v1.0.bw
https://genomeark.s3.amazonaws.com/species/Pongo_abelii/mPonAbe1/assembly_curated/epi/mPonAbe1_v2.0.ONT_Guppy6.3.8_5mC.winnowmap_modkit_5mC_CpG_v1.0.bw
https://genomeark.s3.amazonaws.com/species/Pongo_pygmaeus/mPonPyg2/assembly_curated/epi/mPonPyg2_v2.0.ONT_Guppy6.3.8_5mC.winnowmap_modkit_5mC_CpG_v1.0.bw
https://genomeark.s3.amazonaws.com/species/Symphalangus_syndactylus/mSymSyn1/assembly_curated/epi/mSymSyn1_v2.0.ONT_Guppy6.3.8_5mC.winnowmap_modkit_5mC_CpG_v1.0.bw

https://genomeark.s3.amazonaws.com/species/Symphalangus_syndactylus/mSymSyn1/assembly_curated/epi/mSymSyn1_v2.1.ONT_Guppy6.3.8_5mC.winnowmap_modkit_5mC_CpG_v1.0.bw
```
## Clean up
Mis-spelled Guppy version - remove 3.6.8

```shell
module load aws
path=../path.txt
for i in $(seq 1 6)
do
  ln=`sed -n ${i}p $path`
  sp=`echo $ln | awk '{print $1}'`
  sn=`echo $ln | awk '{print $3}'`

  aws s3 rm --profile=vgp s3://genomeark/species/$sn/$sp/assembly_curated/epi/${sp}_v2.0.ONT_Guppy3.6.8_5mC.winnowmap_modkit_5mC_CpG_v1.0.bw
done

aws s3 rm --profile=vgp s3://genomeark/species/$sn/$sp/assembly_curated/epi/${sp}_v2.1.ONT_Guppy3.6.8_5mC.winnowmap_modkit_5mC_CpG_v1.0.bw
```