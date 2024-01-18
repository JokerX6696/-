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