#!/bin/env python
# find snp indel
import gzip
import time
ts = time.time()
fi = gzip.open('./vcf_filter/Filter.snp.vcf.gz', 'r')
fo = open('cut_position_snp.txt', 'w')
print('chr\tcut_position\tCHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tINFO\tFORMAT\tBRL201-452\tBRL201-452-UT\tBRL201-454\tBRL201-454_UT',file=fo)
while True:
    line3 = fi.readline()
    line = str(line3,'utf-8').replace('\n','')
    if not line3:
        break
    elif "#" in line:
        continue
    CHR = line.split('\t')[0]
    POS = int(line.split('\t')[1])
    with open('pos_input.txt', 'r') as f:
        while True:
            line4 = f.readline()
            line2 = line4.split('\t')
            if not f.readline():
                break
            elif line2[0] != CHR:
                continue
            start = int(line2[2])
            end = int(line2[3])
            pos = line2[1]
            if POS >= start and POS <= end:
                print('chr'+CHR+':'+pos,line,sep='\t',file=fo)

fi.close
fo.close
print('snp finish;\nnow start indel')
fi = gzip.open('./vcf_filter/Filter.indel.vcf.gz', 'r')
fo = open('cut_position_indel.txt', 'w')
print('chr\tcut_position\tCHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tINFO\tFORMAT\tBRL201-452\tBRL201-452-UT\tBRL201-454\tBRL201-454_UT',file=fo)
while True:
    line3 = fi.readline()
    line = str(line3,'utf-8').replace('\n','')
    if not line3:
        break
    elif "#" in line:
        continue
    CHR = line.split('\t')[0]
    POS = int(line.split('\t')[1])
    with open('pos_input.txt', 'r') as f: # 应当将文件内容存入变量 避免频繁打开句柄浪费时间！
        while True:
            line4 = f.readline()
            line2 = line4.split('\t')
            if not line4:
                break
            elif line2[0] != CHR:
                continue
            start = int(line2[2])
            end = int(line2[3])
            pos = line2[1]
            if POS >= start and POS <= end:
                print('chr'+CHR+':'+pos,line,sep='\t',file=fo)

fi.close
fo.close

te = time.time()
print('共计用时',te - ts)
