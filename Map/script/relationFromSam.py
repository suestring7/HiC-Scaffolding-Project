import sys, os
sam=open(sys.argv[1],'r')
out1=open(sys.argv[1]+'.mid','w')

pscf=0
pname=''
print>>out1, 'Gene\t'+'Scaffold\t'+'Scaffold_Pos'
for read in sam:
	info=read.split()
	name=info[0]
	scf=info[2]
        mb=format(float(info[3])/1000000,'.2f')
	if scf!="*":
		scf=scf.split('_')[-1]
		if scf!=pscf:
			pscf=scf
		elif name==pname:
			print>>out1, name+'\t'+scf+'\t'+mb
	pname=name
sam.close()
out1.close()
