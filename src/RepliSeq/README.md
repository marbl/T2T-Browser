# Repli-Seq

Repli-seq data received from Yang Zhang from Jian Ma Lab: http://genome.compbio.cs.cmu.edu:8008/~yangz6/Primate_T2T_RT/


```
# For CHM13
4DN_GM12878_rep1.bw
4DN_HFF_rep1.bw

# For primates
Bonobo_mPanPan1.primary.simple_chrom.bw
Borean_orangutan_mPonPyg2.primary.simple_chrom.bw
Chimpanzee_mPanTro3.primary.simple_chrom.bw
Gorilla_EB_GorGor1.primary.simple_chrom.bw
Siamang_mSymSyn1.primary.simple_chrom.bw
Siamang_mSymSyn1.primary.simple_chrom.v2.1.bw
Sumatran_orangutan_mPonAbe1.primary.simple_chrom.bw
```

## Upload

Generate new s3 file names:
```shell
for i in $(seq 1 6)
do
  line=`sed -n ${i}p ../path.txt`
  sn=`echo $line | awk '{print $3}'`
  sp=`echo $line | awk '{print $1}'`
  echo "s3://genomeark/species/${sn}/${sp}/assembly_curated/epi/${sp}_v2.0_RepliSeq_v1.0.bw"
done
```

```
s3://genomeark/species/Gorilla_gorilla/mGorGor1/assembly_curated/epi/mGorGor1_v2.0_RepliSeq_v1.0.bw
s3://genomeark/species/Pan_paniscus/mPanPan1/assembly_curated/epi/mPanPan1_v2.0_RepliSeq_v1.0.bw
s3://genomeark/species/Pan_troglodytes/mPanTro3/assembly_curated/epi/mPanTro3_v2.0_RepliSeq_v1.0.bw
s3://genomeark/species/Pongo_abelii/mPonAbe1/assembly_curated/epi/mPonAbe1_v2.0_RepliSeq_v1.0.bw
s3://genomeark/species/Pongo_pygmaeus/mPonPyg2/assembly_curated/epi/mPonPyg2_v2.0_RepliSeq_v1.0.bw
s3://genomeark/species/Symphalangus_syndactylus/mSymSyn1/assembly_curated/epi/mSymSyn1_v2.0_RepliSeq_v1.0.bw
```

```shell
module load aws

aws s3 cp --profile=vgp Gorilla_EB_GorGor1.primary.simple_chrom.bw s3://genomeark/species/Gorilla_gorilla/mGorGor1/assembly_curated/epi/mGorGor1_v2.0_RepliSeq_v1.0.bw
aws s3 cp --profile=vgp Bonobo_mPanPan1.primary.simple_chrom.bw s3://genomeark/species/Pan_paniscus/mPanPan1/assembly_curated/epi/mPanPan1_v2.0_RepliSeq_v1.0.bw
aws s3 cp --profile=vgp Chimpanzee_mPanTro3.primary.simple_chrom.bw s3://genomeark/species/Pan_troglodytes/mPanTro3/assembly_curated/epi/mPanTro3_v2.0_RepliSeq_v1.0.bw
aws s3 cp --profile=vgp Sumatran_orangutan_mPonAbe1.primary.simple_chrom.bw s3://genomeark/species/Pongo_abelii/mPonAbe1/assembly_curated/epi/mPonAbe1_v2.0_RepliSeq_v1.0.bw
aws s3 cp --profile=vgp Borean_orangutan_mPonPyg2.primary.simple_chrom.bw s3://genomeark/species/Pongo_pygmaeus/mPonPyg2/assembly_curated/epi/mPonPyg2_v2.0_RepliSeq_v1.0.bw
aws s3 cp --profile=vgp Siamang_mSymSyn1.primary.simple_chrom.bw s3://genomeark/species/Symphalangus_syndactylus/mSymSyn1/assembly_curated/epi/mSymSyn1_v2.0_RepliSeq_v1.0.bw
aws s3 cp --profile=vgp Siamang_mSymSyn1.primary.simple_chrom.v2.1.bw s3://genomeark/species/Symphalangus_syndactylus/mSymSyn1/assembly_curated/epi/mSymSyn1_v2.1_RepliSeq_v1.0.bw
```

## Track definition
Generate html path:
```shell
for i in $(seq 1 6)
do
  line=`sed -n ${i}p ../path.txt`
  sn=`echo $line | awk '{print $3}'`
  sp=`echo $line | awk '{print $1}'`
  echo "bigDataUrl https://genomeark.s3.amazonaws.com/species/${sn}/${sp}/assembly_curated/epi/${sp}_v2.0_RepliSeq_v1.0.bw"
done
```

```
bigDataUrl https://genomeark.s3.amazonaws.com/species/Gorilla_gorilla/mGorGor1/assembly_curated/epi/mGorGor1_v2.0_RepliSeq_v1.0.bw
bigDataUrl https://genomeark.s3.amazonaws.com/species/Pan_paniscus/mPanPan1/assembly_curated/epi/mPanPan1_v2.0_RepliSeq_v1.0.bw
bigDataUrl https://genomeark.s3.amazonaws.com/species/Pan_troglodytes/mPanTro3/assembly_curated/epi/mPanTro3_v2.0_RepliSeq_v1.0.bw
bigDataUrl https://genomeark.s3.amazonaws.com/species/Pongo_abelii/mPonAbe1/assembly_curated/epi/mPonAbe1_v2.0_RepliSeq_v1.0.bw
bigDataUrl https://genomeark.s3.amazonaws.com/species/Pongo_pygmaeus/mPonPyg2/assembly_curated/epi/mPonPyg2_v2.0_RepliSeq_v1.0.bw
bigDataUrl https://genomeark.s3.amazonaws.com/species/Symphalangus_syndactylus/mSymSyn1/assembly_curated/epi/mSymSyn1_v2.0_RepliSeq_v1.0.bw
```

