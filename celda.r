rm(list=ls())
setwd('D:/desk/wkdir/scRNA')
######### lib
library('celda')
library('Seurat')
# 数据导入
raw_dir <- 'D:/desk/wkdir/scRNA/pbmc3k_filtered_gene_bc_matrices/filtered_gene_bc_matrices/hg19'
pbmc.counts <- Read10X(data.dir = raw_dir)
# 创建Seurat对象
pbmc <- CreateSeuratObject(counts = pbmc.counts)


new_obj <- decontX(
  x=pbmc@assays$RNA@counts
  )

col <- new_obj$contamination < 0.2

#    fin_obj <- CreateSeuratObject(counts=new_obj$decontXcounts[,col])
fin_obj <- CreateSeuratObject(counts=new_obj$decontXcounts)



fin_obj$wrxz <- new_obj$contamination

fin_obj <- subset(fin_obj,subset= wrxz<0.2)

test_1 <- subset(new_obj,new_obj$contamination<0.2)

# pbmc <- readRDS('D:/desk/志成单细胞/new_celltype_20230403.rds')
# 
# 
# new_obj <- decontX(
#   x=pbmc@assays$RNA@counts
# )
# 
