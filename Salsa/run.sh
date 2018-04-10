#!/bin/bash
#$ -m beas
#$ -q bio,adl,abio,sf,pub64,free64 
#$ -hold_jid bam2bed.sh

#REF="/share/adl/ytao7/summer/peromyscus_assembly_polished_v1.fasta"
FAI=$REF".fai"
enzyme="GATC"
#format: SRA-READ1-Sequences.txt.gz#
SRA=$1
LABEL=$2
REP=$3
IN=$4
mkdir salsa
cd salsa
mkdir $LABEL
cd $LABEL
OUT='.'
tag=$LABEL\_$REP
qsub -N pre$tag 01_mapping_arima.sh $SRA $LABEL $REP $IN $OUT $REF
qsub -N bam2bed$tag -hold_jid pre$tag bam2bed.sh $tag
qsub -N ss$tag -hold_jid bam2bed$tag runSalsa.sh $REF $FAI bed/$tag.bed $enzyme out/ss$tag yes
