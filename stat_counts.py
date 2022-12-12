#!/bin/env python3
# 1.  SL,NL,SS,NS 找出四个样本相同的变异位点(4个样本均出现); 找出3个样本相同的变异位点(存在于3个样本中，另1个不存在); 
#找出四个样本特异性变异位点(仅在这一个里出现而其他样本没有的)
from collections import Counter
###########################################################
# indel
fi = open('indel.annotation.xls', 'r')
data = fi.readlines()
fi.close

f_all = open('all_samples_indel.xls', 'w')
f_3 = open('3_samples_indel.xls', 'w')
f_1 = open('1_samples_indel.xls', 'w')
print(data[0],end="",file=f_all)
print(data[0],end="",file=f_3)
print(data[0],end="",file=f_1)
for line in data:
    if 'GeneDetail.refGene' in line or './.' in line:
        continue
    list = []
    s1 = line.split("\t")[5].split(" ")[0]
    s2 = line.split("\t")[6].split(" ")[0]
    s3 = line.split("\t")[7].split(" ")[0]
    s4 = line.split("\t")[8].split(" ")[0]
    for i in s1,s2,s3,s4:
        list.append(i)
    res = Counter(list)
    uq = []
    for i in res: 
        if res[i] == 4:
            print(line,end="",file=f_all)
        elif res[i] == 3:
            print(line,end="",file=f_3)
        # 这里不能再用 elif 防止 3 1 情况出现丢失 1
        if res[i] == 1:
            uq.append(i)
    if len(uq) > 0:
        line2 = line
        for c in uq:
            line2 = line2.replace(c,(c + "*"))
        print(line2,end="",file=f_1)


f_all.close
f_3.close
f_1.close

###########################################################
# snp
fi = open('snp.annotation.xls', 'r')
data = fi.readlines()
fi.close

f_all = open('all_samples_snp.xls', 'w')
f_3 = open('3_samples_snp.xls', 'w')
f_1 = open('1_samples_snp.xls', 'w')
print(data[0],end="",file=f_all)
print(data[0],end="",file=f_3)
print(data[0],end="",file=f_1)
for line in data:
    if 'GeneDetail.refGene' in line or './.' in line:
        continue
    list = []
    s1 = line.split("\t")[5].split(" ")[0]
    s2 = line.split("\t")[6].split(" ")[0]
    s3 = line.split("\t")[7].split(" ")[0]
    s4 = line.split("\t")[8].split(" ")[0]
    for i in s1,s2,s3,s4:
        list.append(i)
    res = Counter(list)
    for i in res:
        if res[i] == 4:
            print(line,end="",file=f_all)
        elif res[i] == 3:
            print(line,end="",file=f_3)
        
        if res[i] == 1:
            uq.append(i)
    if len(uq) > 0:
        line2 = line
        for c in uq:
            line2 = line2.replace(c,(c + "*"))
        print(line2,end="",file=f_1)

f_all.close
f_3.close
f_1.close

