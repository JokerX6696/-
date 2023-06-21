#!/bin/env python3
import re
import pandas as pd


M_indel = 'result/M_indel.xls'
M_snp = 'result/M_snp.xls'
N_indel = 'result/N_indel.xls'
N_snp = 'result/N_snp.xls'
WT_indel = 'result/WT_indel.xls'
WT_snp = 'result/WT_snp.xls'
merged_dict = {}
for l in [M_indel,M_snp,N_indel,N_snp,WT_indel,WT_snp]:

    # indel stat
    df = pd.read_csv(l,sep='\t')
    out = l.replace('result/','').replace('.xls','') + '_stat.xls'
    df_dict = {}
    samples = df.columns[5:15].to_list()

    list_t = list(df['ExonicFunc.refGene'].unique())
    del(list_t[list_t.index('.')])
    func = list(df['Func.refGene'].unique()) + ['total']
    for i in func:
        list_t.extend(i.split(';'))

    # 将所有数据 初始化 为 0 每种突变均为 0 
    for k in list_t:
        df_dict[k] = {}
        for j in samples:
            df_dict[k][j] = 0


    for index, row in df.iterrows():
        temp = [ i.split(' ')[0] for i in row[5:15].to_list() ]
        # 确定唯一的突变出现在哪个样本中
        tmp_dict = {}
        s = []
        for q in range(0,len(temp)):
            if temp[q] in tmp_dict:
                tmp_dict[temp[q]] += 1
            else:
                tmp_dict[temp[q]] = 1
        for w in tmp_dict: # 获取 唯一 var 位置
            if tmp_dict[w] == 1:
                s.append(temp.index(w))
        ss = []
        for i in s:
            ss.append(samples[i])

        # 统计区域
        for k in row['Func.refGene'].split(';'):
            for j in ss:
                #print(k,j)
                df_dict[k][j] += 1
                df_dict['total'][j] += 1

        if row['Func.refGene'] == 'exonic':
            ex_ty = row['ExonicFunc.refGene']
            for j in ss:
                df_dict[ex_ty][j] += 1
            
    data = pd.DataFrame(df_dict)
    data = data.T
    
    data.to_csv(out, index=True,sep = '\t')
    merged_dict[l] = df_dict


df1 = pd.DataFrame(merged_dict['result/M_indel.xls']).T
df2 = pd.DataFrame(merged_dict['result/N_indel.xls']).T
df3 = pd.DataFrame(merged_dict['result/WT_indel.xls']).T
merged_df = pd.merge(df1, df2, left_index=True, right_index=True, how='outer')
merged_df = pd.merge(merged_df, df3, left_index=True, right_index=True, how='outer')
merged_df = merged_df.fillna(0)
c = ['frameshift insertion','frameshift deletion','nonframeshift deletion','nonframeshift insertion','stopgain','unknown','stoploss','exonic','intronic','UTR5','upstream','UTR3','downstream','ncRNA_intronic','intergenic','ncRNA_exonic','splicing','total']
merged_df = merged_df.loc[c]
merged_df.to_csv('indel_stat.xls', index=True,sep = '\t')

df1 = pd.DataFrame(merged_dict['result/M_snp.xls']).T
df2 = pd.DataFrame(merged_dict['result/N_snp.xls']).T
df3 = pd.DataFrame(merged_dict['result/WT_snp.xls']).T
merged_df = pd.merge(df1, df2, left_index=True, right_index=True, how='outer')
merged_df = pd.merge(merged_df, df3, left_index=True, right_index=True, how='outer')
merged_df = merged_df.fillna(0)
c = ['nonsynonymous SNV','synonymous SNV','stopgain','unknown','stoploss','exonic','intergenic','upstream','downstream','intronic','UTR3','UTR5','ncRNA_exonic','ncRNA_intronic','splicing','total']
merged_df = merged_df.loc[c]
merged_df.to_csv('snp_stat.xls', index=True,sep = '\t')