import pandas as pd
import numpy as np
import sys, os

sam=sys.argv[1]
gm = pd.read_table("/share/adl/ytao7/summer/3d-dna/samToCS/GeneMap.txt",index_col=0)
asm = pd.read_table(sam,index_col=0)
mg=gm.merge(asm, left_index=True,right_index=True,how='outer')
mg[['Pos','Scaffold','Scaffold_Pos']]=mg[['Pos','Scaffold','Scaffold_Pos']].astype(float)
mg['nChr']=mg['Chr'].str.extract('(\d+)',expand=False).fillna(100).astype(int)
mgsort=mg.sort_values(["nChr","Chr","Pos",'Scaffold','Scaffold_Pos']).drop('nChr', 1).replace(r'\s+', np.nan, regex=True)
mgsort['Scaffold']=mgsort['Scaffold'].fillna(0).astype(int).astype(str).replace('0',np.nan)
mgsort.to_csv(sam+".all",sep='\t')
