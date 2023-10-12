#  志成 鸡 单细胞 分析
#  单细胞 GSEA 分析
rm(list=ls())
setwd("D:/desk/志成单细胞")
library('ggplot2')
library('Seurat')
library('msigdbr')
library('clusterProfiler')
library('enrichplot')
all_rds <- c('Epithelium_data_ob_v3.rds','B_cells_data_ob_v3.rds','T_cells_data_ob_v3.rds')
# 读取 rds
cell_type <- 'MAI_T_cells'
sc_data <- readRDS('T_cells_data_ob_v3.rds')
sc_data <- subset(x = sc_data,sub_celltype==cell_type)

sx <- sc_data@meta.data

mk_gene <- FindMarkers(object = sc_data,ident.1 = "R_7", ident.2 = "S_7",assay = 'RNA',group.by = 'group')
mk_gene <- mk_gene[order(mk_gene$avg_log2FC,decreasing = TRUE),]
#  GSEA
# msigdbr_species()  查看 migdbr 包 支持哪些物种
genesets <- msigdbr(species = 'Gallus gallus')
genesets <- subset(genesets,select = c("gs_name", "gene_symbol"))
genelist <- structure(mk_gene$avg_log2FC,names=rownames(mk_gene))
#genelist <- genelist[names(genelist) %in% genesets$gene_symbol]  # 有些基因数据集没有


ret <- GSEA(geneList = genelist,TERM2GENE = genesets)
dir.create(cell_type)
setwd(cell_type)
# 结果保存
res <-  data.frame(ret)
write.csv(res,paste0(cell_type,'_GSEA','.csv'),row.names = F)
#gseaplot(x = ret,geneSetID = 1,title = ret@result$ID[1],by = 'runningScore')
for (i in seq_along(ret@result$ID)) {
  p <- gseaplot2(x = ret,geneSetID = i,color="red",pvalue_table = F,title=ret@result$ID[[i]],base_size=10,ES_geom="line")
  ggsave(filename = paste0(cell_type,'-',ret@result$ID[[i]],'.pdf'),plot = p,device = 'pdf',width = 9,height = 6)
}

