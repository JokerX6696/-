#!/bin/env python3
fi = open('snp.annotation.xls','r')
data = fi.readlines()
fi.close

fo1 = open('snp_zcy-vs-zmy.same.xls','w')
fo2 = open('snp_zmy-vs-zjl.same.xls','w')
print(data[0],end='',file=fo1)
print(data[0],end='',file=fo2)
#exit()
for line in data:
    if 'GeneDetail.refGene' in line:
        continue
    
    zcy = line.split('\t')[5].split(' ')[0]
    zjl = line.split('\t')[6].split(' ')[0]
    zmy = line.split('\t')[7].split(' ')[0]
    all = line.split('\t')

    if zcy ==zmy and zcy != './.' and zcy != '0/0':
        print(line,end='',file=fo1)

    if zjl ==zmy and zjl != './.' and zjl != '0/0':
        print(line,end='',file=fo2)

fo1.close
fo2.close

fi = open('indel.annotation.xls','r')
data = fi.readlines()
fi.close

fo1 = open('indel_zcy-vs-zmy.same.xls','w')
fo2 = open('indel_zmy-vs-zjl.same.xls','w')
print(data[0],end='',file=fo1)
print(data[0],end='',file=fo2)
#exit()
for line in data:
    if 'GeneDetail.refGene' in line:
        continue
    
    zcy = line.split('\t')[5].split(' ')[0]
    zjl = line.split('\t')[6].split(' ')[0]
    zmy = line.split('\t')[7].split(' ')[0]
    all = line.split('\t')

    if zcy ==zmy and zcy != './.' and zcy != '0/0':
        print(line,end='',file=fo1)

    if zjl ==zmy and zjl != './.' and zjl != '0/0':
        print(line,end='',file=fo2)

fo1.close
fo2.close

import os

os.system('''awk -F "\t" '{OFS="\t";$7="";print$0}' snp_zcy-vs-zmy.same.xls |sed 's/\t\t/\t/g' >1 && mv 1 snp_zcy-vs-zmy.same.xls''')
os.system('''awk -F "\t" '{OFS="\t";$6="";print$0}' snp_zmy-vs-zjl.same.xls |sed 's/\t\t/\t/g' >1 && mv 1 snp_zmy-vs-zjl.same.xls''')
os.system('''awk -F "\t" '{OFS="\t";$7="";print$0}' indel_zcy-vs-zmy.same.xls |sed 's/\t\t/\t/g' >1 && mv 1 indel_zcy-vs-zmy.same.xls''')
os.system('''awk -F "\t" '{OFS="\t";$6="";print$0}' indel_zmy-vs-zjl.same.xls |sed 's/\t\t/\t/g' >1 && mv 1 indel_zmy-vs-zjl.same.xls''')
