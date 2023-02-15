rm(list=ls())
setwd('D:/desk/R_temp')
library(ggplot2)
library(reshape2)
df <- read.table('all_sample_stat.txt',sep = '\t',header = TRUE)
df$sample <- c('Carassius auratus','Cyprinus carpio','Megalobrama amblycephala')
data <- melt(df,id.vars = 'sample')
data$variable <- gsub('\\.', '-', data$variable)
colnames(data)[1] <- 'Species'
COL <- c('#65C291','#FC8C64','#8EA0CB')

ggplot(data = data,mapping = aes(x=factor(variable,levels = rev(unique(data$variable))), y = value, fill = Species)) + 
  geom_bar(stat = 'identity',colour="#414141",width=0.6,position = "fill") +
  labs(x="",y="Percent") +
  scale_fill_manual(breaks = data$Species,values = COL) +
  scale_y_continuous(breaks=c(0.00,0.25,0.50,0.75,1.00), labels = c('0%','25%','50%','75%','100%')) +
  #geom_text(data = data,mapping = aes(x=factor(variable,levels = rev(unique(data$variable))), y = value),label = 2) +
  coord_flip() + 
  theme_bw() +
  theme(axis.text.x = element_text(angle = 0,vjust = 0.5,hjust = 0.5) )
ggsave(filename = 'All_sample.png',device = 'png',width = 8, height = 6)
ggsave(filename = 'All_sample.pdf',device = 'pdf',width = 8, height = 6)
