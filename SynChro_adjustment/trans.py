import sys,os
import re
import tempfile
## Input: 
## $1 the svg file in 11Blocks/Delta2/G1fG2 directory
## $2 the generate file name
## $3 the ratio you wanna use
In=open(sys.argv[1],"r")
Out1=open("S1_"+sys.argv[2],"w")
Ratio=int(sys.argv[3])
Temp=open(next(tempfile._get_candidate_names()),'w') 

def base(matched):
	match1=matched.group(1)
	match3=matched.group(3)
	value = int(matched.group('value'))
	return match1+str((value-90)/Ratio+90)+match3

f=0
y=0
maxy=0
k=0
## Change the clist as you want | Since the default list are all numbers
#clist=['Rattus','X','1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','Peromyscus','4','1','9','6','5','2','8b','23','20','*','17','18','22','8a','13','12','19','11','15','14','7','10','3','X']
clist=['Mus','X','Y','1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','Peromyscus','4','1','9','6','5','2','8b','23','20','*','17','18','22','8a','13','12','19','11','15','14','7','10','3','X']
for lines in In:
	line=lines.strip()
	nline=line
	if line=="": 
		continue
	if line[1]=="s":
		pass
		nline=re.sub('height="(\d+)"',r'ChangeMe',line,flags=re.M)	
	elif line[1]=="t":
		f=1
		if y>maxy: 
			maxy=y
		y=90
		nline=re.sub('> .* <',r'> '+clist[k]+' <',line,flags=re.M)
		k=k+1
	elif line[1]=="r":
		if f==1:
			f=0
			continue
		nline=re.sub('y="(\d+)"',r'y="'+str(y)+'"',line,flags=re.M)
		y+=1
	print(nline, file=Temp)
Temp.close()
Temp=open('temp.txt','r')
Out1.write(re.sub('ChangeMe',r'height="'+str(maxy+25)+'"',Temp.read(),flags=re.M))
Temp.close()
Out1.close()
In.close()
f=0
y=0
maxy=0
In=open("S1_"+sys.argv[2],"r")
Out2=open("S2_"+sys.argv[2],"w")
for lines in In:
        line=lines.strip()
        sline=line
        if line=="":
                print("Haha")
                continue
        if line[1]=="s":
                pass
                sline=re.sub('(height=")(?P<value>\d+)(")',base,line,flags=re.M)
        elif line[1]=="t":
                f=1
                if y>maxy:
                        maxy=y
                y=90
        elif line[1]=="r":
                if f==1:
                        sline=re.sub('(height=")(?P<value>\d+)(")',base,line,flags=re.M)
                        f=0
                        continue
                sline=re.sub('(y=")(?P<value>\d+)(")',base,line,flags=re.M)
                y+=1
        print(sline, file=Out2)
In.close()
Out2.close()
