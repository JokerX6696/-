import pandas as pd

file = 'D:/desk/make_Script/DZQD2023040883_2023052559.xlsx'

group_df = pd.read_excel(file,sheet_name='样本分组信息')
df = group_df[group_df['type'] == '扩展']

fo = open('group.file', 'w')

for j in range(0, df.shape[0]):
    temp_samples = df.iloc[j]['samples'].split(',')
    for l in temp_samples:
        print(l,df.iloc[j]['group'],sep='\t',file=fo)
        
        
        
