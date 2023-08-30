rm(list=ls())
setwd('D:/desk/志成单细胞')
library('Seurat')
library('dplyr')
library('ggplot2')
library('monocle')
library('cowplot')
pbmc <- readRDS('singlecell_object.clustering_resolution0.4.rds')
pbmc@meta.data$seurat_clusters <-  pbmc@meta.data$clusters

######################################################################################################
# 拟时序分析
all_select <- c("seurat_clusters", "clusters")
data <- as(as.matrix(pbmc@assays$RNA@counts),'sparseMatrix')
pd <- new('AnnotatedDataFrame', data = pbmc@meta.data)
fData <- data.frame(gene_short_name = row.names(data), row.names = row.names(data))
fd <- new('AnnotatedDataFrame', data = fData)
#构建S4对象，CellDataSet
HSMM <- newCellDataSet(data,
                       phenoData = pd,
                       featureData = fd,
                       lowerDetectionLimit = 0.5,
                       expressionFamily = negbinomial.size())
# 估计size factors 和 dispersions
HSMM <- estimateSizeFactors(HSMM)
HSMM <- estimateDispersions(HSMM)
# 过滤低质量细胞
HSMM <- detectGenes(HSMM, min_expr = 3 )


expressed_genes <- row.names(subset(fData(HSMM),
                                    num_cells_expressed >= 10))

# 选择基因
# 1   
diff_test_res <- differentialGeneTest(HSMM[expressed_genes,],fullModelFormulaStr = "~ clusters")  #"~ seurat_clusters"
# diff_test_res <- VariableFeatures(pbmc)
# a <- setOrderingFilter(pbmc, diff_test_res)


ordering_genes <- row.names (subset(diff_test_res, qval < 0.01)) ## 不要也写0.1 ，而是要写0.01。

HSMM <- setOrderingFilter(HSMM, ordering_genes)
#plot_ordering_genes(HSMM)
# 降维 & 排序
HSMM <- reduceDimension(HSMM, max_components = 3,
                        num_dim = 20,
                        method = 'DDRTree') # DDRTree方式



#HSMM <- orderCells(HSMM)
colour=c("#DC143C","#0000FF","#20B2AA","#FFA500","#9370DB","#98FB98","#F08080","#1E90FF","#7CFC00","#FFFF00",  
         "#808000","#FF00FF","#FA8072","#7B68EE","#9400D3","#800080","#A0522D","#D2B48C","#D2691E","#87CEEB","#40E0D0","#5F9EA0",
         "#FF1493","#0000CD","#008B8B","#FFE4B5","#8A2BE2","#228B22","#E9967A","#4682B4","#32CD32","#F0E68C","#FFFFE0","#EE82EE",
         "#FF6347","#6A5ACD","#9932CC","#8B008B","#8B4513","#DEB887")

pdf(file = 'trajectory_analysis2.pdf',width = 9,height = 6)
plot_cell_trajectory(HSMM, color_by = "seurat_clusters") + scale_color_manual(values = colour)
dev.off()










######################################################################################################
# 绘制 heatmap 图 使用提供的基因
# pbmc.markers <- FindAllMarkers(pbmc,only.pos = T,min.pct = 0.1,logfc.threshold = 0.25)
# top10 <- pbmc.markers %>% group_by(cluster) %>% top_n(n=10,wt = avg_log2FC)
gene_list <- c('MMP14','LOXL2','CTHRC1','POSTN','CXCL12','CXCL1','IL6','IL1B','MMP1','MMP3','FN1','COL1A1','COL1A2','COL3A1','COL5A2','COL12A1','COL6A3','VEGFA','GDF15','NRG1','AREG','HGF','BMP2')


pdf(file = 'gene_heatmap.pdf',width = 9,height = 6)
DoHeatmap(
  pbmc,
  features = gene_list,
  assay = "RNA",
  group.colors = c("#00468BFF", "#ED0000FF", "#42B540FF", "#0099B4FF") 
  ) + 
  scale_fill_gradientn(colors = c("navy", "white", "firebrick3")) +
  NoLegend()

dev.off()
