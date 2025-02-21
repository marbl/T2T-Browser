# Gene annotation

## RefSeq
Downloaded from NCBI:

```
https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/029/281/585/GCF_029281585.2_NHGRI_mGorGor1-v2.0_pri/
https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/028/885/655/GCF_028885655.2_NHGRI_mPonAbe1-v2.0_pri/
https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/028/878/055/GCF_028878055.2_NHGRI_mSymSyn1-v2.0_pri/
https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/029/289/425/GCF_029289425.2_NHGRI_mPanPan1-v2.0_pri/

2024-03-18
https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/028/858/775/GCF_028858775.2_NHGRI_mPanTro3-v2.0_pri/
https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/028/885/625/GCF_028885625.2_NHGRI_mPonPyg2-v2.0_pri/
```

```
cat GFF.list
GCF_028878055.2_NHGRI_mSymSyn1-v2.0_pri_genomic.gff
GCF_028885655.2_NHGRI_mPonAbe1-v2.0_pri_genomic.gff
GCF_029281585.2_NHGRI_mGorGor1-v2.0_pri_genomic.gff
GCF_029289425.2_NHGRI_mPanPan1-v2.0_pri_genomic.gff
GCF_028858775.2_NHGRI_mPanTro3-v2.0_pri_genomic.gff
GCF_028885625.2_NHGRI_mPonPyg2-v2.0_pri_genomic.gff
```

## Converting GFF to browser gene tracks
```shell
module load ucsc
module load aws

for GFF in $(tail -n2 GFF.list)
do
  set -x
  
  COL=${GFF/.gff/.colors.txt}
  TYP=${GFF/.gff/.geneType.txt}
  SYN=${GFF/.gff/.geneNames.txt}
  ATT=${GFF/.gff/.attributes.txt}
  sp=`echo $GFF | awk -F "_" '{print $4}' | awk -F "-" '{print $1}'`
  SIZE=../../browser/${sp}_v2.0/${sp}_v2.0.sizes
  ALIAS=../../browser/${sp}_v2.0/${sp}_v2.0.alias
  OUT=${sp}_refGene

  # Use MarkD's fixed version
  ./gff3ToGenePred -refseqHacks \
   -bad=failed -warnAndContinue -attrsOut=$ATT $GFF stdout |\
   sort -k2,2V -k4,4n - > $OUT.gp

  python gff3ToExtra.py -useName $GFF

  genePredToBigGenePred \
  -colors=$COL -geneType=$TYP -geneNames=$SYN $OUT.gp $OUT.bed 2> log
  
  awk -F "\t" -v OFS='\t' 'NR==FNR { mapping[$4] = $1; next } { $1 = mapping[$1]; print }' $ALIAS $OUT.bed > $OUT.chromFix.bed

  bedToBigBed -extraIndex=name,name2 -type=bed12+8 -tab -as=bigGenePred.as $OUT.chromFix.bed $SIZE $OUT.bb

  # Make it searchable:
  cat $OUT.bed | awk '{print $4, $17, $18}' > input.txt
  ./ixIxx input.txt $OUT.ix $OUT.ixx

  set +x
done

path=../path.txt
for i in $(seq 1 6)
do
  sp=`sed -n ${i}p $path | awk '{print $1}'`
  sn=`sed -n ${i}p $path | awk '{print $3}'`
  aws s3 cp --profile=vgp ${sp}_refGene.bb  s3://genomeark/species/$sn/$sp/assembly_curated/gene/
  aws s3 cp --profile=vgp ${sp}_refGene.ix  s3://genomeark/species/$sn/$sp/assembly_curated/gene/
  aws s3 cp --profile=vgp ${sp}_refGene.ixx s3://genomeark/species/$sn/$sp/assembly_curated/gene/
done
```

## Track description
```
track refGene
type bigGenePred
visibility hide
group genes
bigDataUrl https://genomeark.s3.amazonaws.com/species/Symphalangus_syndactylus/mSymSyn1/assembly_curated/gene/mSymSyn1_refGene.bb
itemRgb on 
shortLabel RefSeq 02/2024
longLabel NCBI RefSeq GCF_028878055.2-RS_2024_02
baseColorDefault genomicCodons
html ../html/refGene.html
priority 2
labelFields name,name2
defaultLabelFields name2
labelSeparator ","
searchIndex name,name2
searchTrix https://genomeark.s3.amazonaws.com/species/Symphalangus_syndactylus/mSymSyn1/assembly_curated/gene/mSymSyn1_refGene.ix
```

```shell
# Do the same for the rest of the species
path=../../species.txt 
for i in $(seq 1 5)
do
  sp=`sed -n ${i}p $path | awk '{print $1}'`
  sn=`sed -n ${i}p $path | awk '{print $2}'`
  sp_ver=${sp}_v2.0
  cat gen.trackDb.txt | sed "s/mSymSyn1/$sp/g" | sed "s/Symphalangus_syndactylus/$sn/g" > ../$sp_ver/gen.trackDb.txt
done

## Manually fix GCF accessions in the longLabel
```