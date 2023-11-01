rm(list=ls())
library('Seurat')
library('ggplot2')
library('patchwork')   
rds <- 'new_celltype_20230403.rds'
genes <- unique(c('IGF1','IGF1R', 'IGF2R', 'INS','INSR','IGF','IGF1R',  'IGF2R','INSR','GOT2','OGT1','OGT2','FGF5','FGFR'))
genes <- genes[genes %in% rownames(obj)]
obj <- readRDS(rds) 
obj = UpdateSeuratObject(object =obj) # 如果不兼容可以考虑更新一下 seurat 对象
#Idents(obj) <- obj@meta.data$new_celltype

obj_t <- subset(obj,subset = (sampleid == 'T'))
obj_n <- subset(obj,subset = (sampleid == 'N'))

p_all <- list()
for (i in 1:7) {
  p_all[[i]] <- VlnPlot(obj_t, 
                        features = genes[i],
                        pt.size = 0,
                        ncol = 1,
                        group.by = "new_celltype",
  ) +
    theme(axis.text.y = element_blank(),
          
          axis.ticks.y = element_blank(),
          
          axis.title = element_blank(),
          
          axis.text.x = element_text(colour = 'black',size = 10,angle = 45),
          
          legend.position = 'none',
          )
}

p <- p_all[[1]] + p_all[[2]] + p_all[[3]] + p_all[[4]] + p_all[[5]] + p_all[[6]] + p_all[[7]] +
  plot_annotation(title = "Tumor",theme = theme(plot.title = element_text(size = 20,hjust = 0.5,face = "bold"))) 
  


ggsave(filename = 'Tumor_Expression.png',device = 'png',plot = p,height = 16,width = 9)
ggsave(filename = 'Tumor_Expression.pdf',device = 'pdf',plot = p,height = 16,width = 9)


p_all <- list()
for (i in 1:7) {
  p_all[[i]] <- VlnPlot(obj_n, 
                        features = genes[i],
                        pt.size = 0,
                        ncol = 1,
                        group.by = "new_celltype",
  ) +
    theme(axis.text.y = element_blank(),
          
          axis.ticks.y = element_blank(),
          
          axis.title = element_blank(),
          
          axis.text.x = element_text(colour = 'black',size = 10,angle = 45),
          
          legend.position = 'none',
    )
}

p <- p_all[[1]] + p_all[[2]] + p_all[[3]] + p_all[[4]] + p_all[[5]] + p_all[[6]] + p_all[[7]] +
  plot_annotation(title = "Normal",theme = theme(plot.title = element_text(size = 20,hjust = 0.5,face = "bold"))) 



ggsave(filename = 'Normal_Expression.png',device = 'png',plot = p,height = 16,width = 9)
ggsave(filename = 'Normal_Expression.pdf',device = 'pdf',plot = p,height = 16,width = 9)
