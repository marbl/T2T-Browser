# Primate Variants

Received from Iris (Qiuhui Li), August 20, 2024 via Globus, `primate_T2T/variant_calling_v2/beagle_phased/`


```shell
ls variant_calling_v2/beagle_phased/
```

## mGorGor1.list
```
eastern_lowland_gorilla.t2t.beagle4.biallelic_snps.autosomes.vcf.gz
eastern_lowland_gorilla.t2t.beagle4.biallelic_snps.autosomes.vcf.gz.tbi
mountain_gorilla.t2t.beagle4.biallelic_snps.autosomes.vcf.gz
mountain_gorilla.t2t.beagle4.biallelic_snps.autosomes.vcf.gz.tbi
western_lowland_gorilla.t2t.beagle4.biallelic_snps.autosomes.vcf.gz
western_lowland_gorilla.t2t.beagle4.biallelic_snps.autosomes.vcf.gz.tbi
```

## mPanPan1.list
```
bonobo.t2t.beagle4.biallelic_snps.autosomes.vcf.gz
bonobo.t2t.beagle4.biallelic_snps.autosomes.vcf.gz.tbi
```

## mPanTro3.list
```
central_chimpanzee.t2t.beagle4.biallelic_snps.autosomes.vcf.gz
central_chimpanzee.t2t.beagle4.biallelic_snps.autosomes.vcf.gz.tbi
eastern_chimpanzee.t2t.beagle4.biallelic_snps.autosomes.vcf.gz
eastern_chimpanzee.t2t.beagle4.biallelic_snps.autosomes.vcf.gz.tbi
nigerian_chimpanzee.t2t.beagle4.biallelic_snps.autosomes.vcf.gz
nigerian_chimpanzee.t2t.beagle4.biallelic_snps.autosomes.vcf.gz.tbi
western_chimpanzee.t2t.beagle4.biallelic_snps.autosomes.vcf.gz
western_chimpanzee.t2t.beagle4.biallelic_snps.autosomes.vcf.gz.tbi
```

## mPonAbe1.list
```
sumatran_orangutan.t2t.beagle4.biallelic_snps.autosomes.vcf.gz
sumatran_orangutan.t2t.beagle4.biallelic_snps.autosomes.vcf.gz.tbi
```

## mPonPyg2.list
```
bornean_orangutan.t2t.beagle4.biallelic_snps.autosomes.vcf.gz
bornean_orangutan.t2t.beagle4.biallelic_snps.autosomes.vcf.gz.tbi
```

## Upload
```shell
module load aws

path=../path.txt
for i in $(seq 1 5)
do
  ln=`sed -n ${i}p $path`
  sp=`echo $ln | awk '{print $1}'`
  sn=`echo $ln | awk '{print $3}'`
  for f in $(cat $sp.list)
  do
    ln -s variant_calling_v2/beagle_phased/$f
    aws s3 cp --profile=vgp $f s3://genomeark/species/$sn/$sp/assembly_curated/variants/${sp}_v2.0.pri.$f
  done
done
```
## URL and trackDb description
```shell
for i in $(seq 1 5)
do
  ln=`sed -n ${i}p $path`
  sp=`echo $ln | awk '{print $1}'`
  sn=`echo $ln | awk '{print $3}'`
  for f in $(cat $sp.list)
  do
    if [[ $f == *.vcf.gz ]]; then
      echo "bigDataUrl https://genomeark.s3.amazonaws.com/species/$sn/$sp/assembly_curated/variants/${sp}_v2.0.pri.$f"
	fi
  done
  echo
done
```

```
bigDataUrl https://genomeark.s3.amazonaws.com/species/Gorilla_gorilla/mGorGor1/assembly_curated/variants/mGorGor1_v2.0.pri.eastern_lowland_gorilla.t2t.beagle4.biallelic_snps.autosomes.vcf.gz
bigDataUrl https://genomeark.s3.amazonaws.com/species/Gorilla_gorilla/mGorGor1/assembly_curated/variants/mGorGor1_v2.0.pri.mountain_gorilla.t2t.beagle4.biallelic_snps.autosomes.vcf.gz
bigDataUrl https://genomeark.s3.amazonaws.com/species/Gorilla_gorilla/mGorGor1/assembly_curated/variants/mGorGor1_v2.0.pri.western_lowland_gorilla.t2t.beagle4.biallelic_snps.autosomes.vcf.gz

bigDataUrl https://genomeark.s3.amazonaws.com/species/Pan_paniscus/mPanPan1/assembly_curated/variants/mPanPan1_v2.0.pri.bonobo.t2t.beagle4.biallelic_snps.autosomes.vcf.gz

bigDataUrl https://genomeark.s3.amazonaws.com/species/Pan_troglodytes/mPanTro3/assembly_curated/variants/mPanTro3_v2.0.pri.central_chimpanzee.t2t.beagle4.biallelic_snps.autosomes.vcf.gz
bigDataUrl https://genomeark.s3.amazonaws.com/species/Pan_troglodytes/mPanTro3/assembly_curated/variants/mPanTro3_v2.0.pri.eastern_chimpanzee.t2t.beagle4.biallelic_snps.autosomes.vcf.gz
bigDataUrl https://genomeark.s3.amazonaws.com/species/Pan_troglodytes/mPanTro3/assembly_curated/variants/mPanTro3_v2.0.pri.nigerian_chimpanzee.t2t.beagle4.biallelic_snps.autosomes.vcf.gz
bigDataUrl https://genomeark.s3.amazonaws.com/species/Pan_troglodytes/mPanTro3/assembly_curated/variants/mPanTro3_v2.0.pri.western_chimpanzee.t2t.beagle4.biallelic_snps.autosomes.vcf.gz

bigDataUrl https://genomeark.s3.amazonaws.com/species/Pongo_abelii/mPonAbe1/assembly_curated/variants/mPonAbe1_v2.0.pri.sumatran_orangutan.t2t.beagle4.biallelic_snps.autosomes.vcf.gz

bigDataUrl https://genomeark.s3.amazonaws.com/species/Pongo_pygmaeus/mPonPyg2/assembly_curated/variants/mPonPyg2_v2.0.pri.bornean_orangutan.t2t.beagle4.biallelic_snps.autosomes.vcf.gz
```

Example trackDb.txt
```
track variant
superTrack on
shortLabel VariantCall
longLabel Varant Call from Population
group var
type vcfTabix
hapClusterEnabled true
maxWindowToDraw 3000000
html ../html/variant.html
priority 82
	
	track varBon
	parent variant
	shortLabel Bonobo
	longLabel Bonobo
	visibility squish
	bigDataUrl bigDataUrl https://genomeark.s3.amazonaws.com/species/Pan_paniscus/mPanPan1/assembly_curated/variants/mPanPan1_v2.0.pri.bonobo.t2t.beagle4.biallelic_snps.autosomes.vcf.gz
```