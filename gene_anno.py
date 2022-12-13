#!/bin/env python3
# 针对生成文件进行注释
# 注释文件为ZhongmuNo.1.annotation.interpro
import re

with open ('ZhongmuNo.1.annotation.interpro', 'r') as f:
    data = f.read()


for file in ['3_samples_indel.xls','NL_unique_indel.xls','NS_unique_indel.xls','SL_unique_indel.xls','SS_unique_indel.xls',
'NL_unique_snp.xls','all_samples_snp.xls','3_samples_snp.xls','SL_unique_snp.xls','NS_unique_snp.xls','SS_unique_snp.xls']:
    out = file.replace('.xls','_anno.xls')
    f = open(file, 'r')
    lines = f.readlines()
    f.close
    f_out = open(out, 'w')
    for line in lines:
        if 'GeneDetail.refGene' in line:
            print(line.replace('\n',''),'Annotation',file=f_out)
            continue
        gene_list = line.split("\t")[10].split(',')
        anno_list = []  
        for gene in gene_list:
            if gene == "NONE":
                continue
            pattern = gene + '\S+\s(.+)\s'
            if not re.search(pattern,data):
                anno = "-"
            else:
                anno = re.search(pattern,data).group(1)
            anno_list.append(anno.strip())
        print(line.replace('\n',''),end="\t",file=f_out)
        for i in anno_list:
            print(i,end=";",file=f_out)
        print("",file=f_out)

    f_out.close
