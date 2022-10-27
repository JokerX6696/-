#!/data/software/conda_envs/snakemake_v6.1.1/bin/python
import pandas as pd
files = ['./snp.candidate.filter.xls','./snp.candidate.xls']
for file in files:
    inputfile = file
    df = pd.DataFrame(pd.read_csv(inputfile,sep="\t"))
    line = df.shape[0]
    samples = []
    
    other = ['chromosome', 'position', 'ref', 'alt', 'qual',  'Func.refGene', 'Gene.refGene', 'GeneDetail.refGene', 'ExonicFunc.refGene', 'AAChange.refGene', 'upstream_500', 'downstream_500']
    for i in list(df.columns):  # 确定样本数目
        if i not in other:
            samples.append(i)
    print(samples)
    col = 6
    for name in samples:
        
        res = []
        for i in range(0,line):
            Type = df.loc[i,name].split(' ')[0].split('/')
            if '.' in Type:
                res.append('NA')
            else:
                num = df.loc[i,name].split(' ')[2].split(',')
                # 确定总 reads 数
                All = 0
                for i in num:
                    i = int(i)
                    All += int(i)
                if All == 0:
                    res.append(0)
                else:
                    if '0' == Type[1] and Type[0] == '0':
                        counts = 0
                        readsnum = 0
                        for i in num:
                            counts += 1
                            if counts == 1:
                                continue
                            readsnum += int(i)                     
                    elif Type[0] == Type[1]:
                        xb = int(Type[1]) 
                        readsnum = int(num[xb])
                    else: # 去除 0
                        if '0' in Type:
                            xb = int(Type[1]) 
                            readsnum = int(num[xb])
                        else: 
                            xb1 = int(Type[0]) 
                            xb2 = int(Type[1]) 
                            readsnum = int(num[xb1]) + int(num[xb2])
                    
                res.append(readsnum/All) 
        
        df.insert(loc=col, column=(name+'_index'), value=res,allow_duplicates = False)
        col += 2
    outputfile = (inputfile.split('/')[1].split('.xls')[0] + '_add_index.xls')
    df.to_csv(outputfile,sep='\t',index=False)
        
