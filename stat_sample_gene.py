#!/bin/env python3
import re
import copy
file = 'temp.txt'
#pattern = '^exonic|splicing|;exonic|'
pattern = 'IL6ST|PDGFRB'
f = open(file, 'r')
lines = f.readlines()
f.close
name = {}
target_line = []
for line in lines:
    if line.startswith("chromosome"):
        anno_list_1 = line.split('\t')
        for num in range(0,len(anno_list_1)):
            if anno_list_1[num] == 'Func.refGene':
                func = num
            elif anno_list_1[num] == 'Gene.refGene':
                gene = num
        for n in range(5,func):
            name[n] = anno_list_1[n]
        continue
    anno_list = line.split('\t')
    if bool(re.search(pattern, anno_list[gene])):
        target_line.append(line)
        #del(anno_list[5:func])
        #print(anno_list)
f = open('./IL6ST_PDGFRB_pos.xls','w')
l = 0
for line in target_line:
    line_list = line.split('\t')
    line_list2 =copy.copy(line_list)
    del(line_list2[5:func])
    if l == 0:
        print('gene','sample','type',end='\t',sep='\t',file=f)
        counts = 0
        del(anno_list_1[5:func])
        for q in anno_list_1:
            counts += 1
            if counts == len(anno_list_1):
                print(q,end='',file=f)
            else:
                print(q,end='\t',file=f)
    for i in range(5, (func-1)):
        if '0/0' in line_list[i] or './.' in line_list[i]:
            continue
        else:
            if 'pbmc' in name[i] or 'PBMC' in name[i] or 'blood' in name[i]:
                print(line_list[gene],name[i],line_list[i],sep='\t',end='\t',file=f)
                counts = 0
                for j in line_list2:
                    counts += 1
                    if counts == len(line_list2):
                        print(j,end='',file=f)
                    else:
                        print(j,end='\t',file=f)
    l += 1
