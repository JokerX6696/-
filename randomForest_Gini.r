rm(list=ls())
library('randomForest')
setwd('D:\\desk\\何胜夫售后2\\20230313_DOE202213632-b2_何胜夫-孙雅婷-73个人2bRAD-M项目_第一次个性化结果\\PA\\item7')
file <- "L7.others_Top30_species.xls"

args <- commandArgs(T)
library(ggplot2)
set.seed(1311)
abundance<-read.table(file,sep="\t",header=T,row.names=1)
abundance<-t(abundance)
abundance<-data.frame(abundance)

### mapping must include no # 
g <- 'mapping.txt'
mapping<-read.table(g,sep="\t",header=T,row.names=1,comment.char="")
group<-mapping$Group
group<-data.frame(group)
data<-cbind(group,abundance)

output.forest <- randomForest(as.factor(group) ~ ., importance = TRUE,data = data)
#output.forest <- randomForest(group ~ ., 
#data = data,ntree=1000,nodesize=50)
#varImpPlot(output.forest)
#rank_gini<-importance(output.forest,type = 2)  # MeanDecreaseGini
#rank_Accuracy<-importance(output.forest,type = 1)  # MeanDecreaseAccuracy
rank<-importance(output.forest,,type = 2) # MeanDecreaseGini
rank<-data.frame(rank)
rowname<-rownames(rank)
rank<-rank[order(-rank$MeanDecreaseGini),]
rank<-data.frame(rank)
rownames(rank)<-rowname
colnames(rank)<-c("MeanDecreaseGini")

### 
rowname<-factor(rowname, levels=rowname[order(rank$MeanDecreaseGini)])
write.table(rank,"importance_Gini.xls",sep="\t",quote=F)
#write.table(output.forest$err.rate,"Error_Rate.xls",sep="\t",quote=F)
write.table(output.forest$confusion,"confusion.xls",sep="\t",quote=F)
# output.forest$err.rate
# output.forest$confusion
# output.forest$votes
#pdf("RandomForest.pdf",width = 15,height = 8)
#ggplot(data = rank, aes(MeanDecreaseAccuracy,rowname,colour=rownames(rank)),size=8) + geom_point()+labs(y="species")+theme(legend.title=element_blank())+guides(col = guide_legend(nrow = 25))
#dev.off()


#############################################################
#  添加气泡图
##############################################################

#rm(list=ls())
#setwd('D:/desk/何胜夫售后/20230224_DOE202213632-b2_何胜夫-孙雅婷-73个人2bRAD-M项目_结题报告/PA/item7')
library(ggplot2)
library(reshape2)

ab <- read.table(file = 'L7.others_Top30_species_group.xls',sep = '\t',header = TRUE)

file <- 'indicators_indicator_value.xls'
df <- read.table(file = file,sep = '\t',header = TRUE)
df <- df[,1:3]
df <- melt(df,variable.name = 'OTUId')
colnames(df) <- c('type','group','indval')
p <- ggplot() + 
  geom_point(data = df,mapping = aes(x = factor(group,levels = c('S_GC','S_Control')),y=type,color=group,size=indval)) + 
  labs(x="",y="") + 
  scale_color_manual(breaks=c('S_GC','S_Control'),values = c('#6EC5EA','#E7AC48')) +
  ggtitle('indicator analysis') +
  theme_bw() + 
  theme(
    text=element_text(size=16,  family="serif"),
    plot.title = element_text(hjust = 0.5),
    line=element_line(linetype = 2)
  )
ggsave(filename = 'indicator.png',plot = p,device = 'png',width = 9,height = 6)
ggsave(filename = 'indicator.pdf',plot = p,device = 'pdf',width = 9,height = 6)
#          dev.off()

#########################################################################
file <- 'importance.xls'
df <- read.table(file = file,sep = '\t',header = TRUE)
df$type <- rownames(df)
colnames(df)[1] <- 'Abundance' # 不代表丰度 随机取了个名

df <- merge(df,ab,by.x = 'type',by.y = 'Taxonomy',all = TRUE)

df <- df[rev(order(df$Abundance)),]
df$type <- factor(df$type,levels = rev(df$type))

p <- ggplot() + 
  geom_point(data = df,mapping = aes(x = Abundance,y=type,size=S_GC,color = S_Control)) + 
  labs(x="",y="",color="Abundance",size="Abundance") + 
  scale_color_gradient(low = "#00468BFF",high = "#AD002AFF") +
  ggtitle('Random forest-Accuracy') +
  theme_bw() + 
  #scale_color_discrete(name="Experimental") +
  theme(
    text=element_text(size=16,  family="serif"),
    plot.title = element_text(hjust = 0.5),
    line=element_line(linetype = 2)
  )
ggsave(filename = 'Random_forest_Accuracy.png',plot = p,device = 'png',width = 9,height = 6)
ggsave(filename = 'Random_forest_Accuracy.pdf',plot = p,device = 'pdf',width = 9,height = 6)
#########################################################################
file <- 'importance_Gini.xls'
df <- read.table(file = file,sep = '\t',header = TRUE)
df$type <- rownames(df)
colnames(df)[1] <- 'Abundance'
df <- merge(df,ab,by.x = 'type',by.y = 'Taxonomy',all = TRUE)

df <- df[rev(order(df$Abundance)),]
df$type <- factor(df$type,levels = rev(df$type))
p <- ggplot() + 
  geom_point(data = df,mapping = aes(x = Abundance,y=type,size=S_GC,color = S_Control)) + 
  labs(x="",y="",color="Abundance",size="Abundance") + 
  scale_color_gradient(low = "#00468BFF",high = "#AD002AFF") +
  ggtitle('Random forest-Gini') +
  theme_bw() + 
  theme(
    text=element_text(size=16,  family="serif"),
    plot.title = element_text(hjust = 0.5),
    line=element_line(linetype = 2)
  )
ggsave(filename = 'Random_forest_Gini.png',plot = p,device = 'png',width = 9,height = 6)
ggsave(filename = 'Random_forest_Gini.pdf',plot = p,device = 'pdf',width = 9,height = 6)




