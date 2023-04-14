rm(list=ls())
library('randomForest')
setwd('D:/desk/R_temp')
file <- "L7.others_Top30_species.xls"

library(ggplot2)

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
pdf("RandomForest.pdf",width = 15,height = 8)
ggplot(data = rank, aes(MeanDecreaseAccuracy,rowname,colour=rownames(rank)),size=8) + geom_point()+labs(y="species")+theme(legend.title=element_blank())+guides(col = guide_legend(nrow = 25))
dev.off()
