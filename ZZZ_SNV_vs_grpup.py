#!/bin/env python3
# indel
fi = open('indel.annotation.xls','r')
lines = fi.readlines()
fi.close

fo_common = open('indel_common.xls','w')
fo_uniq_L1 = open('indel_L1_uniq.xls','w')
fo_uniq_L2 = open('indel_L2_uniq.xls','w')
fo_uniq_L3 = open('indel_L3_uniq.xls','w')
fo_uniq_L4 = open('indel_L4_uniq.xls','w')
fo_uniq_L5 = open('indel_L5_uniq.xls','w')
fo_uniq_N1 = open('indel_N1_uniq.xls','w')
fo_uniq_N2 = open('indel_N2_uniq.xls','w')
fo_L_N_diff_L = open('indel_L_N_diff_L.xls','w')
fo_L_N_diff_N = open('indel_L_N_diff_N.xls','w')
fo_L_N_diff_L_pr = open('indel_L_N_diff_L_pr.xls','w')
fo_L_N_diff_N_pr = open('indel_L_N_diff_N_pr.xls','w')
for i in fo_common,fo_uniq_L1,fo_uniq_L2,fo_uniq_L3,fo_uniq_L4,fo_uniq_L5,fo_uniq_N1,fo_uniq_N2,fo_L_N_diff_L,fo_L_N_diff_N,fo_L_N_diff_L_pr,fo_L_N_diff_N_pr:
    print(lines[0],end='',file=i)


for line in lines:
    if 'GeneDetail.refGene' in line or './.' in line:
        continue
    list = line.split('\t')
    L1, L2, L3, L4, L5, N1, N2 = [i.split(' ')[0] for i in list[5:12] ]
    pr = list[12]
    d = {}
    for i in [L1, L2, L3, L4, L5, N1, N2]:
        if i in d:
            d[i] += 1
        else:
            d[i] = 1
    #7样本共同出现
    if len(d) == 1:
        print(line,end="",file=fo_common)
    #特有突变
    if d[L1] == 1 and L1 != '0/0':
        print(line,end="",file=fo_uniq_L1)
    if d[L2] == 1 and L2 != '0/0':
        print(line,end="",file=fo_uniq_L2)
    if d[L3] == 1 and L3 != '0/0':
        print(line,end="",file=fo_uniq_L3)
    if d[L4] == 1 and L4 != '0/0':
        print(line,end="",file=fo_uniq_L4)
    if d[L5] == 1 and L5 != '0/0':
        print(line,end="",file=fo_uniq_L5)
    if d[N1] == 1 and N1 != '0/0':
        print(line,end="",file=fo_uniq_N1)
    if d[N2] == 1 and N2 != '0/0':
        print(line,end="",file=fo_uniq_N2)
    # L 组 与 N 组 特有突变
    if L1 == L2 == L3 == L4 == L5 and L1 != N2 and L1 != N1 and L1 != '0/0':
        print(line,end="",file=fo_L_N_diff_L)
        if 'exonic' in pr or 'splicing' in pr:
            print(line,end="",file=fo_L_N_diff_L_pr)
    else:    
        if N1 == N2 and L1 != N1 and L2 != N1 and L3 != N1 and L4 != N1 and L5 != N1 and N1 != '0/0':
            print(line,end="",file=fo_L_N_diff_N)
            if 'exonic' in pr or 'splicing' in pr:
                print(line,end="",file=fo_L_N_diff_N_pr)

for i in fo_common,fo_uniq_L1,fo_uniq_L2,fo_uniq_L3,fo_uniq_L4,fo_uniq_L5,fo_uniq_N1,fo_uniq_N2,fo_L_N_diff_L,fo_L_N_diff_N,fo_L_N_diff_L_pr,fo_L_N_diff_N_pr:
    i.close



# snp
fi = open('snp.annotation.xls','r')
lines = fi.readlines()
fi.close

fo_common = open('snp_common.xls','w')
fo_uniq_L1 = open('snp_L1_uniq.xls','w')
fo_uniq_L2 = open('snp_L2_uniq.xls','w')
fo_uniq_L3 = open('snp_L3_uniq.xls','w')
fo_uniq_L4 = open('snp_L4_uniq.xls','w')
fo_uniq_L5 = open('snp_L5_uniq.xls','w')
fo_uniq_N1 = open('snp_N1_uniq.xls','w')
fo_uniq_N2 = open('snp_N2_uniq.xls','w')
fo_L_N_diff_L = open('snp_L_N_diff_L.xls','w')
fo_L_N_diff_N = open('snp_L_N_diff_N.xls','w')
fo_L_N_diff_L_pr = open('snp_L_N_diff_L_pr.xls','w')
fo_L_N_diff_N_pr = open('snp_L_N_diff_N_pr.xls','w')
for i in fo_common,fo_uniq_L1,fo_uniq_L2,fo_uniq_L3,fo_uniq_L4,fo_uniq_L5,fo_uniq_N1,fo_uniq_N2,fo_L_N_diff_L,fo_L_N_diff_N,fo_L_N_diff_L_pr,fo_L_N_diff_N_pr:
    print(lines[0],end='',file=i)


for line in lines:
    if 'GeneDetail.refGene' in line or './.' in line:
        continue
    list = line.split('\t')
    L1, L2, L3, L4, L5, N1, N2 = [i.split(' ')[0] for i in list[5:12] ]
    pr = list[12]
    d = {}
    for i in [L1, L2, L3, L4, L5, N1, N2]:
        if i in d:
            d[i] += 1
        else:
            d[i] = 1
    #7样本共同出现
    if len(d) == 1:
        print(line,end="",file=fo_common)
    #特有突变
    if d[L1] == 1 and L1 != '0/0':
        print(line,end="",file=fo_uniq_L1)
    if d[L2] == 1 and L2 != '0/0':
        print(line,end="",file=fo_uniq_L2)
    if d[L3] == 1 and L3 != '0/0':
        print(line,end="",file=fo_uniq_L3)
    if d[L4] == 1 and L4 != '0/0':
        print(line,end="",file=fo_uniq_L4)
    if d[L5] == 1 and L5 != '0/0':
        print(line,end="",file=fo_uniq_L5)
    if d[N1] == 1 and N1 != '0/0':
        print(line,end="",file=fo_uniq_N1)
    if d[N2] == 1 and N2 != '0/0':
        print(line,end="",file=fo_uniq_N2)
    if L1 == L2 == L3 == L4 == L5 and L1 != N2 and L1 != N1 and L1 != '0/0':
        print(line,end="",file=fo_L_N_diff_L)
        if 'exonic' in pr or 'splicing' in pr:
            print(line,end="",file=fo_L_N_diff_L_pr)
    else:    
        if N1 == N2 and L1 != N1 and L2 != N1 and L3 != N1 and L4 != N1 and L5 != N1 and N1 != '0/0':
            print(line,end="",file=fo_L_N_diff_N)
            if 'exonic' in pr or 'splicing' in pr:
                print(line,end="",file=fo_L_N_diff_N_pr)
for i in fo_common,fo_uniq_L1,fo_uniq_L2,fo_uniq_L3,fo_uniq_L4,fo_uniq_L5,fo_uniq_N1,fo_uniq_N2,fo_L_N_diff_L,fo_L_N_diff_N,fo_L_N_diff_L_pr,fo_L_N_diff_N_pr:
    i.close

