#!/bin/env python
# python intron_detect.py -i genome.gff -o intron.gff
import os
import re
import argparse

parser = argparse.ArgumentParser()
parser.add_argument('-i', help='input *.gff file', required=True)
parser.add_argument('-o', help='output intron.gff file', required=True)
args = parser.parse_args()

Input = args.i
Output = args.o

# # 预处理文件 提升速度
os.system("awk '{OFS=FS=\"\\t\";if($3 == \"mRNA\" || $3 == \"exon\") print$0}' %s > tmp.gff" %(Input))



fi = open('tmp.gff', 'r')
fo = open(Output, 'w')
all = ''
while True:
    line = fi.readline()
    if not line:
        break
    if line.split('\t')[2] == 'mRNA':
        all += '///' + line
    else:
        all += line
fi.close
all = all.split("///")

for mRNA in all:
    if not mRNA:
        continue
    line = mRNA.split('\n')
    start = int(line[0].split('\t')[3])
    end = int(line[0].split('\t')[4])
    est = ''

    l1 = line[0].split('\t')[0]
    l2 = line[0].split('\t')[1]
    le = re.search('Parent=(.+?);',line[0]).group(1)
    if len(line) > 3:
        print(line[0],file=fo)
    for exon in reversed(line[1:len(line)-1]):
        if not est:
            est = exon.split('\t')[3]
            eed = exon.split('\t')[4]
        else:
            lest = est
            leed = eed
            est = exon.split('\t')[3]
            eed = exon.split('\t')[4]
            rst = int(leed) + 1
            red = int(est) - 1

            print(l1,l2,'intron',rst,red,'.','-','.','Parent=' + le,file = fo,sep = '\t')

fo.close
os.system("rm tmp.gff")

print("""
###########################################################################################################################
本脚本输出文件为 intron.gff 参考文件为 intron.gff.bak
！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！
参考文件 与 readme 中给出的格式不一致！ 例如 intron 位置信息的顺序为倒叙 而readme 中为顺序 。并且最后一列注释信息也不一致！
！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！
因此 本次结果不再与示例文件保持一致！
###########################################################################################################################
