import sys, os
import re

In=open(sys.argv[1],"r")
Out1=open("ro_"+sys.argv[1],"w")
## Manually edit the list order here
slist=[4,1, 10, 6, 5, 2, 9, 23, 21, 17, 18, 19, 22, 8, 14, 13, 20, 12, 16, 15, 7, 11, 3,     0]
rdict={i*25+675:slist[i]*25+675 for i in range(24)}
tdict={i*25+676:slist[i]*25+676 for i in range(24)}
def base(matched):
	match1=matched.group(1)
	match3=matched.group(3)
	value = int(matched.group('value'))
	if value in rdict:
		value=rdict[value]
	if value in tdict:
		value=tdict[value]
	return match1+str(value)+match3
for lines in In:
	line=lines.strip()
	nline=line
	if line=="":
		continue
	if line[1]=="r" or line[1]=="t":
		nline=re.sub('(x=")(?P<value>\d+)(")',base,line,flags=re.M)
	print(nline, file=Out1)

In.close()
Out1.close()
