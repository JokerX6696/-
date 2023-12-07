# -*- coding: utf-8 -*-
import os
import argparse

#############################################################################
#Author：Terry Xizzy txizzy#gmail.com
#Describtion: splitbam.py is a mulit processes tool for spilt the big bam file.
#Version: V1.0
#Data: 2021/10/19
#Example: python splitbam.py -input test.bam -p 12 -outdir ./
#############################################################################

parser=argparse.ArgumentParser(description='splitbam.py is a mulit processes tool for spilt the big bam file.')
parser.add_argument('-input',type=str,help='Input your bamfile',required=True)
parser.add_argument('-outdir',type=str,help='Input your output bamfile directory',required=True)
parser.add_argument('-p',type=int,help='Input the thread counts',default=12)
parser.add_argument('--index',action="store_true",help='Make index for splited bam files')
args=parser.parse_args()

bamfile = args.input
thread_count = args.p
outdir = args.outdir
#创建输出文件路径
if not os.path.exists(outdir):
    os.makedirs(outdir)

print("Split bam file, it may takes some time……")
samtools = '/data/software/samtools/samtools-v1.3.1/bin/samtools'
def split_bam():
    split_cmd = "%s view -H %s | cut -f 2 | grep SN | cut -f 2 -d \":\" > %s/chr.txt"%(samtools,bamfile,outdir)
    os.system(split_cmd) #得到该bam文件的所有染色体号
    with open(outdir+'/chr.txt','r') as chr_file:
        chr_n = chr_file.readlines()
        for item in chr_n:
            item = item.rstrip('\n')
            #分割bam，并对bam文件排序
            os.system("{samtools} view -@ {tn} -b {bam} {chr} | {samtools} sort -@ {tn} -o {out}/{chr}.bam".format(samtools=samtools,tn=thread_count,bam=bamfile,chr=item,out=outdir))
            if args.index:
               os.system("{samtools} index {out}/{chr}.bam {out}/{chr}.bam.bai".format(samtools=samtools,out=outdir,chr=item))
        os.remove(outdir+'/chr.txt')

split_bam()
print("All done!")