#!/data/USER/zhengfuxing/conda/after-sale/bin/python
import pandas as pd
import re
indel = '/storge1/Reseq/DZOE2023040237-b1/Suppl_2/Analysis/indel.annotation.xls'
snp = '/storge1/Reseq/DZOE2023040237-b1/Suppl_2/Analysis/snp.annotation.xls'
pattern = '\./\.\s|'

for l in [snp,indel]:

    df = pd.read_csv(l,sep='\t')
    samples_raw = df.columns.tolist()[5:]
    samples = []
    for i in samples_raw:  # 确定样本名
        if i == 'Func.refGene' or i == 'Gene.refGene' or i == 'GeneDetail.refGene' or i == 'ExonicFunc.refGene' or i == 'AAChange.refGene':
            break
        else:
            samples.append(i)

    pattern = '\./\.'

    # item1
    samples_wt = samples[-10:]
    samples_wt_others = samples[0:20]
    wt = df.drop(df[samples_wt_others], axis=1)
    #wt = wt.replace("\s\|.*","",regex=True)
    out_name = 'item1_'+ l.replace("/storge1/Reseq/DZOE2023040237-b1/Suppl_2/Analysis/","").replace(".annotation.xls","") +'.xls'
    out = open(out_name, 'w')
    for i in wt.columns.to_list():
        print(i,end='\t',file=out)
    print('',file=out)
    for index, row in wt.iterrows():
        line = row.to_string(index=False,header=False)
        if bool(re.search(pattern,line)):
            continue
        else:
            list_2 = []
            dict_2 = {}
            for i in row[samples_wt].to_list():
                list_2.append(i.split(" ")[0])
            for t in list_2:
                if t not in dict_2:
                    dict_2[t] = 1
                else:
                    dict_2[t] += 1
            p = False
            for i in dict_2:
                if dict_2[i] == 1:
                    p = True
            if p:
                for j in row.to_list():
                    print(j,sep='\t',end="\t",file=out)
                print("",file=out)






