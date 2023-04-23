#!/bin/env python3
import pandas as pd
for q in ['snp.annotation.xls','indel.annotation.xls']:
    df = pd.read_csv(q,sep="\t")
    common_list = []
    hxd_list = []
    hgy_list = []
    for index, row in df.iterrows():  #  使用pandas data.frame 按行循环。
        hxd = row['hxd'].split(' ')[0]
        hgy = row['hgy'].split(' ')[0]
        if hxd == './.' or hgy == './.':
            continue
        elif hxd == hgy:
            common_list.append(index)
        else:
            if hxd != '0/0':
                hxd_list.append(index)
            if hgy != '0/0':
                hgy_list.append(index)
    prefix = q.split('.')[0]
    df_2 = df.iloc[common_list]
    name = "hxd_hgy_common_" + prefix + ".xls"
    df_2.to_csv(name,sep="\t",index=False,mode='w')

    df_2 = df.iloc[hgy_list]
    name = "hgy_unique_" + prefix + ".xls"
    df_2.to_csv(name,sep="\t",index=False,mode='w')

    df_2 = df.iloc[hxd_list]
    name = "hxd_unique_" + prefix + ".xls"
    df_2.to_csv(name,sep="\t",index=False,mode='w')
        
