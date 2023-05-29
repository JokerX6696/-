rm(list=ls())
setwd('D:\\desk\\XMSH_202305_3817\\PA\\2')
library('ggplot2')
library(ggsignif)
file <- 'cl_Alpha_diversity_Index.xls'
df <- read.table(file, sep = '\t',header = TRUE)
df$group_cl <- sub("_.*$","",df$Sample)
df$group_xf <- sub("_..?\\s$","",df$Sample)
################"GC","NAC_E","NAC_NE","ICI_E","ICI_NE"
color_xf <- c("#2E75CE","#9AAF8C","#F4B083","#538035","#C00000")
color_cl <- c("#2E75CE","#9AAF8C","#C00000")
###############################################################

df$group_cl <- factor(df$group_cl,levels = c("GC","NAC","ICI"))
max = floor(max(df$Shannon)) + 0.5
###############################################################
p <- ggplot(data = df,mapping = aes(x=group_cl,y=Shannon,fill=group_cl)) +
  stat_boxplot(geom = "errorbar", width=0.1,size=0.8) +
  geom_boxplot(outlier.colour="white",size=0.8) +
  xlab("Group") +
  scale_fill_manual(breaks = c("GC","NAC","ICI"),values = color_cl) +
  theme_bw() +
  theme(panel.background =element_blank(), #背景
        axis.line=element_line(),#坐标轴的线设为显示
        legend.position="none",
        plot.title = element_text(size=12,hjust=0.5))+#图例位置
  geom_jitter(width = 0.2)+#添加抖动点
  ggtitle("Boxplot") + #标题
  geom_signif(comparisons = list(c("ICI","NAC"),c("NAC","GC"),c("ICI","GC")),#设置需要比较的组
            test = 'wilcox.test', ##计算方法
            y_position = c(max+0.4,max+0.8,max),#图中横线位置设置
            tip_length = c(c(0.05,0.05),c(0.05,0.05),c(0.05,0.05)),#横线下方的竖线设置
            size=0.8,color="black") 
ggsave(filename = 'cl_Shannon_Boxplot.pdf',plot = p,device = 'pdf',width = 9,height = 6)
ggsave(filename = 'cl_Shannon_Boxplot.png',plot = p,device = 'png',width = 9,height = 6)
#########################################################################################

df$group_xf <- factor(df$group_xf,levels = c( "GC","NAC_E","NAC_NE","ICI_E","ICI_NE"))
max = floor(max(df$Shannon)) + 0.5
td <- combn(c( "GC","NAC_E","NAC_NE","ICI_E","ICI_NE"),2)
ltd <- list(c(td[,1]),c(td[,2]),c(td[,3]),c(td[,4]),c(td[,5]),c(td[,6]),c(td[,7]),c(td[,8]),c(td[,9]),c(td[,10]))
ytd <- c(max+0.5,max+1,max+1.5,max+2,max+2.5,max+3,max+3.5,max+4,max+4.5,max+5)
tip <- c(c(0.05,0.05),c(0.05,0.05),c(0.05,0.05),c(0.05,0.05),c(0.05,0.05),c(0.05,0.05),c(0.05,0.05),c(0.05,0.05),c(0.05,0.05),c(0.05,0.05))
###############################################################
p <- ggplot(data = df,mapping = aes(x=group_xf,y=Shannon,fill=group_xf)) +
  stat_boxplot(geom = "errorbar", width=0.1,size=0.8) +
  geom_boxplot(outlier.colour="white",size=0.8) +
  xlab("Group") +
  theme_bw() +
  scale_fill_manual(breaks = c("GC","NAC_E","NAC_NE","ICI_E","ICI_NE"),values = color_xf) +
  theme(panel.background =element_blank(), #背景
        axis.line=element_line(),#坐标轴的线设为显示
        legend.position="none",
        plot.title = element_text(size=12,hjust=0.5))+#图例位置
  geom_jitter(width = 0.2)+#添加抖动点
  ggtitle("Boxplot") + #标题
  geom_signif(comparisons = ltd,#设置需要比较的组
              test = 'wilcox.test', ##计算方法
              y_position = ytd,#图中横线位置设置
              tip_length = tip,#横线下方的竖线设置
              size=0.8,color="black") 
ggsave(filename = 'xf_Shannon_Boxplot.pdf',plot = p,device = 'pdf',width = 9,height = 6)
ggsave(filename = 'xf_Shannon_Boxplot.png',plot = p,device = 'png',width = 9,height = 6)
#########################################################################################

###################################################################################################################
###############################################################

df$group_cl <- factor(df$group_cl,levels = c("GC","NAC","ICI"))
max = floor(max(df$Chao1)) + 0.5
###############################################################
p <- ggplot(data = df,mapping = aes(x=group_cl,y=Chao1,fill=group_cl)) +
  stat_boxplot(geom = "errorbar", width=0.1,size=0.8) +
  geom_boxplot(outlier.colour="white",size=0.8) +
  xlab("Group") +
  theme_bw() +
  scale_fill_manual(breaks = c("GC","NAC","ICI"),values = color_cl) +
  theme(panel.background =element_blank(), #背景
        axis.line=element_line(),#坐标轴的线设为显示
        legend.position="none",
        plot.title = element_text(size=12,hjust=0.5))+#图例位置
  geom_jitter(width = 0.2)+#添加抖动点
  ggtitle("Boxplot") + #标题
  geom_signif(comparisons = list(c("ICI","NAC"),c("NAC","GC"),c("ICI","GC")),#设置需要比较的组
              test = 'wilcox.test', ##计算方法
              y_position = c(100,120,80),#图中横线位置设置
              tip_length = c(c(0.03,0.03),c(0.03,0.03),c(0.03,0.03)),#横线下方的竖线设置
              size=0.8,color="black") 
ggsave(filename = 'cl_Chao1_Boxplot.pdf',plot = p,device = 'pdf',width = 9,height = 6)
ggsave(filename = 'cl_Chao1_Boxplot.png',plot = p,device = 'png',width = 9,height = 6)
#########################################################################################

df$group_xf <- factor(df$group_xf,levels = c( "GC","NAC_E","NAC_NE","ICI_E","ICI_NE"))
max = floor(max(df$Chao1)) + 0.5
td <- combn(c( "GC","NAC_E","NAC_NE","ICI_E","ICI_NE"),2)
ltd <- list(c(td[,1]),c(td[,2]),c(td[,3]),c(td[,4]),c(td[,5]),c(td[,6]),c(td[,7]),c(td[,8]),c(td[,9]),c(td[,10]))
ytd <- c(max,max+20,max+40,max+60,max+80,max+100,max+120,max+140,max+160,max+180)
tip <- c(c(0.05,0.05),c(0.05,0.05),c(0.05,0.05),c(0.05,0.05),c(0.05,0.05),c(0.05,0.05),c(0.05,0.05),c(0.05,0.05),c(0.05,0.05),c(0.05,0.05))
###############################################################
p <- ggplot(data = df,mapping = aes(x=group_xf,y=Chao1,fill=group_xf)) +
  stat_boxplot(geom = "errorbar", width=0.1,size=0.8) +
  geom_boxplot(outlier.colour="white",size=0.8) +
  xlab("Group") +
  theme_bw() +
  scale_fill_manual(breaks = c("GC","NAC_E","NAC_NE","ICI_E","ICI_NE"),values = color_xf) +
  theme(panel.background =element_blank(), #背景
        axis.line=element_line(),#坐标轴的线设为显示
        legend.position="none",
        plot.title = element_text(size=12,hjust=0.5))+#图例位置
  geom_jitter(width = 0.2)+#添加抖动点
  ggtitle("Boxplot") + #标题
  geom_signif(comparisons = ltd,#设置需要比较的组
              test = 'wilcox.test', ##计算方法
              y_position = ytd,#图中横线位置设置
              tip_length = tip,#横线下方的竖线设置
              size=0.8,color="black") 
ggsave(filename = 'xf_Chao1_Boxplot.pdf',plot = p,device = 'pdf',width = 9,height = 6)
ggsave(filename = 'xf_Chao1_Boxplot.png',plot = p,device = 'png',width = 9,height = 6)
#########################################################################################

###################################################################################################################
###############################################################

df$group_cl <- factor(df$group_cl,levels = c("GC","NAC","ICI"))
max = max(df$Simpson)
###############################################################
p <- ggplot(data = df,mapping = aes(x=group_cl,y=Simpson,fill=group_cl)) +
  stat_boxplot(geom = "errorbar", width=0.1,size=0.8) +
  geom_boxplot(outlier.colour="white",size=0.8) +
  xlab("Group") +
  scale_fill_manual(breaks = c("GC","NAC","ICI"),values = color_cl) +
  theme_bw() +
  theme(panel.background =element_blank(), #背景
        axis.line=element_line(),#坐标轴的线设为显示
        legend.position="none",
        plot.title = element_text(size=12,hjust=0.5))+#图例位置
  geom_jitter(width = 0.2)+#添加抖动点
  ggtitle("Boxplot") + #标题
  geom_signif(comparisons = list(c("ICI","NAC"),c("NAC","GC"),c("ICI","GC")),#设置需要比较的组
              test = 'wilcox.test', ##计算方法
              y_position = c(max,max+0.2,max+0.4),#图中横线位置设置
              tip_length = c(c(0.03,0.03),c(0.03,0.03),c(0.03,0.03)),#横线下方的竖线设置
              size=0.8,color="black") 
ggsave(filename = 'cl_Simpson_Boxplot.pdf',plot = p,device = 'pdf',width = 9,height = 6)
ggsave(filename = 'cl_Simpson_Boxplot.png',plot = p,device = 'png',width = 9,height = 6)
#########################################################################################

df$group_xf <- factor(df$group_xf,levels = c( "GC","NAC_E","NAC_NE","ICI_E","ICI_NE"))
max = max(df$Simpson)
td <- combn(c( "GC","NAC_E","NAC_NE","ICI_E","ICI_NE"),2)
ltd <- list(c(td[,1]),c(td[,2]),c(td[,3]),c(td[,4]),c(td[,5]),c(td[,6]),c(td[,7]),c(td[,8]),c(td[,9]),c(td[,10]))
ytd <- c(max,max+0.2,max+1.8,max+0.4,max+0.6,max+0.8,max+1,max+1.2,max+1.4,max+1.6)
tip <- c(c(0.05,0.05),c(0.05,0.05),c(0.05,0.05),c(0.05,0.05),c(0.05,0.05),c(0.05,0.05),c(0.05,0.05),c(0.05,0.05),c(0.05,0.05),c(0.05,0.05))
###############################################################
p <- ggplot(data = df,mapping = aes(x=group_xf,y=Simpson,fill=group_xf)) +
  stat_boxplot(geom = "errorbar", width=0.1,size=0.8) +
  geom_boxplot(outlier.colour="white",size=0.8) +
  xlab("Group") +
  theme_bw() +
  scale_fill_manual(breaks = c("GC","NAC_E","NAC_NE","ICI_E","ICI_NE"),values = color_xf) +
  theme(panel.background =element_blank(), #背景
        axis.line=element_line(),#坐标轴的线设为显示
        legend.position="none",
        plot.title = element_text(size=12,hjust=0.5))+#图例位置
  geom_jitter(width = 0.2)+#添加抖动点
  ggtitle("Boxplot") + #标题
  geom_signif(comparisons = ltd,#设置需要比较的组
              test = 'wilcox.test', ##计算方法
              y_position = ytd,#图中横线位置设置
              tip_length = tip,#横线下方的竖线设置
              size=0.8,color="black") 
ggsave(filename = 'xf_Simpson_Boxplot.pdf',plot = p,device = 'pdf',width = 9,height = 6)
ggsave(filename = 'xf_Simpson_Boxplot.png',plot = p,device = 'png',width = 9,height = 6)
#########################################################################################



