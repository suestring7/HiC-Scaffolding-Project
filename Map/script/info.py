import pandas as pd
import numpy as np
import sys, os

sam=sys.argv[1]
info=open(sam+".info",'w')
mgsort = pd.read_table("process/"+sam+".sort.mid.all",index_col=0)
mgsort['Scaffold'] = mgsort['Scaffold'].fillna(-1).map(lambda x: 0 if x>25 else x).astype(int) 
mapped = mgsort[mgsort['Scaffold']!=-1].shape[0]
mapScf = mgsort[mgsort['Scaffold']>0].shape[0]
total = mgsort.shape[0]
percentM = '{:.2%}'.format(mapped*1.0/total)
percentMS = '{:.2%}'.format(mapScf *1.0/total)
print >> info, "Total gene number is:\t"+str(total)+"\nMapped gene number is:\t"+str(mapped)+"\nIt has " + percentM + " in all mapped, " + percentMS + " in all mapped to main 24 scaffolds\n"
list_um = mgsort[mgsort['Scaffold']==-1]['Chr'] 
list_nm = mgsort[mgsort['Scaffold']==0]['Chr'] 
print >> info, "List of not mapped genes is:\n"+str(list_um)+"\n\nList of mapped to other scaffolds genes is:\n"+str(list_nm)
info.close()
