rm(list=ls())
library(ggplot2)
library(ggsci)
library(reshape2)
setwd('D:/desk/R_tmp')

sample <- c('MDC-135','MDC-139','P135','P139')
OutName <- paste('MDC-135','MDC-139','P135','P139',sep = '_')
file <- 'snp.gene.muttype.xls'
df <- read.table(file,sep = '\t',header = F)
df <- df[c(-12,-13,-9,-10,-16),]
for(i in 5:8){
  df$V1[i] <- paste(df$V1[i],df$V2[i],sep = '_')
}
df <- df[,-2]
df <- data.frame(t(df))
colnames(df) <- df[1,]
rownames(df) <- df$region
df <- df[-1,]
df <- df[sample,]

COL <- c("#F4BA6A","#BB1F20","#004A88","#95006D","#F8E700","#7DBD00","#C88700","#038D57","#CB958F","#0089B5","#491B56","#007C8B")

df_2 <- melt(data = df,id.vars = 'region',measure.vars = c(colnames(df)[2:length(df)]))
colnames(df_2) <- c('sample','type','num')

p <- ggplot(data = df_2,mapping = aes(x=sample,y=as.numeric(num),fill=type)) +
  geom_bar(stat="identity",width = .5,position='fill') +
  labs(x="",y="",fill="Type") +
  scale_y_continuous(expand = c(0, 0)) +
  scale_fill_manual(breaks = unique(df_2$type),values = COL) +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 0,vjust = 0.5,hjust = 0.5) )
ggsave(paste(OutName,"pdf",sep="."),p,height=16*0.618,width=20,dpi=300,units = "cm")

ggsave(paste(OutName,"png",sep="."),p,height=16*0.618,width=20,dpi=300,units = "cm")

