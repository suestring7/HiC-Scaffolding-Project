#!/bin/bash
#$ -m beas
#$ -q bio,adl,sf,pub64,free64 

ref=$1
workDir=$2
splitDir=$workDir/split
echo $1
echo $2
[ -d $splitDir ] || mkdir -p $splitDir
mv $workDir/*READ* $splitDir
qsub -N bwa_r1_$2 ~/software/mytools/general/BWA.sh -r $ref -n 1 $splitDir/*READ1*
qsub -N bwa_r2_$2 ~/software/mytools/general/BWA.sh -r $ref -n 1 $splitDir/*READ2*
qsub -N mnd_$2 -hold_jid bwa_r1_$2,bwa_r2_$2 ~/software/mytools/juicer-pipeline/run-mnd.sh $2
