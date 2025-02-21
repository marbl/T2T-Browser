# Segmental Duplications (SD)

Provided by Dongahn Yoo.
Downloaded from `https://eichlerlab.gs.washington.edu/public/primate_T2T_SDs/v2.0_chromosome_names_fix/`


```shell
wget --no-check-certificate --no-parent -r --reject "index.html*" https://eichlerlab.gs.washington.edu/public/primate_T2T_SDs/v2.0_chromosome_names_fix/


# Replace chr names - fixed, no more required
grep AG05252_PPY ChrDic.txt | awk '{print $3"\t"$2}' > mPonPyg2.chrDic.txt
grep AG18354_PTR ChrDic.txt | awk '{print $3"\t"$2}' > mPanTro3.chrDic.txt
java -jar -Xmx256m ~/codes/txtReplaceWords.jar mPanTro3.chrDic.txt AG18354_PTR.hap1.SDs.bed 1 | java -jar -Xmx256m ~/codes/txtReplaceWords.jar mPanTro3.chrDic.txt - 10 > mPanTro3.hap1.SD.bed

# bed to bigBed
module load ucsc

head -n1 Jim_GGO.hap1.SDs.bed > header.txt
cat header.txt > mGorGor1_v2.0_SD.bed

sm=Jim_GGO
sp=mGorGor1
cat $sm.hap*.bed | awk '$1 !~ /^#/' | sort -k1,1V -k2,2n >> ${sp}_v2.0_SD.bed
bedToBigBed -type=bed9+35 ${sp}_v2.0_SD.bed ../../../browser/${sp}_v2.0/${sp}_v2.0.sizes ${sp}_v2.0_SD.bb

sm=PR00251_PPA
sp=mPanPan1
cat $sm.hap*.bed | awk '$1 !~ /^#/' | sort -k1,1V -k2,2n >> ${sp}_v2.0_SD.bed
bedToBigBed -type=bed9+35 ${sp}_v2.0_SD.bed ../../../browser/${sp}_v2.0/${sp}_v2.0.sizes ${sp}_v2.0_SD.bb

sm=AG18354_PTR
sp=mPanTro3
cat $sm.hap*.bed | awk '$1 !~ /^#/' | sort -k1,1V -k2,2n >> ${sp}_v2.0_SD.bed
bedToBigBed -type=bed9+35 ${sp}_v2.0_SD.bed ../../../browser/${sp}_v2.0/${sp}_v2.0.sizes ${sp}_v2.0_SD.bb

sm=AG06213_PAB
sp=mPonAbe1
cat $sm.hap*.bed | awk '$1 !~ /^#/' | sort -k1,1V -k2,2n >> ${sp}_v2.0_SD.bed
bedToBigBed -type=bed9+35 ${sp}_v2.0_SD.bed ../../../browser/${sp}_v2.0/${sp}_v2.0.sizes ${sp}_v2.0_SD.bb

sm=AG05252_PPY
sp=mPonPyg2
cat $sm.hap*.bed | awk '$1 !~ /^#/' | sort -k1,1V -k2,2n >> ${sp}_v2.0_SD.bed
bedToBigBed -type=bed9+35 ${sp}_v2.0_SD.bed ../../../browser/${sp}_v2.0/${sp}_v2.0.sizes ${sp}_v2.0_SD.bb

sm=Jambi_SSY
sp=mSymSyn1
cat $sm.hap*.bed | awk '$1 !~ /^#/' | sort -k1,1V -k2,2n >> ${sp}_v2.0_SD.bed
bedToBigBed -type=bed9+35 ${sp}_v2.0_SD.bed ../../../browser/${sp}_v2.0/${sp}_v2.0.sizes ${sp}_v2.0_SD.bb

cat $sm.hap*.bed | awk '$1 !~ /^#/' | sort -k1,1V -k2,2n >> ${sp}_v2.0_SD.bed
bedToBigBed -type=bed9+35 ${sp}_v2.0_SD.bed ../../../browser/${sp}_v2.0/${sp}_v2.0.sizes ${sp}_v2.0_SD.bb

sm=HG002
sp=HG002
cat $sm.hap*.bed | awk '$1 !~ /^#/' | sort -k1,1V -k2,2n >> ${sp}_v2.0_SD.bed
bedToBigBed -type=bed9+35 ${sp}_v2.0_SD.bed ../../../browser/${sp}_v2.0/${sp}_v2.0.sizes ${sp}_v2.0_SD.bb

sm=Human
sp=T2T-CHM13v2.0
cat $sm.hap*.bed | awk '$1 !~ /^#/' | sort -k1,1V -k2,2n >> ${sp}_SD.bed
bedToBigBed -type=bed9+35 ${sp}_SD.bed ../../../browser/${sp}/chm13v2.0.sizes ${sp}_SD.bb

for sp in mGorGor1 mPanPan1 mPanTro3 mPonAbe1 mPonPyg2 mSymSyn1
do
cd ../${sp}_v2.0/
mkdir -p bbi && cd bbi
ln -s ../../../primates/SD/primate_T2T_SDs/${sp}_v2.0_SD.bb segDups.bb
cd ../
done

```