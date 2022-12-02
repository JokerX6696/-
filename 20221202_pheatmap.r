rm(list=ls())
setwd('D:/desk/R_tmp')
library(pheatmap)

df <- read.table('feral.txt',header = T,sep = "\t")
rownames(df) <- df$SampleID
df[,c(1,2)] <- df[,c(4,5)]
df <- df[,-c(4,5)]
colnames(df)[c(1,2)] <- c("longitude", "latitude")
colnames(df)[c(4:22)] <- c("bio1","bio2","bio3","bio4","bio5","bio6","bio7","bio8","bio9","bio10","bio11","bio12","bio13","bio14","bio15","bio16","bio17","bio18","bio19")
df <- na.omit(df)
df <- t(df)
pdf('heatmap_feral.pdf',width = 9,height = 6)
pheatmap(df,scale = "row",color = colorRampPalette(c("navy", "white", "firebrick3"))(50),show_colnames=F,border=FALSE)
dev.off()

png('heatmap_feral.png',width = 900,height = 600)
pheatmap(df,scale = "row",color = colorRampPalette(c("navy", "white", "firebrick3"))(50),show_colnames=F,border=FALSE)
dev.off()

df <- read.table('wild.txt',header = T,sep = "\t")
rownames(df) <- df$SampleID
df[,c(1,2)] <- df[,c(4,5)]
df <- df[,-c(4,5)]
colnames(df)[c(1,2)] <- c("longitude", "latitude")
colnames(df)[c(4:22)] <- c("bio1","bio2","bio3","bio4","bio5","bio6","bio7","bio8","bio9","bio10","bio11","bio12","bio13","bio14","bio15","bio16","bio17","bio18","bio19")
df <- na.omit(df)
df <- t(df)
pdf('heatmap_wild.pdf',width = 9,height = 6)
pheatmap(df,scale = "row",color = colorRampPalette(c("navy", "white", "firebrick3"))(50),show_colnames=F,border=FALSE)
dev.off()

png('heatmap_wild.png',width = 900,height = 600)
pheatmap(df,scale = "row",color = colorRampPalette(c("navy", "white", "firebrick3"))(50),show_colnames=F,border=FALSE)
dev.off()

