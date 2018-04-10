import pandas as pd
import sys,os
import matplotlib.pyplot as plt

plt.gca().invert_xaxis()
for faifile in sys.argv[1:]:
	fai=pd.read_table(faifile, header=None)
	fai['length']=fai[1]/1000000
	fai=fai.sort_values(by=['length'],ascending=False)
	fai['cum_sum']=fai['length'].cumsum()
	fai['cum_pct']=100*fai['length'].cumsum()/fai['length'].sum()
	plt.plot(fai['length'],fai['cum_pct'],label=faifile.split('/')[0])
plt.xlabel('Contig length (Mb)')
plt.ylabel('Cumulative length proportion (%)')
plt.legend()
#plt.title()
plt.savefig('cum_plot.eps', format='eps', dpi=800)
plt.show()
