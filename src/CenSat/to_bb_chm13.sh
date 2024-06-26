#!/bin/sh

module load ucsc

java -jar -Xmx256m ../../src/txtReplaceWords.jar color_replace_chm13.txt chm13v2.0_censat_v2.0.bed 9 > chm13v2.0_censat_v2.1.bed
cp chm13v2.0_censat_v2.1.bed chm13v2.0_censat_v2.1.short.bed
## chm13v2.0_censat_v2.1.short.bed: Manually edit COMP-RPMY that are too long to fit in 256 characters. <-- Caused bedToBigBed conversion issues

# Recolor rDNA
java -jar -Xmx256m ../../src/txtReplaceWords.jar rDNA_recolor.txt chm13v2.0_censat_v2.1.short.bed 9 > chm13v2.0_censat_v2.1.short.rDNArecolor.bed
bedToBigBed -type=bed9 -tab chm13v2.0_censat_v2.1.short.rDNArecolor.bed ../../T2Tgenomes/T2T-CHM13v2.0/chm13v2.0.sizes chm13v2.0_censat_v2.1.bb
aws s3 cp chm13v2.0_censat_v2.1.bb s3://human-pangenomics/T2T/browser/CHM13/bbi/censat_v2.1.bb