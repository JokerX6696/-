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


