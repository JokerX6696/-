rm(list=ls())
setwd('D:/desk/R_temp/temp2/kruskal_wallis')
# ycliu 2017.03.07
library(ggplot2)
library(ggpubr)
library(ggsignif)
files <- dir(pattern = '*txt')
for(file_name in files){
  #file_name <- 'diff_class_top10_boxplot.xls'
  TYPE <- sub("_top.+","",file_name)
  TYPE <- sub("diff_","",TYPE)
  #out <- 'diff_class_top10_boxplot.pdf'
  
  newname<-gsub(".txt","",file_name)
  newname<-gsub(".xls","",newname)
  newname<-gsub(".*/","",newname)
  a<-read.table(file_name,sep="\t",header=T)
  a['axis']<-paste('P',format(a$P,digits=3,scientific=T),sep='=')
  nu = length(unique(a$id))
  group = length(unique(a$Group))
  
  if (nu>5){
    m=nu*group*0.5
  }else if (nu>1 & group>4){
    m=nu*group*0.5
  }else{
    m=7
  }
  
  a$P<-as.factor(a$P) 
  fa<- unique(a$Group)
  a$Group<-factor(a$Group,levels=fa)
  
  b <- a
  for(i in 1:nu){
    
    a <- b[b$id == unique(b$id)[i],]
    species <- unique(b$id)[i]
    p <- ggplot(data=a, aes(x=Group,y=Abundance))+
      geom_boxplot(aes(fill=Group),outlier.size = 0,show.legend = F)+
      geom_jitter() +
      scale_fill_manual(breaks = fa,values = c('#E41A1C','#377EB8')) +
      labs(title=unique(a$id),x='',y="Abundance")+
      #geom_signif(comparisons = list(fa), test = t.test, step_increase = 0.2,label = "p.signif") +  # t.test 显著性数值
      stat_compare_means(label = "p.signif",label.x = 1.5) +
      theme_bw()+
      theme(axis.text.x = element_text(size=12,angle = 0,face = "bold",vjust=0),
            strip.text.x = element_text(colour = "black", angle = 90, size = 8,hjust = 0.5, vjust = 0.4),
            strip.background = element_rect(colour = "white", fill = "white"),
            plot.title = element_text(hjust = 0.5))
    ggsave(filename = paste('diff',TYPE,species,'top30_boxplot.png',sep = '_'),plot = p,device = 'png',width = 9,height = 6)
    ggsave(filename = paste('diff',TYPE,species,'top30_boxplot.pdf',sep = '_'),plot = p,device = 'pdf',width = 9,height = 6)
  }
  
}

