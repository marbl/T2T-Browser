#!/bin/sh

module load ucsc

wigToBigWig approach1.scores_v0.1.wig ../../../T2Tgenomes/T2T-CHM13v2.0/chm13v2.0.sizes approach1.scores_v0.1.bw
