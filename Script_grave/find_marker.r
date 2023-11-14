rm(list=ls())
setwd('D:/desk/xtq_plot')
#  positive  negative
library('Seurat')
obj <- readRDS('new_celltype_20230403.rds')

sx <- obj@meta.data

sp_obj <- subset(x = obj,subset = (new_celltype == 'Epithelial cell'))

cl <- as.vector(ifelse(sp_obj@assays$RNA@data['INSR',] > 0,'positive','negative'))

sp_obj@meta.data$INSR <- cl


genelist <- FindMarkers(object = sp_obj,group.by = 'INSR',ident.1 = 'positive',ident.2 = 'negative')

gene <- rownames(genelist)

write.table(file = 'genelist.txt',x=gene,quote = F,sep = '\t',row.names = F,col.names = F)

write.table(file = 'diff_gene.xls',x=genelist,quote = F,sep = '\t',row.names = T,col.names = T)




