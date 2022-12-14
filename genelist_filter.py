#!/bin/env python3
with open ('genelist_mm.txt', 'r')as f:
    list = f.readlines()
list2 = []
for i in list:
    list2.append(i.replace('\n',''))

files = ['MDC-135.CNV.anno.xls','LHO.CNV.anno.xls','MDC-139.CNV.anno.xls','P135.CNV.anno.xls','P139.CNV.anno.xls']
for file in files:
    with open (file,'r')as f:
        lines = f.readlines()

    out = 'filter_' + file

    with open (out, 'w') as f:
        print(lines[0],end="",file=f)
        for line in lines:
            gene = line.strip().replace('\n','').split('\t')[8].split(',')
            for i in gene:
                if i in list2:
                    print(line,end="",file=f)
                    continue
