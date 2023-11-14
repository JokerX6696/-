#!/bin/env python3
# 处理 突变数据
import re
# para #
pattern = r'\s\|\s.+'
threshold = 0.5
file_path = 'snp.annotation.xls'
out = 'snp_select_'+str(threshold)+'_annotation.xls'
#

#
class POS():

    threshold = threshold

    def __init__(self,chr,pos,ref,alt,BM,WM):
        self.chr = chr
        self.pos = pos
        self.ref = ref
        self.alt = alt
        self.BM = BM
        self.WM = WM
        self.BM_genetype = self.stat_dict(self.BM)
        self.WM_genetype = self.stat_dict(self.WM)
        if self.BM_genetype != self.WM_genetype and self.BM_genetype != 'unknow' and self.WM_genetype != 'unknow':
            self.var = True
        else:
            self.var = False
        
    def stat_dict(self,l):
        d = {}
        for i in l:
            if i in d:
                d[i] += 1
            else:
                d[i] = 1 
        for i in d:
            genetype = 'unknow'
            length = len(l)
            if i == './.':
                continue
            var_bl = d[i]/length
            if var_bl > self.threshold:
                genetype = i
        return genetype

#
fo = open(out,'w')
f = open(file_path,'r')
for line in f:
    l = line.split('\t')
    if l[0] == 'chromosome':
        print(line,end='',file=fo)
        continue
    l = [re.sub(pattern,'',i) for i in l]
    pos = POS(
        chr=l[0],
        pos=l[1],
        ref=l[2],
        alt=l[3],
        BM=l[5:33],
        WM=l[33:60]
        )
    if pos.var:
        print(line,end='',file=fo)













fo.close
f.close