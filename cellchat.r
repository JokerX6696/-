rm(list=ls())
setwd('D:/desk/志成单细胞')
library('Seurat')
library('dplyr')
library('ggplot2')
library('monocle')
library('cowplot')

# #pbmc <- readRDS('Epithelial_cell_singlecell_object.clustering_resolution0.4.rds')
pbmc_cancer <- readRDS('Epithelial_cell_singlecell_object.clustering_resolution0.4.rds')
pbmc_CAF <- readRDS('singlecell_object.clustering_resolution0.4.rds')

# pbmc <- readRDS('new_celltype_20230403.rds')
# 
# con <- pbmc


l_test <- pbmc_cancer@meta.data
l_test2 <- pbmc_CAF@meta.data
nrow(pbmc_CAF)
