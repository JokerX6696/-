rm(list=ls())
setwd('D:/desk/何胜夫售后/20230224_DOE202213632-b2_何胜夫-孙雅婷-73个人2bRAD-M项目_结题报告/PA/item6')
library(reshape2)
library(ggplot2)
library(ggpubr)
library(ggsignif)
df <- read.table('diff_species_top30_boxplot.txt',header = TRUE, sep = '\t', quote = "", comment.char = "")

SP <- "Malassezia_globosa"
df <- df[which(df$id == SP),]





#df$Sample <- sub("\\d+$","",df$Sample)

colnames(df)[3] <-"Value"

p <- ggplot(data=df, aes(x=Group,y=Value))+
  geom_boxplot(aes(fill=Group),outlier.size = 0,show.legend = F,outlier.shape = NA) +
  geom_jitter() + 
  scale_fill_manual(breaks = unique(df$Group),values = c('#E41A1C','#377EB8')) +
  labs(title='',x='',y="Abundance")+
  #geom_signif(comparisons = list(fa), test = t.test, step_increase = 0.2,label = "p.signif") +  # t.test 显著性数值
  stat_compare_means(label = "p.signif",label.x = 1.5) +
  theme_bw()+
  theme(axis.text.x = element_text(size=12,angle = 0,face = "bold",vjust=0),
        strip.text.x = element_text(colour = "black", angle = 90, size = 8,hjust = 0.5, vjust = 0.4),
        strip.background = element_rect(colour = "white", fill = "white"),
        plot.title = element_text(hjust = 0.5))
ggsave(filename = "Malassezia_globosa.pdf",plot = p,device = 'pdf',width = 9,height = 6)
ggsave(filename = "Malassezia_globosa.png",plot = p,device = 'png',width = 9,height = 6) 
  #          dev.off()             
