#!/bin/bash
#$ -m beas
#$ -q bio,adl,sf,pub64,free64 
#$ -hold_jid salsa-pp

module load bedtools

mkdir bed
LABEL=$1
bedtools bamtobed -i rep/$1.bam > bed/$1.bed
sort -k 4 bed/$1.bed > tmp$1 && mv tmp$1 bed/$1.bed
