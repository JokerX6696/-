rm(list=ls())
setwd('D:/desk/志成单细胞/Scenic')
dir.create(tempdir())
#### 引入需要的R包
library('foreach')
library('SCENIC')
library('Seurat')
library('GENIE3')
library('AUCell')
library('RcisTarget')
library('loomR')
library('stringr')
library('reticulate')
# 读取 rds
Seurat_obj <- readRDS('cells_5.rds')
# motif db
dbfiles <- c(
  'hg19-500bp-upstream-7species.mc9nr.feather',
  'hg19-tss-centered-10kb-7species.mc9nr.feather'
)
names(dbfiles) <- c('500bp','10kb')
data(list="motifAnnotations_hgnc_v9", package="RcisTarget")
motifAnnotations_hgnc <- motifAnnotations_hgnc_v9
scenicOptions <- initializeScenic(org="hgnc",dbDir = "./",nCores=1, dbs=dbfiles)
minCell4gene <- round(0.01 * ncol(Seurat_obj))
exprMat <- GetAssayData(Seurat_obj,slot = 'counts')
geneKept <- geneFiltering(as.matrix(exprMat),scenicOptions = scenicOptions,minCountsPerGene = 1,minSamples = minCell4gene)
exprMat_filtered <- exprMat[geneKept,]
tf_names <- getDbTfs(scenicOptions = scenicOptions)
df_names <- CaseMatch(search = tf_names,match = rownames(Seurat_obj))
scenicOptions@settings$seed <- 1311
# runGenie3(as.matrix(exprMat_filtered[,sample(1:10090,2000)]),scenicOptions = scenicOptions)
arb.algo = import('arboreto.algo')
adjacencies <- arb.algo$grnboost2(as.data.frame(t(as.matrix(exprMat_filtered))),tf_names = tf_names )
colnames(adjacencies) <- c('TF','Target','weight') 
saveRDS(adjacencies,file = getIntName(scenicOptions,'genie3ll'))
runCorrelation(as.matrix(exprMat_filtered), scenicOptions)
runSCENIC_1_coexNetwork2modules(scenicOptions = scenicOptions)
runSCENIC_2_createRegulons(scenicOptions = scenicOptions,coexMethods = 'top10perTarget')
runSCENIC_3_scoreCells(scenicOptions = scenicOptions,log2(as.matrix(exprMat_filtered+1)))
#Seurat_obj[['SCENIC']] = CreateAssayObject(counts=regulonAUC_mat)
scenicOptions <- runSCENIC_4_aucell_binarize(scenicOptions = scenicOptions)
# 图片展示
Idents(object = Seurat_obj) = Seurat_obj@meta.data$sub_celltype
cellInfo <- data.frame(Clusters = Idents(object = Seurat_obj))
regulonAUC <- loadInt(scenicOptions,'aucell_regulonAUC')
regulonAUC <- regulonAUC[onlyNonDuplicatedExtended(rownames(regulonAUC)),]
regulonActivity_byClusters <- sapply(split(rownames(cellInfo),
cellInfo$Clusters),function(cells)
                                rowMeans(getAUC(regulonAUC[,cells])))
regulonActivity_byClusters_Scaled <- t(scale(t(regulonActivity_byClusters),center = T,scale = T))
# 画热图
pdf('regulonActivity_byClusters_Scaled.pdf',height = 8)
pheatmap(regulonActivity_byClusters_Scaled,
         color = colorRampPalette(c("navy", "white", "firebrick3"))(50),
         cellwidth = 15,
         fontsize = 6
         )
dev.off()
## 映射 AUC 降维结果
regulonAUC <- readRDS('int/3.4_regulonAUC.Rds')
regulonAUC <- regulonAUC[onlyNonDuplicatedExtended(rownames(regulonAUC)),]
regulonAUC_mat <- AUCell::getAUC(regulonAUC)
rownames(regulonAUC_mat) <- gsub("-","_",rownames(regulonAUC_mat))
regulonAUC_mat_out <- regulonAUC_mat[grep(pattern = "-extended",rownames(regulonAUC_mat),invert = T),]                                           
BINmatrix <- data.frame(t(regulonAUC_mat_out),check.names = F)
BINmatrix <- data.frame(BINmatrix,check.names = F)
# 修改名称
ReegulonName_BIN <- colnames(BINmatrix)
ReegulonName_BIN <- gsub(' \\(','_',ReegulonName_BIN)
ReegulonName_BIN <- gsub('\\)','',ReegulonName_BIN)
colnames(BINmatrix) <- ReegulonName_BIN
scRNAbin <- AddMetaData(Seurat_obj,BINmatrix)
for (gene in ReegulonName_BIN) {
  p1 <- FeaturePlot(sc,features = gene,label = T,reduction = 'umap')
  ggsave(filename = paste0(gene,"_AUC_umap.pdf"),device = 'pdf',plot = p1)
  
}
# 小提琴和山脊图
AUCmatrix <- readRDS('int/3.4_regulonAuc.Rds')
AUCmatrix <- AUCmatrix@assays@data@listData$AUC
AUCmatrix <- data.frame(t(AUCmatrix), check.name=F)
RegulonName_AUC <- colnames(AUCmatrix)
RegulonName_AUC <- gsub('\\.\\.','_',RegulonName_AUC)
RegulonName_AUC <- gsub('\\.','',RegulonName_AUC)
colnames(AUCmatrix) <- RegulonName_AUC
scRNAauc <- AddMetaData(Seurat_obj,AUCmatrix)
# plot
for (gene in RegulonName_AUC) {  # 最后一次循环可以无视
  p1 <- RidgePlot(scRNAauc,features = gene,group.by = 'sub_celltype') + theme(legend.position = 'none')
  p2 <- VlnPlot(scRNAauc,features = gene,pt.size = 0,group.by = 'sub_celltype') + theme(legend.position = 'none')
  p <- p1 + p2
  ggsave(filename = paste0(gene,"_AUC_xtq_sj.pdf"),device = 'pdf',plot = p,width = 10,height = 8)
  
}
# 气泡图
regulonAUC <- loadInt(scenicOptions,'aucell_regulonAUC')
Idents(Seurat_obj) <- Seurat_obj@meta.data$sub_celltype
cellInfo <- data.frame(Celltype=Idents(Seurat_obj))
rss <- calcRSS(AUC=getAUC(regulonAUC),cellAnnotation = cellInfo[colnames(regulonAUC,'celltype'),])
rss <- rss[1:30,]
p <- plotRSS(rss,
             col.low = '#473172',
             col.mid = '#20988b',
             col.high = '#f9e920'
)
pdf('rssPlot.pdf',width = 6,height = 10)
p
dev.off()
# 
for (g in colnames(rss)) {
  out <- paste0(g,'_rssPlot.pdf')
  p <- plotRSS_oneSet(rss,n = 5,setName = g)

  ggsave(filename = out,plot = p,device = 'pdf',width = 6,height = 9)
}


