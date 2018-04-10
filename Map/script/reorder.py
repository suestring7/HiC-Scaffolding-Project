import pandas as pd
import sys,os
In=sys.argv[1] 
Out=sys.argv[2]
nchr=int(sys.argv[3]) 
unsort=pd.read_csv(In,sep='\s+',index_col=0)
imx=unsort.idxmax(axis=1).tolist()
imx.extend([str(x) for x in range(1,nchr) if str(x) not in imx])
unsort.reindex_axis(imx,axis=1).fillna(0).astype(int).to_csv(Out,sep='\t')
