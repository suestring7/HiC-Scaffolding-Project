import sys, os
import matplotlib.pyplot as plt
import pandas as pd

#filter, r.out, mainchrom
#plt.rc('font',size=7)
plt.rc('font',size=10)
data=open(sys.argv[1],'r')
data.readline()

unsort=pd.read_csv(sys.argv[2],sep='\s+',index_col=0)
dictCS=unsort.idxmax(axis=1).to_dict()
dictSC={v: k for k, v in dictCS.iteritems()}
lscaf=open(sys.argv[3],'r')
dictSL={int(x.split()[0][45:]): round(float(x.split()[1])/1000000,2) for x in lscaf}
lscaf.close()
#initiate
nchr=0
pchr=''
pscaf=''
#fig=plt.figure(figsize=(49,120))
plt.figure(figsize=(36,80), dpi=10)
#setting
cr=0.2
sr=0.1
width=8
pad=0.2
#lx=7
lx=6
ly=25
bx=1
by=1
xcs=2
xt=1
yt=1.5
xct=0
xst=0
yst=1
#mR
#strand=[1,0,0,1,1,0,1,0,0,1,0,1,0,0,0,0,1,1,0,0,1,0,1,0,0]
#pp
strand=[0,1,1,1,0,1,1,1,1,0,1,0,0,1,1,0,1,1,0,1,1,1,1,1,0]
#p1
#strand=[1,0,0,1,1,0,1,0,0,1,0,1,0,0,0,1,1,1,0,0,1,0,1,0,0]

for gene in data:
	info=gene.split()
	gscaf=int(float(info[3]))
	if gscaf > 24:
		continue
	gname=info[0]
	gchr=info[1]
	cpos=float(info[2])
	spos=float(info[4])
	if gchr != pchr:
		if nchr != 0:
			plt.plot([xc0,xc0],[y0-pad,ycn+pad],'#ff7f0e')
#			plt.axis('equal')
#			plt.axis('off')
#			plt.show()
#			fig=plt.figure(figsize=(4,30))
		nchr+=1
		pchr=gchr
		pscaf=int(dictCS[pchr])
		xc0=((nchr-1)%width)*lx+bx
		y0=((nchr-1)//width)*ly+by
#		xc0=0
#		y0=0
		xs0=xc0+xcs
		asm,=plt.plot([xs0,xs0],[y0-pad,y0+sr*dictSL[pscaf]+pad],'#1f77b4')	
		plt.text(xc0-xct,y0,'0',horizontalalignment='right')
		plt.text(xs0+xst,y0,'0',horizontalalignment='left')
		plt.text(xc0+xt,y0-yt,r'Chr'+gchr,horizontalalignment='center')
		plt.text(xc0,y0-yst,r'Exp',horizontalalignment='center')
		plt.text(xs0,y0-yst,r'Asm',horizontalalignment='center')
	ycn=y0+cr*cpos
	spos=spos+(1-strand[nchr-1])*(dictSL[pscaf]-2*spos)
	ysn=y0+sr*spos
	if gscaf!=pscaf:
		plt.text(xc0-xct,ycn,gname+':'+str(cpos)+'/'+str(gscaf),horizontalalignment='right',color='red')
		#plt.text(xs0+xst,ysn,str(spos)+' '+gname,horizontalalignment='left')
		continue	
	plt.plot([xc0,xs0],[ycn,ysn],'c-+')
	plt.text(xc0-xct,ycn,gname+':'+str(cpos),horizontalalignment='right')
	plt.text(xs0+xst,ysn,str(spos)+' '+gname,horizontalalignment='left')	

exp,=plt.plot([xc0,xc0],[y0-pad,ycn+pad],'#ff7f0e') 
plt.legend([exp,asm], ["Experiment(cm)", "Assembly(Mb)"])
plt.axis('equal')
plt.axis('off')
#plt.xlim(0,50)
#plt.ylim(0,27)
plt.savefig('genome.eps', format='eps', dpi=800)
plt.show()

data.close()
