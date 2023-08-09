#!/data/USER/zhengfuxing/tools/conda/anaconda3/bin/python
#  wkdir = /storge1/Reseq/DZOE2023040237-b1/Suppl_4/Analysis
import pandas as pd
import re, openpyxl
#### def 统计函数
def Stat(func:list, ExonicFunc:list,var:str,name:str):
    stat_dict = {}
    for j in func:
        lines = j.split(';')
        for k in lines:
            if k in stat_dict:
                stat_dict[k] = stat_dict[k] + 1
            else:
                stat_dict[k] = 1
    for j in ExonicFunc:
        if j == '.':
            continue
        lines = j.split(';')
        for k in lines:
            stat_dict[k] = stat_dict[k] + 1
    dict_all[name] = stat_dict
#### def 处理函数
def Tair_SH(df,var,group,name,treat,control):
    df_bak = df
    df[group] = df[group].replace(r'\s+\|.+$', '', regex=True)
    idx_all = []
    idx_sup = []
    for index, row in df.iterrows():
        var_list_treat = row[treat].to_list()
        var_list_treat_fin = []
        var_list_control = row[control].to_list()
        var_list_control_fin = []
        var_list_treat = set(var_list_treat)

        temp = var_list_treat - {'./.', '0/0'}
        if len(temp) == 0: # 当某一行 只有 0/0 和 ./. 时 ,无法确定是否突变,按照没有发生突变来处理
            var_list_control = set(var_list_control) # 实验组没有出现突变,而对照组出现突变的时候
            var_list_control = var_list_control - {'./.', '0/0'}
            if len(var_list_control) == 0:
                pass
            else:
                idx_sup.append(index)
        else:
            idx_all.append(index)

    df_all = df_bak.iloc[idx_all,:]
    Stat(name=('raw_' + name + var),func = df_all['Func.refGene'].to_list(),ExonicFunc = df_all['Func.refGene'].to_list(),var=var)
    df_sup = df_bak.iloc[idx_sup,:]
    Stat(name=('sup_' + name + var),func = df_sup['Func.refGene'].to_list(),ExonicFunc = df_sup['Func.refGene'].to_list(),var=var)
    df_all_sup = df_bak.iloc[sorted(list(idx_sup + idx_all)),:]
    Stat(name=('all_' + name + var),func = df_all_sup['Func.refGene'].to_list(),ExonicFunc = df_all_sup['Func.refGene'].to_list(),var=var)
    df_all.to_excel(writer, sheet_name=(name + '_' + var + '_raw'), index=False)
    df_sup.to_excel(writer, sheet_name=(name + '_' + var + '_supplement'), index=False)
    df_all_sup.to_excel(writer, sheet_name=(name + '_' + var + '_all'), index=False)
    


### parameters
snp_file = 'indel.annotation.xls'
indel_file = 'snp.annotation.xls'
out_file = 'Group_var_pos_stat.xlsx'
writer = pd.ExcelWriter(out_file, engine='openpyxl')
dict_all = {}
df_snp = pd.read_csv(snp_file, sep='\t',header = 0)
df_indel = pd.read_csv(indel_file, sep='\t', header = 0)

pre = ['chromosome', 'position','ref','alt','qual' ]
WT = ['WT-'+str(i) for i in range(1,11)]
M = ['M-5T-'+str(i) for i in range(1,11)]
N = ['N-5T-'+str(i) for i in range(1,11)]
end = ['Func.refGene', 'Gene.refGene', 'GeneDetail.refGene', 'ExonicFunc.refGene', 'AAChange.refGene']
# 处理 M
## snp
col = pre + M + WT + end
samples = M + WT
df_temp = df_snp[col]
Tair_SH(var='snp',group=samples,df=df_temp,name='M',treat = M,control = WT)
## indel
col = pre + M + WT + end
samples = M + WT
df_temp = df_indel[col]
Tair_SH(var='indel',group=samples,df=df_temp,name='M',treat = M,control = WT)
# 处理 N
## snp
col = pre + N + WT + end
samples = N + WT
df_temp = df_snp[col]
Tair_SH(var='snp',group=samples,df=df_temp,name='N',treat = N,control = WT)
## indel
col = pre + N + WT + end
samples = N + WT
df_temp = df_indel[col]
Tair_SH(var='indel',group=samples,df=df_temp,name='N',treat = N,control = WT)
################################## 补充 wt
col = pre + WT + end
samples = WT
### snp
df_wt = df_snp[col]
df_wt[samples] = df_wt[samples].replace(r'\s+\|.+$', '', regex=True)
l = []
for index, row in df_wt.iterrows():
    line = row[samples].to_list()
    if './.' in line:
        continue
    line_test = set(line) - {'./.', '0/0'}
    if len(line_test) > 0:
        l.append(index)

df_wt_fin = df_wt.loc[l,]
df_wt_fin.to_excel(writer, sheet_name='WT_snp', index=False)
Stat(name=('WT'),func = df_wt_fin['Func.refGene'].to_list(),ExonicFunc = df_wt_fin['Func.refGene'].to_list(),var='snp')
### indel
df_wt = df_indel[col]
df_wt[samples] = df_wt[samples].replace(r'\s+\|.+$', '', regex=True)
l = []
for index, row in df_wt.iterrows():
    line = row[samples].to_list()
    if './.' in line:
        continue
    line_test = set(line) - {'./.', '0/0'}
    if len(line_test) > 0:
        l.append(index)

df_wt_fin = df_wt.loc[l,]
df_wt_fin.to_excel(writer, sheet_name='WT_indel', index=False)
Stat(name=('WT'),func = df_wt_fin['Func.refGene'].to_list(),ExonicFunc = df_wt_fin['Func.refGene'].to_list(),var='indel')
#################################
df_stat = pd.DataFrame(dict_all)
df_stat = df_stat.fillna(0)
df_stat.to_excel(writer, sheet_name='SNV_Stat', index=False)

###############################
writer.save()
writer.close()





















