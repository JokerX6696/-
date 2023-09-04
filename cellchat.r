rm(list=ls())
setwd('D:/desk/志成单细胞')
library('Seurat')
library('dplyr')
library('ggplot2')
library('monocle')
library('cowplot')
library('CellChat')

pbmc_cancer <- readRDS('Epithelial_cell_singlecell_object.clustering_resolution0.4.rds')
pbmc_cancer@meta.data$zfx_add <- rep('tumor',nrow(pbmc_cancer@meta.data))
pbmc_CAF <- readRDS('singlecell_object.clustering_resolution0.4.rds')
pbmc_CAF@meta.data$zfx_add <- pbmc_CAF@meta.data$clusters
pbmc_all <- merge(pbmc_CAF,pbmc_cancer)

sx <- pbmc_all@meta.data

# 创建 cellchat 对象

data.input <- GetAssayData(pbmc_all, assay = "RNA", slot = "data")  
labels <- Idents(pbmc_all)
meta <- data.frame(group = labels, row.names = names(labels)) # create a dataframe of the cell labels
meta$group <- pbmc_all@meta.data$zfx_add

##创建cellchat对象---Create a CellChat object using data matrix as input
cellchat <- createCellChat(object = data.input, meta = meta, group.by = "group")  #group.by对应meta的列名，报错改为group

##Add cell information into meta slot of the object
cellchat <- addMeta(cellchat, meta = meta, meta.name = "group")
cellchat <- setIdent(cellchat, ident.use = "group")        # set "labels" as default cell identity
levels(cellchat@idents)          # show factor levels of the cell labels
CellChatDB <- CellChatDB.human # use CellChatDB.mouse if running on mouse data

##选取分析亚集
## use a subset of CellChatDB for cell-cell communication analysis
CellChatDB.use <- subsetDB(CellChatDB, search = "Secreted Signaling")   # use Secreted Signaling
# #当然也可以使用所有 use all CellChatDB for cell-cell communication analysis
# CellChatDB.use <- CellChatDB # simply use the default CellChatDB

##set the used database in the object
cellchat@DB <- CellChatDB.use
unique(CellChatDB$interaction$annotation)

####对表达数据进行预处理，用于细胞间的通信分析####
##subset the expression data of signaling genes for saving computation cost
cellchat <- subsetData(cellchat)      # This step is necessary even if using the whole database
future::plan("multisession", workers = 4)  #报错提示版本不支持，改为---future::plan("multisession", workers = 4)
cellchat <- identifyOverExpressedGenes(cellchat)
cellchat <- identifyOverExpressedInteractions(cellchat)
cellchat <- projectData(cellchat, PPI.human) 

####相互作用推断####
cellchat <- computeCommunProb(cellchat,raw.use = FALSE)    #raw.use = FALSE--在运行了cellchat <- projectData(cellchat, PPI.human) 后设置------时间比较长
##Filter out the cell-cell communication if there are only few number of cells in certain cell groups
cellchat <- filterCommunication(cellchat, min.cells = 10)

##Infer the cell-cell communication at a signaling pathway level-推测细胞间在信号通路水平上的通讯
cellchat <- computeCommunProbPathway(cellchat)

##Calculate the aggregated cell-cell communication network
cellchat <- aggregateNet(cellchat)    
## cellchat@netP$pathways
## head(cellchat@LR$LRsig)

##showing the number of interactions or the total interaction strength (weights) between any two cell groups using circle plot.
groupSize <- as.numeric(table(cellchat@idents))
pdf('cellchat.pdf',width = 9,height = 9)
par(mfrow = c(1,2), xpd=TRUE)
netVisual_circle(cellchat@net$count, vertex.weight = groupSize, weight.scale = T, label.edge= F, title.name = "Number of interactions")
netVisual_circle(cellchat@net$weight, vertex.weight = groupSize, weight.scale = T, label.edge= F, title.name = "Interaction weights/strength")
dev.off()

##Here we also control the parameteredge.weight.maxso that we can compare edge weights between differet networks.

mat <- cellchat@net$weight
pdf('cellchat_node_weight.pdf',width = 9,height = 9)
par(mfrow = c(2,3), xpd=TRUE)
for (i in 1:nrow(mat)) {
  mat2 <- matrix(0, nrow = nrow(mat), ncol = ncol(mat), dimnames = dimnames(mat))
  mat2[i, ] <- mat[i, ]
  netVisual_circle(mat2, vertex.weight = groupSize, weight.scale = T, edge.weight.max = max(mat), title.name = rownames(mat)[i])
}
dev.off()

####使用层次结构图、圆图或弦图可视化每个信号通路####
####Hierarchy plot, Circle plot or Chord diagram
##All the signaling pathways showing significant communications can be accessed by
view_df <- cellchat@netP

pdf('cellchat_bubble.pdf',width = 9,height = 18)
netVisual_bubble(cellchat, sources.use = c("1", "2", "3", "4"), 
                 targets.use = 'tumor', remove.isolate = FALSE)
dev.off()

pdf('cellchat_heatmap.pdf',width = 9,height = 9)
netVisual_heatmap(cellchat,
                  color.heatmap = c("white", "firebrick3"),
                  measure = "weight",
                  color.use = c("#7FC97F", "#BEAED4", "#FDC086", "#386CB0",'#DC143C'),
                  )
dev.off()

saveRDS(cellchat, file = "cellchat_szc.rds")

