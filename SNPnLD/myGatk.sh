#!/bin/bash
#$ -N gatk
#$ -q bio,adl,abio,sf,pub64,krt,krti,free88i,free16i
#$ -pe make 32 
#$ -R y

module load bwa/0.7.8
module load samtools/1.3
module load bcftools/1.3
module load enthought_python/7.3.2
module load gatk/2.4-7
module load picard-tools/1.87
module load java/1.7
module load tophat/2.1.0
module load bowtie2/2.2.7
module load bamtools/2.3.0 

ref=$1
region=$2
nMouse=$3
[ ! -d "gatk" ] && mkdir gatk
[ ! -d "gatk/$nMouse" ] && mkdir gatk/$nMouse
merged="gatk/$nMouse/$region.bam"
if [ $region = "All" ]
then
	bamtools merge -list bamfiles.$nMouse.txt >$merged
else
	bamtools merge -list bamfiles.$nMouse.txt -region $region >$merged
fi
samtools index $merged
java -d64 -Xmx128g -jar /data/apps/gatk/2.4-7/GenomeAnalysisTK.jar -T RealignerTargetCreator -nt 32 -R $ref -I $merged --minReadsAtLocus 4 -o $merged.intervals
java -d64 -Xmx20g -jar /data/apps/gatk/2.4-7/GenomeAnalysisTK.jar -T IndelRealigner -R $ref -I $merged -targetIntervals $merged.intervals -LOD 3.0 -o $merged-realigned.bam
java -d64 -Xmx128g -jar /data/apps/gatk/2.4-7/GenomeAnalysisTK.jar -T UnifiedGenotyper -nt 32 -R $ref -I $merged-realigned.bam -gt_mode DISCOVERY -stand_call_conf 30 -stand_emit_conf 10 -o $merged.rawSNPS-Q30.vcf
java -d64 -Xmx128g -jar  /data/apps/gatk/2.4-7/GenomeAnalysisTK.jar -T UnifiedGenotyper -nt 32 -R $ref -I $merged-realigned.bam -gt_mode DISCOVERY -glm INDEL -stand_call_conf 30 -stand_emit_conf 10 -o $merged.inDels-Q30.vcf
java -d64 -Xmx20g -jar /data/apps/gatk/2.4-7/GenomeAnalysisTK.jar -T VariantFiltration -R $ref -V $merged.rawSNPS-Q30.vcf --mask $merged.inDels-Q30.vcf --maskExtension 5 --maskName InDel --clusterWindowSize 10 --filterExpression "MQ0 >= 4 && ((MQ0 / (1.0 * DP)) > 0.1)" --filterName "BadValidation" --filterExpression "QUAL < 30.0" --filterName "LowQual" --filterExpression "QD < 5.0" --filterName "LowVQCBD" --filterExpression "FS > 60" --filterName "FisherStrand" -o $merged.Q30-SNPs.vcf
cat $merged.Q30-SNPs.vcf | grep 'PASS\|^#' > $merged.pass.SNPs.vcf
cat $merged.inDels-Q30.vcf | grep 'PASS\|^#' > $merged.pass.inDels.vcf
bgzip -c $merged.pass.SNPs.vcf >$merged.pass.SNPs.vcf.gz
tabix -p vcf $merged.pass.SNPs.vcf.gz
bgzip -c $merged.pass.inDels.vcf >$merged.pass.inDels.vcf.gz
tabix -p $merged.pass.inDels.vcf.gz

