# Using GenArk version as the reference

* Link to the hub: https://research.nhgri.nih.gov/CustomTracks/T2T_hubs/T2T_GenArk/hub.txt
* [Hub Connect](https://genome.ucsc.edu/cgi-bin/hgHubConnect?hgHub_do_redirect=on&hgHubConnect.remakeTrackHub=on&hgHub_do_firstDb=1&hubUrl=https://research.nhgri.nih.gov/CustomTracks/T2T_hubs/T2T_GenArk/hub.txt)

## `genomes.txt`
Leave only
```
genome [RefSeq Acc.]
trackDb
groups
```

## Copying over trackDb.txt files
```shell
for i in $(seq 1 6)
do
  sp=`sed -n ${i}p ../incoming/path.txt | awk '{print $1}'`
  mkdir -p ${sp}_v2.0
  cp ../T2Tgenomes/${sp}_v2.0/*.txt ${sp}_v2.0/
done
```
