rm(list=ls())
setwd('D:/desk/志成单细胞/Scenic')
#### 引入需要的R包
library('foreach')
library('SCENIC')
library('Seurat')
library('GENIE3')
library('AUCell')
library('RcisTarget')
library('loomR')
library('stringr')
############ 处理 rds
# Goblet_cells

obj <- readRDS('../Epithelium_data_ob_v3.rds')
obj_Goblet_cells <- subset(obj,sub_celltype=='Goblet_cells')

# Naive_B_cells Plasma_cells

obj <- readRDS('../B_cells_data_ob_v3.rds')
obj_Naive_B_cells <- subset(obj,sub_celltype=='Naive_B_cells')

obj_Plasma_cells <- subset(obj,sub_celltype=='Plasma_cells' )


# Natural_killer_T_cells  MAI_T_cells

obj <- readRDS('../T_cells_data_ob_v3.rds')
obj_Natural_killer_T_cells <- subset(obj,sub_celltype=='Natural_killer_T_cells')

obj_MAI_T_cells <- subset(obj,sub_celltype=='MAI_T_cells')





new_obj <- merge(x=obj_Goblet_cells,y=c(
  obj_Naive_B_cells,
  obj_Plasma_cells,
  obj_Natural_killer_T_cells,
  obj_MAI_T_cells
))
# 鸡2人
# 鸡2人
j2h <- read.table('../homologene_in_2_out.xls',header = T)

data <- rownames(new_obj)[rownames(new_obj) %in% j2h$in_genenames]
temp <- c()
for (i in data) {
  ret <- j2h$out_genenames[which(i == j2h$in_genenames)]
  temp <- c(temp,ret)
}
new_obj <- new_obj[data,]


rownames(new_obj@assays$RNA@counts) <- temp
rownames(new_obj@assays$RNA@data) <- temp

# saveRDS(new_obj,file="./int/scenicOptions.rds")
# 
# 
# 
# 
# exprMat <- new_obj@assays$RNA@counts
# exprMat = as.matrix(exprMat)
# geneFiltering(exprMat, scenicOptions)
# 
# 
# 
# 
# cellinfo <- data.frame(new_obj@meta.data)
# initializeScenic初始化，导入评分数据库


dbfiles <- c(
'hg19-500bp-upstream-7species.mc9nr.feather',
'hg19-tss-centered-10kb-7species.mc9nr.feather'
)
names(dbfiles) <- c('500bp','10kb')
#  for(featherURL in dbfiles){download.file(featherURL,destfile=basename(featherURL))}
data(list="motifAnnotations_hgnc_v9", package="RcisTarget")
motifAnnotations_hgnc <- motifAnnotations_hgnc_v9
scenicOptions <- initializeScenic(org="hgnc",dbDir = "./",nCores=4, dbs=dbfiles)  # 
#motifAnnotations_hgnc <- motifAnnotations # 这里需要修改一下 对象名称 不知为什么会报错  motifAnnotations_hgnc 缺少对象

minCell4gene <- round(0.01 * ncol(new_obj))
exprMat <- GetAssayData(new_obj,slot = 'counts')
geneKept <- geneFiltering(as.matrix(exprMat),scenicOptions = scenicOptions,minCountsPerGene = 1,minSamples = minCell4gene)
exprMat_filtered <- exprMat[geneKept,]

runSCENIC_1_coexNetwork2modules(scenicOptions = scenicOptions)
tf_names <- getDbTfs(scenicOptions = scenicOptions)
df_names <- CaseMatch(search = tf_names,match = rownames(new_obj))
scenicOptions@settings$seed <- 1311
# runGenie3(as.matrix(exprMat_filtered[,sample(1:10090,2000)]),scenicOptions = scenicOptions)
# library(reticulate)
# arb.algo = import('arboreto.algo')
# adjacencies <- arb.algo$grnboost2(as.data.frame(t(as.matrix(exprMat_filtered))),tf_names <- tf_names ,seed = 1311)
