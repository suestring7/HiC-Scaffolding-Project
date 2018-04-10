import pandas as pd
import numpy as np
import sys, os

sam1=sys.argv[1]
sam2=sys.argv[2]
asm1 = pd.read_table("process/"+sam1+".sort.mid",index_col=0).rename(columns={'Scaffold':sam1+"_scf",'Scaffold_Pos':sam1+"_pos"})
asm2 = pd.read_table("process/"+sam2+".sort.mid",index_col=0).rename(columns={'Scaffold':sam2+"_scf",'Scaffold_Pos':sam2+"_pos"})
mg=asm2.merge(asm1, left_index=True,right_index=True,how='outer')
Dict1=open("../main_chr_"+sam1+".txt",'r')
Dict2=open("../main_chr_"+sam2+".txt",'r')
dic1={}
dic2={}
for idx, lines in enumerate(Dict1):
        info=lines.split()
        scaffold=info[0][45:]
        dic1[int(scaffold)]=idx+1
for idx, lines in enumerate(Dict2):
        info=lines.split()
        scaffold=info[0][45:]
        dic2[int(scaffold)]=idx+1
Dict1.close()
Dict2.close()

mg=mg.fillna(-1)
mg[sam1+"_scf"]=mg[sam1+"_scf"].map(lambda x: 0 if x>25 else x).astype(int)
mg[sam2+"_scf"]=mg[sam2+"_scf"].map(lambda x: 0 if x>25 else x).astype(int)
x=mg.pivot_table(index=sam1+'_scf',columns=sam2+'_scf',aggfunc='size',fill_value=0)
x.rename(index=dic1,columns=dic2,inplace=True)  
x=x.reindex(index=range(25),columns=range(25),fill_value=0)
x.to_csv(sam1+"VS"+sam2,sep='\t')

