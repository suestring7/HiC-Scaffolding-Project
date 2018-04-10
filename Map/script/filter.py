import pandas as pd
import numpy as np
import sys, os

asm=sys.argv[1]
bwa=pd.read_table(sys.argv[2])
bt2=pd.read_table(sys.argv[3])
mg=bwa.merge(bt2, how='inner').dropna(axis=0,how='any').set_index('Gene').to_csv("/share/adl/ytao7/summer/3d-dna/samToCS/outbnb/"+asm+".filter",sep='\t')
