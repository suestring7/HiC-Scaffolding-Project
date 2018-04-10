#! /bin/bash
#$ -m beas
#$ -q bio,abio,adl,sf
#$ -pe openmp 12

##########################################
# ARIMA GENOMICS MAPPING PIPELINE 100617 #
##########################################

#Below find the commands used to map HiC data. 

#Replace the variables at the top with the correct paths for the locations of files/programs on your system. 

#This bash script will map one paired end HiC dataset (read1 & read2 fastqs). Feel to modify and multiplex as you see fit to work with your volume of samples and system. 

##########################################
# Commands #
##########################################

module load bwa
module load samtools
module load java/1.8.0.51
BWA='bwa'
SAMTOOLS='samtools'
PICARD='/data/users/ytao7/software/picard.jar'
PIP_DIR='/data/users/ytao7/software/mapping_pipeline-master'
FILTER=$PIP_DIR'/filter_five_end.pl'
COMBINER=$PIP_DIR'/two_read_bam_combiner.pl'

SRA=$1
LABEL=$2
REP_LABEL=$LABEL\_$3
IN_DIR=$4
OUT_DIR=$5
REF=$6
FAIDX=$REF'.fai'
RAW_DIR=$OUT_DIR'/raw'
FILT_DIR=$OUT_DIR'/filter'
TMP_DIR=$OUT_DIR'/tmp'
PAIR_DIR=$OUT_DIR'/pair'
REP_DIR=$OUT_DIR'/rep'
MERGE_DIR=$OUT_DIR'/merge'
MAPQ_FILTER=10


echo "### Step 0: Check output directories exist & create them as needed"
[ -d $RAW_DIR ] || mkdir -p $RAW_DIR
[ -d $FILT_DIR ] || mkdir -p $FILT_DIR
[ -d $TMP_DIR ] || mkdir -p $TMP_DIR
[ -d $PAIR_DIR ] || mkdir -p $PAIR_DIR
[ -d $REP_DIR ] || mkdir -p $REP_DIR
[ -d $MERGE_DIR ] || mkdir -p $MERGE_DIR

echo "### Step 1.A: FASTQ to BAM (1st)"
$BWA mem -t 12 -B 8 $REF $IN_DIR/$SRA-READ1-Sequences.txt.gz | $SAMTOOLS view -Sb - > $RAW_DIR/$SRA\_1.bam

echo "### Step 1.B: FASTQ to BAM (2nd)"
$BWA mem -t 12 -B 8 $REF $IN_DIR/$SRA-READ2-Sequences.txt.gz | $SAMTOOLS view -Sb - > $RAW_DIR/$SRA\_2.bam

echo "### Step 2.A: Filter 5' end (1st)"
$SAMTOOLS view -h $RAW_DIR/$SRA\_1.bam | perl $FILTER | $SAMTOOLS view -Sb - > $FILT_DIR/$SRA\_1.bam

echo "### Step 2.B: Filter 5' end (2nd)"
$SAMTOOLS view -h $RAW_DIR/$SRA\_2.bam | perl $FILTER | $SAMTOOLS view -Sb - > $FILT_DIR/$SRA\_2.bam

echo "### Step 3A: Pair reads & mapping quality filter"
perl $COMBINER $FILT_DIR/$SRA\_1.bam $FILT_DIR/$SRA\_2.bam $SAMTOOLS $MAPQ_FILTER | $SAMTOOLS view -bS -t $FAIDX - | $SAMTOOLS sort -o $TMP_DIR/$SRA.bam -

echo "### Step 3.B: Add read group"
java -Xmx2g -jar $PICARD AddOrReplaceReadGroups INPUT=$TMP_DIR/$SRA.bam OUTPUT=$PAIR_DIR/$SRA.bam ID=$SRA LB=$SRA SM=$LABEL PL=ILLUMINA PU=none

###############################################################################################################################################################
###                                           How to Accommodate Technical Replicates                                                                       ###
### This pipeline is currently built for processing a single sample with one read1 and read2 fastq file.                                                    ###
### Technical replicates (eg. one library split across multiple lanes) should be merged before running the MarkDuplicates command.                          ###
### If this step is run, the names and locations of input files to subsequent steps will need to be modified in order for subsequent steps to run correctly.###          
### The code below is an example of how to merge technical replicates.                                                                                      ###
###############################################################################################################################################################
#	REP_NUM=X #number of the technical replicate set e.g. 1
#	REP_LABEL=$LABEL\_rep$REP_NUM
#	INPUTS_TECH_REPS=('bash' 'array' 'of' 'bams' 'from' 'replicates') #BAM files you want combined as technical replicates
#   example bash array - INPUTS_TECH_REPS=('INPUT=A.L1.bam' 'INPUT=A.L2.bam' 'INPUT=A.L3.bam')
#	java -Xms4G -Xmx4G -jar $PICARD MergeSamFiles $INPUTS_TECH_REPS OUTPUT=$TMP_DIR/$REP_LABEL.bam USE_THREADING=TRUE ASSUME_SORTED=TRUE VALIDATION_STRINGENCY=LENIENT

echo "### Step 4: Mark duplicates"
java -Xms24G -XX:-UseGCOverheadLimit -Xmx24G -jar $PICARD MarkDuplicates INPUT=$PAIR_DIR/$SRA.bam OUTPUT=$REP_DIR/$REP_LABEL.bam METRICS_FILE=$REP_DIR/metrics.$REP_LABEL.txt TMP_DIR=$TMP_DIR ASSUME_SORTED=TRUE VALIDATION_STRINGENCY=LENIENT REMOVE_DUPLICATES=TRUE

$SAMTOOLS index $REP_DIR/$REP_LABEL.bam 

echo "Finished Mapping Pipeline"

#########################################################################################################################################
###                                       How to Accommodate Biological Replicates                                                    ###
### This pipeline is currently built for processing a single sample with one read1 and read2 fastq file.                              ###
### Biological replicates (eg. multiple libraries made from the same sample) should be merged before proceeding with subsequent steps.###
### The code below is an example of how to merge biological replicates.                                                               ###
#########################################################################################################################################
#
#	INPUTS_BIOLOGICAL_REPS=('INPUT=$REP_DIR/peromyscus_hic2_rep1.bam' 'INPUT=$REP_DIR/peromyscus_hic2_rep2.bam') #BAM files you want combined as biological replicates
#   example bash array - INPUTS_BIOLOGICAL_REPS=('INPUT=A_rep1.bam' 'INPUT=A_rep2.bam' 'INPUT=A_rep3.bam')

#	java -Xms4G -Xmx4G -jar $PICARD MergeSamFiles $INPUTS_BIOLOGICAL_REPS OUTPUT=$MERGE_DIR/$LABEL.bam USE_THREADING=TRUE ASSUME_SORTED=TRUE VALIDATION_STRINGENCY=LENIENT

#	$SAMTOOLS index $MERGE_DIR/$LABEL.bam


