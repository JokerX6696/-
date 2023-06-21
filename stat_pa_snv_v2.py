#!/bin/env python3
import re
import pandas as pd
###############################
def jug(line,group_name):
    p = False
    tmp_dict = {}
    for i in line:
        if i in tmp_dict:
            tmp_dict[i] += 1
        else:
            tmp_dict[i] = 1
    for i in tmp_dict:
        if tmp_dict[i] == 1:
            p = True
    if p:
        for i in group_name:
            if row[i] == var_list[0] and len(var_list) == 1: # 当且仅当 基因型与 wt 基型一致且 wt 基因型只有 1个 的时候
                None
            else:
                df.at[index,i] = 4
###############################
indel = 'indel.annotation.xls'

df = pd.read_csv(indel,sep='\t')

last_name = df.columns.to_list()[0:5]
next_name = df.columns.to_list()[-5:]
M_name = df.columns.to_list()[5:15]
N_name = df.columns.to_list()[15:25]
WT_name = df.columns.to_list()[25:35]
all_name = M_name + N_name + WT_name

df_wt = df[(last_name + WT_name + next_name)]  # wt 组所有位点

index_list = []
for index, row in df_wt.iterrows():
    line = row.to_string(index=False,header=False)
    p = bool(re.search('\./\.',line))
    if p:
        continue
    else:
        all = [i.split(' ')[0] for i in row[WT_name].to_list()]
        all_dict = {}
        for i in all:
            if i in all_dict:
                all_dict[i] += 1
            else:
                all_dict[i] = 1
        p = True
        for i in all_dict:
            if all_dict[i] == 1 and i != '0/0':
                p = False
        if p:
            index_list.append(index)
df = df.iloc[index_list]      # 所有被剔除的 wt
df = df.replace({'\s\|.+': ''}, regex=True)
for index, row in df.iterrows():
    wt_d = {} # 选取 wt 超过 2 种 的基因型
    var_list = []
    for i in row[WT_name].to_list():
        if i in wt_d:
            wt_d[i] += 1
        else:
            wt_d[i] = 1
    for i in wt_d:
        if wt_d[i] >= 2:
            var_list.append(i)
    # M 组 判断是否被筛选
    M_line = row[M_name].to_list()
    pm = jug(M_line,M_name)
    # N 组 判断是否被筛选
    N_line = row[N_name].to_list()
    pn = jug(N_line,N_name)

    


# 统计区域
df_dict = {}
list_t = list(df['ExonicFunc.refGene'].unique())
del(list_t[list_t.index('.')])
func = list(df['Func.refGene'].unique()) + ['total']
for i in func:
    list_t.extend(i.split(';'))

for j in list_t:
    df_dict[j] = {}
    for k in (M_name + N_name):
        df_dict[j][k] = 0

for index, row in df.iterrows():
    for i in (M_name + N_name):
        if row[i] == 4:
            FuncrefGene = row['Func.refGene'].split(';')
            if FuncrefGene[0] == 'exonic':
                ExonicFuncrefGene = row['ExonicFunc.refGene']
                df_dict[ExonicFuncrefGene][i] += 1
            for q in FuncrefGene:
                df_dict[q][i] += 1
                df_dict['total'][i] += 1

data = pd.DataFrame(df_dict)
data = data.T
data.to_csv('indel_bc.xls', index=True,sep = '\t')





indel = 'snp.annotation.xls'

df = pd.read_csv(indel,sep='\t')

last_name = df.columns.to_list()[0:5]
next_name = df.columns.to_list()[-5:]
M_name = df.columns.to_list()[5:15]
N_name = df.columns.to_list()[15:25]
WT_name = df.columns.to_list()[25:35]
all_name = M_name + N_name + WT_name

df_wt = df[(last_name + WT_name + next_name)]  # wt 组所有位点

index_list = []
for index, row in df_wt.iterrows():
    line = row.to_string(index=False,header=False)
    p = bool(re.search('\./\.',line))
    if p:
        continue
    else:
        all = [i.split(' ')[0] for i in row[WT_name].to_list()]
        all_dict = {}
        for i in all:
            if i in all_dict:
                all_dict[i] += 1
            else:
                all_dict[i] = 1
        p = True
        for i in all_dict:
            if all_dict[i] == 1 and i != '0/0':
                p = False
        if p:
            index_list.append(index)
df = df.iloc[index_list]      # 所有被剔除的 wt
df = df.replace({'\s\|.+': ''}, regex=True)
for index, row in df.iterrows():
    wt_d = {} # 选取 wt 超过 2 种 的基因型
    var_list = []
    for i in row[WT_name].to_list():
        if i in wt_d:
            wt_d[i] += 1
        else:
            wt_d[i] = 1
    for i in wt_d:
        if wt_d[i] >= 2:
            var_list.append(i)
    # M 组 判断是否被筛选
    M_line = row[M_name].to_list()
    pm = jug(M_line,M_name)
    # N 组 判断是否被筛选
    N_line = row[N_name].to_list()
    pn = jug(N_line,N_name)

    


# 统计区域
df_dict = {}
list_t = list(df['ExonicFunc.refGene'].unique())
del(list_t[list_t.index('.')])
func = list(df['Func.refGene'].unique()) + ['total']
for i in func:
    list_t.extend(i.split(';'))
for j in list_t:
    df_dict[j] = {}
    for k in (M_name + N_name):
        df_dict[j][k] = 0

for index, row in df.iterrows():
    for i in (M_name + N_name):
        if row[i] == 4:
            FuncrefGene = row['Func.refGene'].split(';')
            if FuncrefGene[0] == 'exonic':
                ExonicFuncrefGene = row['ExonicFunc.refGene']
                df_dict[ExonicFuncrefGene][i] += 1
            for q in FuncrefGene:
                df_dict[q][i] += 1
                df_dict['total'][i] += 1

data2 = pd.DataFrame(df_dict)
data2 = data2.T
data2.to_csv('snp_bc.xls', index=True,sep = '\t')