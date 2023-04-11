#!/bin/env python3
import re
file = 'all_pos.xls'
pattern = '^exonic|splicing|;exonic'
s = ',|;'
f = open(file, 'r')
lines = f.readlines()
f.close
fo = open("stat.xls", 'w')
print("Gene","var_abundance",sep="\t",file=fo)
# 将注释文件按照基因拆分到不同的哈希散列表中
gene_dic = {}
for line in lines:
    if "GeneDetail.refGene" in line:
        continue

    gene = line.split('\t')[7]
    if ',' in gene or ';' in gene:  # 表明有 多个基因
        gene2 = re.split(s,gene)
        for g in gene2:
            if g in gene_dic:
                gene_dic[g].append(line)
            else:
                gene_dic[g] = [line]

    else:  # 只注释到一个基因的情况
        if gene in gene_dic:
            gene_dic[gene].append(line)
        else:
            gene_dic[gene] = [line]
#对每个基因进行一次统计
for gene_lines in gene_dic:
    if 'NONE' == gene_lines:
        continue
    all_pos = 0
    var_pos = 0
    for line in gene_dic[gene_lines]:
        line_list = line.split('\t')
        func = line_list[6]
        #reads = line_list[5].split(' | ')[1].split(',')
        #var_list = line_list[5].split(' | ')[0].split('/')
        all_pos += 1
        if bool(re.search(pattern,func)):
            if line_list[9] != 'synonymous SNV' and line_list[9] != 'unknown' and line_list[9] != '.':
                var_pos += 1  
            else:
                None
        
    rate = var_pos/all_pos * 100
    print(gene_lines,str("%.2f" %(rate)) + " %",sep='\t',file=fo)


fo.close
