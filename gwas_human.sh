#  获取 gwas snp vcf
/data/software/conda_envs/snakemake_v6.1.1/bin/python scripts/3.Var/vcf_filter.py \
-i result/03.variants/vcf_filter_pop/Filter.snp.vcf.gz \
-s Phenotype_Data/trait_sample.list \
-c /data/database/reference/Homo_sapiens/ncbi/GRCh37.p13/genome.fa.sizes.chrom \
--maf 0.05 \
--missing 0.2 \
-o result/03.variants/GWAS_vcf/GWAS.snp.vcf 

/data/software/htslib/htslib-v1.9/bin/bgzip result/03.variants/GWAS_vcf/GWAS.snp.vcf 
/data/software/htslib/htslib-v1.9/bin/tabix result/03.variants/GWAS_vcf/GWAS.snp.vcf.gz

# GWAS_vcf_to_ped

/data/software/vcftools/0.1.17/bin/vcftools \
--gzvcf result/03.variants/GWAS_vcf/GWAS.snp.vcf.gz \
--chrom-map result/utils/chrom_map_GWAS.txt \
--maf 0.05 \
--plink \
--out result/05.Plink/GWAS/merge/plink


cp result/05.Plink/GWAS/merge/plink.ped result/05.Plink/GWAS/merge/plink_Scaffold.ped
cp result/05.Plink/GWAS/merge/plink.map result/05.Plink/GWAS/merge/plink_Scaffold.map
awk '{{print "Scaffold"$0}}' result/05.Plink/GWAS/merge/plink.map > result/05.Plink/GWAS/merge/plink_Scaffold.map


# prune
# 用plink(v1.90b6.7)软件过滤出连锁平衡的位点(.in文件中)
/data/software/plink/1.90b6.7/plink \
--threads 8 \
--memory 50000 \
--file result/05.Plink/GWAS/merge/plink_Scaffold \
--indep-pairwise 50 5 0.5 \
--aec \
--out result/05.Plink/GWAS/prune/plink_Scaffold

# 用plink(v1.90b6.7)软件根据.in文件从原始的ped和map文件中提取出连锁平衡的位点(.prune.ped和.prune.map文件),用于后续的群体结构分析

/data/software/plink/1.90b6.7/plink \
--threads 8 \
--allow-extra-chr \
--memory 14000 \
--file result/05.Plink/GWAS/merge/plink_Scaffold \
--extract result/05.Plink/GWAS/prune/plink_Scaffold.prune.in \
--recode \
--out result/05.Plink/GWAS/prune/plink_Scaffold.prune

cp result/05.Plink/GWAS/prune/plink_Scaffold.prune.ped result/05.Plink/GWAS/prune_PCA/plink.prune.ped
cp result/05.Plink/GWAS/prune/plink_Scaffold.prune.map result/05.Plink/GWAS/prune_PCA/plink.prune.map
sed -i "s#Scaffold##g" result/05.Plink/GWAS/prune_PCA/plink.prune.map

########处理表型数据#######

/data/software/Anaconda3/envs/mro-v3.5.1/bin/Rscript scripts/GWAS/Trait_check.r \
-r Phenotype_Data/raw_trait_data.txt \
-p Phenotype_Data/traits_distribution \
-c Phenotype_Data/clean_trait_data.txt


#######处理基因型数据########
/data/software/plink/1.90b6.7/plink \
--threads 8 \
--file result/05.Plink/GWAS/merge/plink \
--recode 12 \
--transpose \
--aec \
--out result/05.Plink/GWAS/merge/plink_GWAS

# kinship_matrix
# pdi=`pwd`
# ln -s $pdi/result/05.Plink/GWAS/merge/plink_GWAS.tped result/07.GWAS/PLINK
# ln -s $pdi/result/05.Plink/GWAS/merge/plink_GWAS.tfam result/07.GWAS/PLINK
# cd result/07.GWAS/PLINK
# {emmax_kin} -v -d 10 {params.prefix} 



/data/software/plink/1.90b6.7/plink --file result/05.Plink/GWAS/merge/plink_GWAS --make-bed --pheno Phenotype_Data/lisan_trait_data.txt --out output_data

/data/software/plink/1.90b6.7/plink --bfile output_data --allow-no-sex --assoc --out result/07.GWAS/ret/output_results
