#!/bin/env python
# 将 vcf 中 两个样本均为 ./. 0/0 删除
import re
# f = open('indel_keep.vcf.recode.vcf', 'r')
# fo = open('Filter_indel_keep.vcf', 'w')
# for line in f.readlines():
#     if '#' in line:
#         print(line,end="",file=fo)
#         continue
#     # 10 and 11
#     t1 = line.strip().split('\t')[9].split(':')[0]
#     t1 = re.split('[/|\|]', t1)
#     t2 = line.strip().split('\t')[10].split(':')[0]
#     t2 = re.split('[/|\|]', t2)
#     list = t1 + t2
#     if '1' in list or '2' in list or '3' in list:
#         print(line,end="",file=fo)
# f.close


f = open('snp_keep.vcf.recode.vcf', 'r')
fo = open('Filter_snp_keep.vcf', 'w')
for line in f.readlines():
    if '#' in line:
        print(line,end="",file=fo)
        continue
    # 10 and 11
    t1 = line.strip().split('\t')[9].split(':')[0]
    t1 = re.split('[/|\|]', t1)
    t2 = line.strip().split('\t')[10].split(':')[0]
    t2 = re.split('[/|\|]', t2)
    list = t1 + t2
    if '1' in list or '2' in list or '3' in list:
        print(line,end="",file=fo)
f.close
