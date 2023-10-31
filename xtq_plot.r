rm(list=ls())
library('Seurat')
library('ggplot2')
rds <- 'new_celltype_20230403.rds'
genes <- c('IGF1','IGF1R', 'IGF2R', 'INS')

obj <- readRDS(rds) 
obj = UpdateSeuratObject(object =obj) # 如果不兼容可以考虑更新一下 seurat 对象
#Idents(obj) <- obj@meta.data$new_celltype
  
p <- VlnPlot(obj, 
        features = genes,
        pt.size = 0,
        ncol = 1,
        group.by = "new_celltype",
        #stack = T,
        #pt.size=0,
        #flip = T,
        #add.noise = T
        ) 
# + 
#   theme(axis.text.y = element_blank(),
#         
#         axis.ticks.y = element_blank(),
#         
#         axis.title = element_blank(),
#         
#         axis.text.x = element_text(colour = 'black',size = 10,angle = 90),
#         
#         legend.position = 'none')



ggsave(filename = 'Expression.png',device = 'png',plot = p,height = 12,width = 9)



