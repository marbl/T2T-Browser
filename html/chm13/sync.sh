#!/bin/sh

module load aws

aws s3 sync --dryrun . s3://human-pangenomics/T2T/browser/CHM13/html/
aws s3 sync . s3://human-pangenomics/T2T/browser/CHM13/html/
