#!/bin/bash
#$ -m beas
#$ -q bio,adl,sf,pub64,free64 

module load enthought_python
module load samtools
USAGE="
******************************
./getRelation.sh 

Options (default value in (), *required):
-w, --which=INT		Process the which blat output. 0 for none, 1 for bwa, 2 for bowtie2, 3 for both(3) 
-f, --filter		Do the filter step(false)
-h, --help		This message
-d, --dict=PATH		Use the fasta file in PATH to create dictionary
-p, --pre=PREFIX	Locate the input assembly by its PREFIX, should be string from p1,p2,pp,mR(*)
-c, --chromosome=INT	the chromosome number(*)
-s, --setname		Locate the input assembly along with the pre
    --step=STEP		Start from STEP, should be string from blat, dict, sort, filter(blat)
    --plot		Plot the assembly from *.r.out. Must have completed all the steps
******************************
"
step='blat'
POSITIONAL=()
chr=""
fasta=""
which=3
filter=0
while [[ $# -gt 0 ]]; do
key=$1
case $key in
    -w|--which) which=$2; shift 2;;
    -f|--filter) filter=1; shift 1;;
    -h|--help) echo "$USAGE"; exit 0;;
    -d|--dict) fasta=$2; shift 2;;
    -p|--pre) pre=$2; shift 2;;
    -c|--chromosomefold) chr=$2; shift 2;;
    -s|--setname) sets=$2; shift 2;;
    --step) step=$2; shift 2;;
    --plot) shift 1;;
    *) echo ":( Illegal options. Exiting."; echo "$USAGE"; exit 1;;
	
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

#assign basic value
prex=$sets"_"$pre
echo $sets
if [[ $sets == "" ]]
then
    prex=$pre"_"$chr
    sets=$chr"set"
fi
sets=$sets"/"
dict="/share/adl/ytao7/summer/3d-dna/main_chr_${prex}.txt"
if [ ! -f $dict ]
then
    if [[ $fasta == "" ]]
    then
        fasta="/share/adl/ytao7/summer/3d-dna/${sets}$pre/peromyscus_assembly_polished_v1.FINAL.from_draft.fasta"
    fi
    echo $fasta
    samtools faidx $fasta
    sort ${fasta}.fai -k2,2rn | cut -f1,2 | head -n $chr > $dict
    echo "create dict file"
fi

#sort those bamfiles   

if (($which%2==1))
then
    sambwa="/share/adl/ytao7/summer/3d-dna/${sets}bwa/${pre}_aln-pe.sam"
    echo $sambwa
    samtools sort $sambwa | samtools view - -o processbwa/${prex}.sort
    python script/relationFromSam.py processbwa/${prex}.sort
    python script/merge.py processbwa/${prex}.sort.mid
    #python script/reindex.py processbwa/${prex}.sort.mid.all outbwa/${prex}.out #$dict
fi
if (($which/2==1))
then
    sambt="/share/adl/ytao7/summer/3d-dna/${sets}bowtie2/${pre}_unstrict.sam"
    echo $sambt
    samtools sort $sambt | samtools view - -o processbt/${prex}.sort
    python script/relationFromSam.py processbt/${prex}.sort
    python script/merge.py processbt/${prex}.sort.mid
    #python script/reindex.py processbt/${prex}.sort.mid.all outbt/${prex}.out #$dict
fi
if [[ $(($filter)) -gt 0 ]]
then
    echo "filtering"
    python script/filter.py $prex processbwa/${prex}.sort.mid.all processbt/${prex}.sort.mid.all
    python script/reindex.py outbnb/${prex}.filter outbnb/${prex}.out #$dict
    python script/reorder.py outbnb/${prex}.out outbnb/${prex}.r.out $chr
fi
