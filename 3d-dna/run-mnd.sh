#!/bin/bash
#$ -N make_mnd
#$ -q bio,adl,sf
#$ -m beas
#$ -ckpt blcr

workDir=$1
#the place where you want to put your work in.
scriptDir="/data/users/ytao7/software/mytools/juicer-pipeline"
outputdir="${workDir}/output"
splitdir="${workDir}/split"
tmpdir="${workDir}/tmp"

[ -d $outputdir ] || mkdir -p $outputdir
[ -d $splitdir ] || mkdir -p $splitdir
[ -d $tmpdir ] || mkdir -p $tmpdir

#be sure to name your sam file in the same format OR change the recognized string below
read1str="READ1"
#put the samfile in the splitdir you choose
read1=${splitdir}"/*${read1str}*.align2ref.sam"

for i in ${read1}
do
    ext=${i##*$read1str}
    name=${i%$read1str*}
    library=${name##${splitdir}/} 
    sort -T $tmpdir -k1,1 ${name}READ1$ext > ${name}1${ext}_sort.sam
    sort -T $tmpdir -k1,1 ${name}READ2$ext > ${name}2${ext}_sort.sam

    awk 'BEGIN{OFS="\t"}NF>=11{$1=$1"/1"; print}' ${name}1${ext}_sort.sam > ${name}1${ext}_sort1.sam
    awk 'BEGIN{OFS="\t"}NF>=11{$1=$1"/2"; print}' ${name}2${ext}_sort.sam > ${name}2${ext}_sort1.sam
    
    sort -T $tmpdir -k1,1 -m ${name}1${ext}_sort1.sam ${name}2${ext}_sort1.sam > ${name}${ext}.sam
   
    touch ${name}${ext}_norm.txt ${name}${ext}_abnorm.sam ${name}${ext}_unmapped.sam 
    awk -v "fname1"=${name}${ext}_norm.txt -v "fname2"=${name}${ext}_abnorm.sam -v "fname3"=${name}${ext}_unmapped.sam -f ${scriptDir}/scripts/chimeric_blacklist.awk $name$ext.sam
    awk '{printf("%s %s %s %d %s %s %s %d", $1, $2, $3, 0, $4, $5, $6, 1); for (i=7; i<=NF; i++) {printf(" %s",$i);}printf("\n");}' $name${ext}_norm.txt > $name${ext}.frag.txt           
    sort -T $tmpdir -k2,2d -k6,6d -k4,4n -k8,8n -k1,1n -k5,5n -k3,3n $name${ext}.frag.txt > $name${ext}.sort.txt
    touch ${outputdir}/${library}_dups.txt
    touch ${outputdir}/${library}_optdups.txt
    touch ${outputdir}/${library}_merged_nodups.txt
    awk -f ${scriptDir}/scripts/dups.awk -v name="${outputdir}/${library}_" $name${ext}.sort.txt 
done
sort -T $tmpdir -m -k2,2d -k6,6d -k4,4n -k8,8n -k1,1n -k5,5n -k3,3n $splitdir/*.sort.txt  > $outputdir/merged_sort.txt
touch ${outputdir}/dups.txt
touch ${outputdir}/optdups.txt      
touch ${outputdir}/merged_nodups.txt
awk -f ${scriptDir}/scripts/dups.awk -v name=${outputdir}/ ${outputdir}/merged_sort.txt
