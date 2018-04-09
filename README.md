# HiC-Scaffolding-Project
This repository contains code to replicate the HiC scaffolding process and analysis of Peromyscus Leucopus.

## Materials and Methods
Animals used in this study were from the *P.leucopus* maintained at University of California, Irvine. Animal care is provided by (??).

#### Scaffolding for *P. Leucopus* (data and implement of the softwares)
##### Hi-C library
Two Hi-C libraries sequenced with Illumina paired end sequencing (??detail) of *Peromyscus Leucopus*, p1, p2 were collected by (??), with coverage (??) and (??) respectively. A pool of both p1 and p2 called pp was also used as a different setting. 

##### Choose between the two software
Two Hi-C assembly programs, 3d-dna(cite) and SALSA(cite), which represent 2 different assembly strategies, were selected for assembly of the original contigs. For each assembly procedure, we set 3 different series of libraries: p1, p2, pp.

To compare how the different programs work, we plotted dot plot of the scaffold which matches to chromosome 3 between each pair of assembly within the 6 assemblies using MUMmer v4(cite). (Figure)


##### Finding proper cluster number(chromosome number)
According to previous study(cite), we suspect *P. Leucospus* to have the same amount of chromosomes:24. We tried 22-27 as the chromosome parameter input (Figure:==TODO: Is there a better figure to plot here?==), and from which we picked 24 as the optimum parameter. Although all the parameters remain the same problems: (1) Separate chromosome 8a and chromosome 8b which is also described as different linkage groups in previous study(cite).(2) Fused chromosome 16 and chromosome 21 which is hard to split. We picked 24 since 23 starts to combine two other chromosomes and 25 starts to split another chromosome. 

##### Coverage matters
We noticed that p1 and p2 has different coverage, and we want to know to what extent would the coverage matter. We measured it through the agreement between different assembly under the same coverage. We downsampled our p1, p2 and pp library to create the different samples. The result are shown in (Figure: the diagonal and Figure S ). We see that the pp has the best convergence performance while p1 and p2's coverage is not enough to produce the similar result as their downsampled sample.

We conclude that the coverage of pp is better than p1 and p2 which should contribute to a better assembly which is robust to the data.

#### Accuracy, contiguity, integrity (choose)
Scaffolds generated from each assembly process were mapped to a published linkage map of *P. maniculatus * (cite;a close relative to *P. leucopus*) of 196 genetic markers with a hybrid of BWA and Bowtie2. We calculate the accuracy with ![](http://chart.googleapis.com/chart?cht=tx&chl=A=\frac{N_M}{N_A})
, the  precision with ![](http://chart.googleapis.com/chart?cht=tx&chl=P=\frac{N_C}{N_M}), the recall with ![](http://chart.googleapis.com/chart?cht=tx&chl=R=\frac{N_C}{N_A}), the F1 Score, where ![](http://chart.googleapis.com/chart?cht=tx&chl=N_M) represent the number of mapped markers, ![](http://chart.googleapis.com/chart?cht=tx&chl=N_A) represent the number of all the markers and ![](http://chart.googleapis.com/chart?cht=tx&chl=N_C) represent the number of markers that mapped to correct scaffolds respectively. (Table)

The integrity was calculated using BUSCO v3 (cite). (Table)

The contiguity was shown by the cumulative scaffolds length plot. (Figure)

Outcome with optimal accuracy and integrity was chosen as the best performance of each assembler.

To be honest, we choose it for less corrections and better score.

#### Construction of synteny maps
Synteny maps were created using SynChro (Drillon G, Carbone A and Fischer G (2014)). The amino acid sequence of *P. leucopus* were created by mapping previous(??where you did the annotation) data to the scaffolded genome using blat. The *Rattus Norvegicus* data were downloaded from Genbank. We did some modification using ...

![](SyntenyBlocks.pdf)


## Supplement
##### Find proper threshold
(Figure S?)

##### Coverage
(Figure S?)

