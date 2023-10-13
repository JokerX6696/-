# 对输入 cellphoneDB 软件的数据进行预处理
rm(list=ls())
setwd('D:/desk/志成单细胞')
library('Seurat')
# all_rds <- c('Epithelium_data_ob_v3.rds','B_cells_data_ob_v3.rds','T_cells_data_ob_v3.rds')
# Goblet_cells

obj <- readRDS('Epithelium_data_ob_v3.rds')
obj_Goblet_cells_R_7 <- subset(obj,sub_celltype=='Goblet_cells' & group=='R_7')
obj_Goblet_cells_S_7 <- subset(obj,sub_celltype=='Goblet_cells' & group=='S_7')
# Naive_B_cells Plasma_cells

obj <- readRDS('B_cells_data_ob_v3.rds')
obj_Naive_B_cells_R_7 <- subset(obj,sub_celltype=='Naive_B_cells' & group=='R_7')
obj_Naive_B_cells_S_7 <- subset(obj,sub_celltype=='Naive_B_cells' & group=='S_7')
obj_Plasma_cells_R_7 <- subset(obj,sub_celltype=='Plasma_cells' & group=='R_7')
obj_Plasma_cells_S_7 <- subset(obj,sub_celltype=='Plasma_cells' & group=='S_7')

# Natural_killer_T_cells  MAI_T_cells

obj <- readRDS('T_cells_data_ob_v3.rds')
obj_Natural_killer_T_cells_R_7 <- subset(obj,sub_celltype=='Natural_killer_T_cells' & group=='R_7')
obj_Natural_killer_T_cells_S_7 <- subset(obj,sub_celltype=='Natural_killer_T_cells' & group=='S_7')
obj_MAI_T_cells_R_7 <- subset(obj,sub_celltype=='MAI_T_cells' & group=='R_7')
obj_MAI_T_cells_S_7 <- subset(obj,sub_celltype=='MAI_T_cells' & group=='S_7')

rm(obj)
R_7 <- c(
  obj_Goblet_cells_R_7, 
  obj_Naive_B_cells_R_7, 
  obj_Plasma_cells_R_7,
  obj_Natural_killer_T_cells_R_7,
  obj_MAI_T_cells_R_7
  )
S_7 <- c(
  obj_Goblet_cells_S_7, 
  obj_Naive_B_cells_S_7, 
  obj_Plasma_cells_S_7,
  obj_Natural_killer_T_cells_S_7,
  obj_MAI_T_cells_S_7
)



newobj_R7 <- merge(x=obj_Goblet_cells_R_7,y=c(
  obj_Naive_B_cells_R_7, 
  obj_Plasma_cells_R_7,
  obj_Natural_killer_T_cells_R_7,
  obj_MAI_T_cells_R_7
))

newobj_S7 <- merge(x=obj_Goblet_cells_S_7,y=c(
  obj_Naive_B_cells_S_7, 
  obj_Plasma_cells_S_7,
  obj_Natural_killer_T_cells_S_7,
  obj_MAI_T_cells_S_7
))


# 提取细胞类型
meta_R7 <- data.frame(cell = rownames(newobj_R7@meta.data),cell_type=newobj_R7@meta.data$sub_celltype)
meta_S7 <- data.frame(cell = rownames(newobj_S7@meta.data),cell_type=newobj_S7@meta.data$sub_celltype)
write.table(meta_R7, file = "R7_celltype.txt", append = FALSE, quote = FALSE, sep = "\t",row.names = FALSE,col.names = TRUE)
write.table(meta_S7, file = "S7_celltype.txt", append = FALSE, quote = FALSE, sep = "\t",row.names = FALSE,col.names = TRUE)
# 提取稀疏矩阵
data_R7=as.data.frame(newobj_R7@assays$RNA@counts)
data_R7 <- data.frame(Gene=rownames(data_R7),data_R7)
data_S7=as.data.frame(newobj_S7@assays$RNA@counts)
data_S7 <- data.frame(Gene=rownames(data_S7),data_S7)
# 鸡2人
j2h <- read.table('homologene_in_2_out.xls',header = T)

data_R7 <- data_R7[data_R7$Gene %in% j2h$in_genenames,]
temp <- c()
for (i in data_R7$Gene) {
  ret <- j2h$out_genenames[which(i == j2h$in_genenames)]
  temp <- c(temp,ret)
}
data_R7$Gene <- temp

data_S7 <- data_S7[data_S7$Gene %in% j2h$in_genenames,]
temp <- c()
for (i in data_S7$Gene) {
  ret <- j2h$out_genenames[which(i == j2h$in_genenames)]
  temp <- c(temp,ret)
}
data_S7$Gene <- temp


write.table(data_R7, file = "R7_counts.txt", append = FALSE, quote = FALSE, sep = "\t",row.names = F,col.names = TRUE)
write.table(data_S7, file = "S7_counts.txt", append = FALSE, quote = FALSE, sep = "\t",row.names = F,col.names = TRUE)
