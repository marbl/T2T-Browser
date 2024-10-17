# CAT Gene Annotation

Data received from Prajna Hebbar on Oct. 17, 2024.
https://public.gi.ucsc.edu/~pnhebbar/t2t_autosomes/cat_ncbi_consensus/

Gene annotation are available for the primary haplotypes.

## Genome ID

| SpeciesID | SpeciesName | GCA - Pri |
| :---: | :---: | :---:|
| mGorGor1 | Gorilla_gorilla | GCA_029281585.2 |
| mPanPan1 | Pan_paniscus | GCA_029289425.2 |
| mPanTro3 | Pan_troglodytes | GCA_028858775.2 |
| mPonAbe1 | Pongo_abelii    | GCA_028885655.2 |
| mPonPyg2 | Pongo_pygmaeus  | GCA_028885625.2 |
| mSymSyn1 | Symphalangus_syndactylus | GCA_028878055.2 |

## Download original files
```shell
for GCA in $(cat ../path.txt | cut -f4 )
do
  wget https://public.gi.ucsc.edu/~pnhebbar/t2t_autosomes/cat_ncbi_consensus/$GCA.consensus.v3.sorted.fixed.bb
  wget https://public.gi.ucsc.edu/~pnhebbar/t2t_autosomes/cat_ncbi_consensus/$GCA.consensus.v3.sorted.fixed.ix
  wget https://public.gi.ucsc.edu/~pnhebbar/t2t_autosomes/cat_ncbi_consensus/$GCA.consensus.v3.sorted.fixed.ixx
done
```

## Upload to GenomeArk
```shell
module load aws
path=../path.txt
for GCA in $(cat $path | cut -f4 )
do
  echo $GCA
  line=`grep $GCA $path`
  sp=`echo $line | awk '{print $1}'`
  sn=`echo $line | awk '{print $3}'`
  aws s3 cp --profile=vgp $GCA.consensus.v3.sorted.fixed.bb  s3://genomeark/species/$sn/$sp/assembly_curated/gene/${sp}_v2.0_CatRefConsensus_v3.bb
  aws s3 cp --profile=vgp $GCA.consensus.v3.sorted.fixed.ix  s3://genomeark/species/$sn/$sp/assembly_curated/gene/${sp}_v2.0_CatRefConsensus_v3.ix
  aws s3 cp --profile=vgp $GCA.consensus.v3.sorted.fixed.ixx s3://genomeark/species/$sn/$sp/assembly_curated/gene/${sp}_v2.0_CatRefConsensus_v3.ixx
done
```

## Add to trackDb.txt
```
# CAT + RefSeq Consensus
track catRefGene
type bigBed 12 + # has 13 columns. Not a bigGenePred
visibility dense
group genes
itemRgb on 
shortLabel CAT+RefSeq Consensus
longLabel CAT+RefSeq Consensus Protein Coding Gene Annotation v3.0 10/2024
baseColorDefault genomicCodons
html ../html/catGene.html
priority 40
labelFields name,name2
defaultLabelFields name2
labelSeparator ","
searchIndex name,name2
bigDataUrl https://genomeark.s3.amazonaws.com/species/$sn/$sp/assembly_curated/gene/${sp}_v2.0_CatRefConsensus_v3.bb
searchTrix https://genomeark.s3.amazonaws.com/species/Gorilla_gorilla/mGorGor1/assembly_curated/gene/${sp}_v2.0_CatRefConsensus_v3.ix
searchTable ${sp}_v2.0_CatRefConsensus_v3

# RefSeq Gene Annotation
...
```