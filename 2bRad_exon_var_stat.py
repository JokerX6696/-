# 提取位于外显子上的突变位点，基于这些位点，计算组内样本的突变频率，并把突变频率由大到小排序，展示excel表即可
import re
import pandas as pd

def stat_var(file,exon_var):
    conuts = 0
    f = open(file, 'r')
    for line in f.readlines():
        if line.startswith('##'):
            continue
        elif line.startswith('#'):
            samples = line.strip().split('\t')[9:]
            stat_dict = {}
            for sample in samples:
                stat_dict[sample] = 0
            continue
        line_all = line.split('\t')
        samples_info = line_all[9:]
        mark = False
        for k in samples_info:
            mark = bool(re.search('\./\.:', k)) # 如果 每个样本中 都没有 ./. 则继续执行后续内容 否则 本次跳过
        if mark:
            continue
                
        info = line_all[7]
        info = re.split('\|+', info)
        var_type = info[1]
        if var_type not in exon_var:  #  突变类型不是 exon 跳过
            continue  
        
        samples_idx = 0
        for q in samples_info:
            gene_type = q.split(':')[0]
            if gene_type != '0/0':
                stat_dict[samples[samples_idx]] += 1
            samples_idx += 1
        conuts += 1
    print(conuts)
    return stat_dict

vcf_file = r'D:/desk/20230804_DZOE2023051230-b1_朱慧媛-32个人2bRAD-M项目_第三次售后分析结题报告/Annotation/Anno.vcf'
num = 0
var = ['missense_variant','synonymous_variant','splice_region_variant&intron_variant','non_coding_exon_variant']



ret = stat_var(file=vcf_file,exon_var=var)
# with open('stat.xls','w') as fo:
#     print('Sample','exonic_var','')
#     for k in ret:
#         print(k, ret[k], ret[k]/13, sep='\t', file=fo)
for k in ret:
    ret[k] = [ret[k] ,ret[k]/13]
df = pd.DataFrame(ret,index=['var_exon','var_frequency']).transpose()
df['var_exon'] = df['var_exon'].astype(int)

df.to_excel('D:/desk/20230804_DZOE2023051230-b1_朱慧媛-32个人2bRAD-M项目_第三次售后分析结题报告/Annotation/stat.xlsx', sheet_name='Sheet1', index=True)
