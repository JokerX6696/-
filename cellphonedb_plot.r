rm(list=ls())
setwd('D:/desk/志成单细胞/R7')

#首先对数据进行过滤
mypvals <- read.table("statistical_analysis_pvalues_result.txt",header = T,sep = "\t",stringsAsFactors = F)
mymeans <- read.table("statistical_analysis_means_result.txt",header = T,sep = "\t",stringsAsFactors = F)
##对数据过滤，至少有一个受配体对pvals小于005才被保留
logi <- apply(mypvals[,5:ncol(mypvals)]<0.05, 1, sum) 
choose_pvalues <- mypvals[logi>=1,]

# 去掉空值
logi1 <- choose_pvalues$gene_a != ""
logi2 <- choose_pvalues$gene_b != ""
logi <- logi1 & logi2
choose_pvalues <- choose_pvalues[logi,]
#同样条件过滤meanS
choose_means <- mymeans[mymeans$id_cp_interaction %in% choose_pvalues$id_cp_interaction,]


##示例数据取前50行
choose_means <-choose_means[1:4,]
choose_pvalues <- choose_pvalues[1:4,]
# 将choose_pvalues和choose_means数据宽转长
library(tidyverse)
meansdf <- choose_means %>% reshape2::melt()
meansdf <- data.frame(interacting_pair = paste0(meansdf$gene_a,"_",meansdf$gene_b),
                      CC = meansdf$variable,
                      means = meansdf$value)
pvalsdf <- choose_pvalues %>% reshape2::melt()
pvalsdf <- data.frame(interacting_pair = paste0(pvalsdf$gene_a,"_",pvalsdf$gene_b),
                      CC = pvalsdf$variable,
                      pvals = pvalsdf$value)

# 合并p值和mean文件
pvalsdf$joinlab<- paste0(pvalsdf$interacting_pair,"_",pvalsdf$CC)
meansdf$joinlab<- paste0(meansdf$interacting_pair,"_",meansdf$CC)
pldf <- merge(pvalsdf,meansdf,by = "joinlab")

# dotplot可视化
summary((filter(pldf,means >0))$means)
head(pldf)


ggplot(data = pldf, aes(x = CC.x, y = interacting_pair.x)) +
  geom_point(aes(size = -log10(pvals), fill = log2(means)), 
             shape = 21, color = 'black', stroke = 1) +
  labs(x = 'cell', y = 'interacting_pair.x') +
  scale_size_area(name = 'log10(pvalue)',
                  breaks = seq(0, 2, 0.5),
                  limits = c(0, 2),
                  max_size = 5.5) +
  scale_fill_gradient2(low = '#08519c', 
                       mid = 'white', 
                       high = 'red',
                       limits = c(-5, 5),
                       name = 'log2(means)',
                       na.value = '#08519c') +
  theme(strip.background = element_blank(),
        strip.text.x = element_text(family = 'sans', size = 15),
        panel.background = element_rect(fill = 'white'),
        panel.grid = element_blank(),
        panel.border = element_rect(fill = NA, color = 'gray', linewidth = 2),
        axis.title.x = element_text(family = 'sans', face = 'bold', size = 15),
        axis.text = element_text(family = 'sans', colour = 'black'),
        axis.ticks = element_line(linewidth = 1))+
  theme(axis.text.x = element_text(angle = -45,hjust = -0.1,vjust = 0.8))

