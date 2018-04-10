## Materials and Methods
Animals used in this study were from the *P.leucopus* maintained at University of California, Irvine. Animal care is provided by (??).

#### Scaffolding for *P. Leucopus* (data and implement of the softwares)
##### Hi-C library
Two Hi-C libraries sequenced with Illumina paired end sequencing (??detail) of *Peromyscus Leucopus*, p1, p2 were collected by (??), with coverage (??) and (??) respectively. A pool of both p1 and p2 called pp was also used as a different setting. 

##### Linkage Map
Scaffolds generated from each assembly process were mapped to a published linkage map of *P. maniculatus * (cite;a close relative to *P. leucopus*) of 196 genetic markers with a hybrid of BWA and Bowtie2. 

The scripts that do the mapping and other functions are sorted and described in the `Map` finder. 

##### Choose between the two software
Two Hi-C assembly programs, 3d-dna(cite) and SALSA(cite), which represent 2 different assembly strategies, were selected for assembly of the original contigs. For each assembly procedure, we set 3 different series of libraries: p1, p2, pp.

To compare how the different programs work, we plotted dot plot of the scaffold which matches to chromosome 3 between each pair of assembly within the 6 assemblies using MUMmer v4(cite). 
![](./Figures/comp_scf.png)
>**Fig 1: Dot plot of differences between assemblies (chr3) using Mummer v4.0.**
SALSA and 3d-dna are the two different programs. Forward matches are plotted in red, reverse matches in blue. We see that comparisons between 3d-dna assemblies show that they are more consistent with one another than SALSA. The 3d-dna down-sampling on the diagonal shows that Hi-C library coverage can impact scaffolding, perhaps converging when both libraries are combined. The SALSA no modification experiment shows that allowing a scaffolder to split contigs has a large impact on the final assembly.

The scripts to run SALSA and 3d-dna properly are sorted in `SALSA`and `3d-dna` finder correspondingly.
The scripts to plot multi mummerplot within a plot is `multi-mummerplot.py`
Usage: 
`python multi-mummerplot.py [OUTPUT_name]`
Note: The script should be run in the same folder as your MUMmerplot output files. And you need to replace those label names and file names within this file with your own parameters. The output of mummerplot are not always oriented the same, in other words, not always along the main diagnonal. Instead of changing the original fasta file and redoing the nucmer alignment, I simply flipped the plot 'manually'. There's an example within the script that you may find helpful.


##### Finding proper cluster number(chromosome number)
According to previous study(cite), we suspect *P. Leucospus* to have 24, the same chromosomes number as other Peromyscus species. We tried 22-27 as the chromosome number parameter input (Figure:==TODO: Is there a better figure to plot here?==), and from which we picked 24 as the optimum parameter. Although all the parameters remain the same problems: (1) Separate chromosome 8a and chromosome 8b which is also described as different linkage groups in previous study(cite).(2) Fused chromosome 16 and chromosome 21 which is hard to split. We picked 24 since 23 starts to combine two other chromosomes and 25 starts to split another chromosome. 

##### Coverage matters
We noticed that p1 and p2 has different coverage, and we want to know to what extent would the coverage matter. We measured it through the agreement between different assembly under the same coverage. We downsampled our p1, p2 and pp library to create the different samples. The result are shown in (Figure: the diagonal and Figure S ). We see that the pp has the best convergence performance while p1 and p2's coverage is not enough to produce the similar result as their downsampled sample.
![](./Figures/comp_scf.png)
We conclude that the coverage of pp is better than p1 and p2 which should contribute to a better assembly that is robust to the data.

Script to downsample: `mytools/general/readDownsample.sh`
Usage: `bash readDownsample.sh [FASTA.gz] [MOD_number] [PREF] [ID]`

#### Accuracy, contiguity, integrity (choose)
![](./Figures/genome.png)
We calculate the accuracy with ![](http://chart.googleapis.com/chart?cht=tx&chl=\Large%20A=\frac{N_M}{N_A})
, the  precision with ![](http://chart.googleapis.com/chart?cht=tx&chl=\Large%20P=\frac{N_C}{N_M}), the recall with ![](http://chart.googleapis.com/chart?cht=tx&chl=\Large%20R=\frac{N_C}{N_A}), the F1 Score, where ![](http://chart.googleapis.com/chart?cht=tx&chl=\Large%20N_M) represent the number of mapped markers, ![](http://chart.googleapis.com/chart?cht=tx&chl=\Large%20N_A) represent the number of all the markers and ![](http://chart.googleapis.com/chart?cht=tx&chl=\Large%20N_C) represent the number of markers that mapped to correct scaffolds respectively. (Table)

The integrity was calculated using BUSCO v3 (cite). 


| Assembly | C  | S  | D  | F  | M  |
| -------- |--- | --- | --- | --- | --- |
| contigs  | 94.60% | 92.10% | 2.50% | 2.10% | 3.30% |
| ***3d-dna/pp*** |94.50%|92.50%|2.00%|2.00%|3.50%|
| SALSA/p2|94.40%|92.50%|1.90%|1.80%|3.80%|
|3d-dna/p1|94.30%|92.30%|2.00%|2.10%|3.60%
|3d-dna/pp*|94.20%|92.20%|2.00%|2.10%|3.70%
|SALSA/pp|94.10%|92.10%|2.00%|2.20%|3.70%
|3d-dna/p2|93.80%|91.60%|2.20%|2.70%|3.50%



>**Table 1: The 3d-dna/pp assembly produces the most complete single copy mammalian BUSCO scores[8].** 
BUSCO determines the percentage of mis-assembled transcripts by trying to align transcripts from highly conserved proteins to each assembly.
C: complete BUSCOs, S: complete single copy BUSCOs, D: complete duplicate copy BUCOs, F: fragment copy BUSCOs, M: missing copy BUSCOs. This being said scaffolding the genome only has a small impact on BUSCO scores.

The contiguity was shown by the cumulative scaffolds length plot, where pp is our chosen assembly.
 ![](./Figures/cum_length_plot.png)
>**Figure: Cumulative scaffolds length plot of different 3d-dna assemblies.** 
>The pp assembly has the largest N25 and N75.


Outcome with optimal accuracy and integrity was chosen as the best performance of each assembler.

To be honest, we choose it for less corrections and better score.

Script to generate the cumulative scaffolds length plot: `mytools/general/cum_length_plot.py`
Usage: `python cum_length_plot.py [FAI1.fai] [FAI2.fai] ...`
Note: In my code, I used the directory's name as the label. `label=faifile.split('/')[0]`You can change that as you need. 

#### Construction of synteny maps
Synteny maps were created using SynChro (Drillon G, Carbone A and Fischer G (2014)). The amino acid sequence of *P. leucopus* were created by mapping previous(??where you did the annotation) data to the scaffolded genome using blat. The *Rattus Norvegicus* data were downloaded from Genbank. We did some modification to make the plot looks more condense.

![](./Figures/SyntenyBlocks.png)

Script to condense the output of SynChro: `mytools/SynChro/trans.py`
Usage:`python trans.py [Sp1.Sp2fSp1.svg] [POSTFIX] [RATIO]` where `[Sp1.Sp2fSp1.svg]` could be found in SynChro's output directory `[Project_path]/21Blocks/Delta2/G1fG2`
Note: Please change the clist to match your data. And the output would be `S1_POSTFIX` and `S2_POSTFIX`, where `S1_POSTFIX` only removes all the blank blocks that indicate no orthology relationships and `S2_POSTFIX` also condenses the blocks. And I change one line in SynChro's original file `ConvertFasta.py`:
From
`listNameCont.sort()`
to
 `listNameCont=sorted(listNameCont, key=lambda x: int('0'+re.sub('\D', '', x)))` 
 to sort the chromosomes in numerical order instead of lexicographical order. e.g. `['1','2','11']` instead of `['1','11','2']`



##Supplement
#####Find proper threshold
(Figure S?)

#####Coverage
(Figure S?)


#### Question
Scaffolding or Assembly?


#### Requirement 
python package:
pandas
matplotlib

