import pandas as pd
import sys, os
import seaborn as sns
import numpy as np

In=sys.argv[1]
Out=sys.argv[2]
#DictIn=open(sys.argv[3],'r')
#dicC={}
#for idx, lines in enumerate(DictIn):
#	info=lines.split()
#	scaffold=info[0][45:]
#	dicC[int(scaffold)]=idx+1
	
mgsort=pd.read_table(In,index_col=0)
mgsort=mgsort.fillna(-1)
#mgsort['Scaffold']=mgsort['Scaffold'].map(lambda x: 0 if x>25 else x).astype(int)
mgsort=mgsort[mgsort['Scaffold']<=25]
mgsort['Scaffold']=mgsort['Scaffold'].astype(int)
mgsort=mgsort.replace(r'\s+', np.nan, regex=True)
x=mgsort.pivot_table(index='Chr',columns='Scaffold',aggfunc='size',fill_value=0)
x['n']=x.index.str.extract('(\d+)',expand=False).fillna(100).astype(int)
x=x.sort_values('n').drop('n', 1)
#x.rename(columns=dicC,inplace=True)
x=x.reindex_axis(sorted(x.columns,key=lambda x: float(x)),axis=1)
x.to_csv(Out,sep='\t')
#DictIn.close()
#sns_plot=sns.heatmap(x) 
#sns_plot.get_figure().savefig(Out+".png")
