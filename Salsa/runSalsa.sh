#!/bin/bash
#$ -m beas
#$ -q bio,adl,sf,pub64,free64 

module load enthought_python

contigs=$1
fai=$2
bed=$3
enzyme=$4
scaffold=$5
modify=$6

python /data/users/ytao7/software/SALSA/run_pipeline.py -a $contigs -l $fai -b $bed -e $enzyme -o $scaffold -m $modify

