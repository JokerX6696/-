#!/data/USER/zhengfuxing/conda/after-sale/bin/python
import re
import argparse
import pandas as pd

# @click.command()
# @click.option('-c', help='常规分组 config.ini 文件路径，用于排除已完成的分组比较！')
# @click.option('-i', help='输入分析确认单！')
# @click.option('-o', help='输出文件路径！不需要精确到文件名称,只需要精确到目录！输出文件为 group.file')
parser = argparse.ArgumentParser()
parser.add_argument('-c', help='常规分组 config.ini 文件路径，用于排除已完成的分组比较！', type=str)
parser.add_argument('-i', help='输入分析确认单！', type=str)
parser.add_argument('-o', help='输出文件路径！不需要精确到文件名称,只需要精确到目录！输出文件为 group.file', type=str,default='./')
args = parser.parse_args()

file = args.i
fo = args.o
grouped_file = args.c
if bool(re.search("/$",fo)):
    fo = fo + 'group.file'
else:
    fo = fo + '/group.file'

# file = 'D:/desk/make_Script/DZOE2023041063_2023052905.xlsx'  测试用
# fo = 'D:/desk/make_Script/group.file'
# grouped_file = 'D:/desk/make_Script/config.ini'

#################排除已分析过的组  grouped 已经分析过得到常规分组
fd = open(grouped_file, 'r',encoding='UTF-8')
df_fd = fd.read()
fd.close
grouped = re.search('group_vs\s=\s?(.+)\n', df_fd).group(1).replace(' ','').replace('\t','').split(';')
##########################################

all_samples = pd.read_excel(file,sheet_name='样本信息')
all_samples = [i for i in all_samples['样本分析名称']]

########################################
df = pd.read_excel(file,sheet_name='样本分组信息')
# 将分组信息储存到字典 key 为组 value 样本的列表
dict_group = {}

for j in range(0, df.shape[0]):
    temp_samples = df.iloc[j]['samples'].split(',')
    group_name = df.iloc[j]['group']
    for l in temp_samples:
        if group_name in dict_group:
            dict_group[group_name].append(l)
        else:
            dict_group[group_name] = [l]

# 确定补充拓展分组的数目
group_vs = pd.read_excel(file,sheet_name='差异比较信息')
group_vs_new = []
for i in group_vs['groups']:
    k = i.replace(' ','').replace('\t','')
    if k in grouped:
        continue
    else:
        group_vs_new.append(k)

group_num = len(group_vs_new) # 待分组的数目
group_al = []#已完成的分组
#data = ""
split_char = '################################################\n'
counts = 0
wd_more = {}
while( group_num > 0 ):
    ll = set()
    jj = False
    group_temp = []
    wd_more[counts] = {}
    for j in group_vs_new:
        if j not in group_al:
            groups_raw = j.replace(' ','').replace('\t','')
            groups = groups_raw.split(',')
            for group in groups:
                if ll & set(dict_group[group]) == set():  # 无交集
                    ll = ll | set(dict_group[group])
                    for q in dict_group[group]:  #  这里 q 为单样本
                        wd_more[counts][q] = group
                        #data += q + '\t' + group + '\n'
                        #print(q,group,sep='\t')
                else:  # 有交集
                    jj = True
                    break
        else: # 如果已经被分组了 则跳过
            continue
        if jj:
            None
        else:
            group_al.append(j)
            group_num -= 1
            group_temp.append(groups_raw)
        #print('------------------------------------------------')
    #data += "#  "
    temp_g = ""
    for g in group_temp:
        temp_g += g + ';'
    wd_more[counts]['Group'] = temp_g
    counts += 1


with open(fo, 'w') as f:
    print('sample',end='',file=f)
    for col in wd_more:
        name = 'group' + str(col + 1)
        print("------------------------------------------------------------------------------------------------------------------------")
        print(name,'congif.ini 分组可填写    ',wd_more[col]['Group'])
        #print("------------------------------------------------------------")
        print('\t',file=f,end='')
        print(name,end='',file=f)
    print('',file=f)
    for q in all_samples:
        print(q,end='',file=f)
        for w in wd_more:
            print('\t',file=f,end='')
            if q not in wd_more[w]:
                name_g = "None"
            else:
                name_g = wd_more[w][q]
            print(name_g,file=f,end='')

        print('',file=f)


