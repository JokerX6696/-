#!D:\application\anaconda\python.exe
# -*- coding: utf-8 -*-
import pandas as pd

# 读取.gz文件并将其解压缩为DataFrame，同时指定编码方式为UTF-8
df = pd.read_csv('D:/desk/XMSH_202308_5935/SNP.xls', sep='\t')
# 本次售后使用面向对象的方式进行
class Sample():
    temp_dict = {}
    def __init__(self,chr,pos,qb1,qb2,sample_gene):
        self.list_len = len(chr)
        self.chr = chr
        self.pos = pos
        self.qb1 = qb1
        self.qb2 = qb2
        self.sample_gene = sample_gene
        self.qb_diff_all = 0
        self.qb_diff_num = 0
        self.qb_same_all = 0
        self.qb_same_num = 0

    def stat(self,temp_dict):
        for i in range(0,self.list_len):
            if self.qb1[i][0] != self.qb1[i][1]: # 必须是纯合
                continue
            elif self.qb2[i][0] != self.qb2[i][1]: # 必须是纯合
                continue
            elif self.qb1[i] == '--' or self.qb2[i] == '--' or self.sample_gene[i] == '--':
                continue
            elif self.qb2[i] == self.qb1[i]: # 纯合一致
                self.qb_same_all += 1
                if self.sample_gene[i] == self.qb2[i]:
                    self.qb_same_num += 1
            elif self.qb2[i] != self.qb1[i]: # 纯合不一致
                #print(self.qb1[i],self.qb2[i],self.sample_gene[i],self.sample_gene[i] == self.qb1[i][0] + self.qb2[i][1] or self.sample_gene[i] == self.qb2[i][1] + self.qb1[i][0])
                self.qb_diff_all += 1
                if self.sample_gene[i] == self.qb1[i][0] + self.qb2[i][1] or self.sample_gene[i] == self.qb2[i][1] + self.qb1[i][0]:
                    self.qb_diff_num += 1
            else:
                print('出现了意料之外的情况 qb1: %s qb2: %s' %(self.q12[i],self.qb2[i]))
            temp_dict['chr'] = self.chr[i]
            temp_dict['pos'] = self.pos[i]
        chyzl = self.qb_same_num/self.qb_same_all
        fhycgl = self.qb_diff_num/self.qb_diff_all
        temp_dict['纯合一致率'] =chyzl
        temp_dict['符合遗传规律'] =fhycgl
        return temp_dict

        


samples = list(df.columns)[6:]
all_dict = {}
for i in samples:
    new = Sample(chr=list(df['CHROM']),pos=list(df['POS']),qb1=list(df['C']), qb2=list(df['S']),sample_gene=list(df[i]))
    all_dict[i] = new.stat()


outdf = pd.DataFrame(all_dict)

outdf.to_csv('D:/desk/XMSH_202308_5935/test.xls',sep='\t')