# IsoSeq

## Testis IsoSeq bams
Additional Iso-Seq testis data was provided by Prajna Hebbar on Aug. 14, 2025.

Downloaded from:
```
# download.list
https://public.gi.ucsc.edu/~pnhebbar/t2t_autosomes/assemblyHub/GCA_029281585.2/gorGor_testis.bam
https://public.gi.ucsc.edu/~pnhebbar/t2t_autosomes/assemblyHub/GCA_029281585.2/gorGor_testis.bam.bai 
https://public.gi.ucsc.edu/~pnhebbar/t2t_autosomes/assemblyHub/GCA_029289425.2/panPan_testis.bam
https://public.gi.ucsc.edu/~pnhebbar/t2t_autosomes/assemblyHub/GCA_029289425.2/panPan_testis.bam.bai
https://public.gi.ucsc.edu/~pnhebbar/t2t_autosomes/assemblyHub/GCA_028858775.2/panTro_testis.bam
https://public.gi.ucsc.edu/~pnhebbar/t2t_autosomes/assemblyHub/GCA_028858775.2/panTro_testis.bam.bai
https://public.gi.ucsc.edu/~pnhebbar/t2t_autosomes/assemblyHub/GCA_028885625.2/ponPyg_testis.bam
https://public.gi.ucsc.edu/~pnhebbar/t2t_autosomes/assemblyHub/GCA_028885625.2/ponPyg_testis.bam.bai
https://public.gi.ucsc.edu/~pnhebbar/t2t_autosomes/assemblyHub/GCA_028885655.2/ponAbe_testis.bam
https://public.gi.ucsc.edu/~pnhebbar/t2t_autosomes/assemblyHub/GCA_028885655.2/ponAbe_testis.bam.bai
```
Download
```sh
for f in $(cat download.list)
do
  if ! [[ -s $f ]]; then
    wget --no-verbose $f
  fi
done
```

Rename
```sh
path=../path.txt

for i in $(seq 1 5)
do
  sp=`sed -n ${i}p $path | awk '{print $1}'`
  ss=`sed -n ${i}p $path | awk '{print $6}'`

  rename -v ${ss}_ ${sp}_v2.0.IsoSeq_ *_testis*
done
```

Upload
```sh
module load aws
for i in $(seq 1 5)
do
  sp=`sed -n ${i}p $path | awk '{print $1}'`
  sn=`sed -n ${i}p $path | awk '{print $3}'`
  
  aws s3 cp --profile=vgp --recursive --exclude "*" --include "${sp}_v2.0.IsoSeq_*.bam*" ./ s3://genomeark/species/$sn/$sp/assembly_curated/expression/
done
```

## Cell line bams
Data was provided by Prajna Hebbar's hub on UCSC on Mar. 28 2024.

```shell
module load aws

path=../path.txt

## Download
for i in $(seq 1 6)
do
  sp=`sed -n ${i}p $path | awk '{print $1}'`
  sn=`sed -n ${i}p $path | awk '{print $3}'`
  GCA=`sed -n ${i}p $path | awk '{print $4}'`
  ss=`sed -n ${i}p $path | awk '{print $6}'`
  
  wget https://public.gi.ucsc.edu/~pnhebbar/t2t_autosomes/assemblyHub/$GCA/0_${ss}_IsoSeq_1.final.bam
  wget https://public.gi.ucsc.edu/~pnhebbar/t2t_autosomes/assemblyHub/$GCA/0_${ss}_IsoSeq_1.final.bam.bai
  wget https://public.gi.ucsc.edu/~pnhebbar/t2t_autosomes/assemblyHub/$GCA/1_${ss}_IsoSeq_2.final.bam
  wget https://public.gi.ucsc.edu/~pnhebbar/t2t_autosomes/assemblyHub/$GCA/1_${ss}_IsoSeq_2.final.bam.bai
  
  # rename
  rename -v 0_${ss}_ ${sp}_v2.0. *_IsoSeq_*
  rename -v 1_${ss}_ ${sp}_v2.0. *_IsoSeq_*
done


# Rename and upload
for i in $(seq 1 6)
do
  sp=`sed -n ${i}p $path | awk '{print $1}'`
  sn=`sed -n ${i}p $path | awk '{print $3}'`
  GCA=`sed -n ${i}p $path | awk '{print $4}'`
  ss=`sed -n ${i}p $path | awk '{print $6}'`
  rename -v 0_${ss}_ ${sp}_v2.0. *_IsoSeq_*
  rename -v 1_${ss}_ ${sp}_v2.0. *_IsoSeq_*
  rename -v .final. _v0.9. *.IsoSeq_*
  
  aws s3 cp --profile=vgp --recursive --exclude "*" --include "${sp}_v2.0.IsoSeq_*_v0.9.bam*" ./ s3://genomeark/species/$sn/$sp/assembly_curated/expression/
done

```
