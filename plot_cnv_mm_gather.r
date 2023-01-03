rm(list=ls())

library(tidyr)

# library("tidyr",lib.loc="/home/guyincong/R/x86_64-unknown-linux-gnu-library/3.2")

library(ggplot2)
library(patchwork)
library(scales)

library(gridExtra)

# library(ggforce)

# library("gridExtra",lib.loc="/home/guyincong/R/x86_64-unknown-linux-gnu-library/3.2")
files_prefix <- c("LHO","MDC-135","MDC-139")
prefix <- files_prefix[1]
  f <- paste(prefix,'.CNV.anno.xls',sep = "")
  ratio <- read.delim(f,header=T,sep="\t")
  
  ratio <- ratio[,c(1,2,4,5)]
  
  ploidy <- type.convert(2)
  
  
  
  ## P1 log2 Ratio
  
  ratio <- ratio[which(ratio$chromosome != "X" & ratio$chromosome != "Y" ),]
  ratio <- ratio[grep("^N.*",ratio$chromosome,invert = T),]
  
  ratio$start <- ratio$start / (10^6)
  
  chrom = as.character(1:19) 
  
  ratio$chr_n <- factor(ratio$chromosome, levels=as.numeric(chrom))
  
  ratio$log <- ratio$log2
  
  colnames(ratio)[4] <- 'CopyNumber'
  normal <- ratio[which(ratio$CopyNumber == ploidy & ratio$CopyNumber!= -1 ),]
  
  amp <- ratio[which(ratio$CopyNumber > ploidy & ratio$CopyNumber!= -1 ),]
  
  del <- ratio[which(ratio$CopyNumber < ploidy & ratio$CopyNumber!= -1 ),]
  f2 <- paste(prefix,'.cns.xls',sep = "")
  BG <- read.delim(f2,header=T,sep="\t")
  BG <- BG[,c(1,2,5,6)]
  BG <- BG[which(BG$chromosome != "X" & BG$chromosome != "Y" ),]
  BG <- BG[grep("^N.*",BG$chromosome,invert = T),]
  BG$start <- BG$start / (10^6)
  
  
  BG$chr_n <- factor(BG$chromosome, levels=as.numeric(chrom))
  
  BG$log <- BG$log2
  
  colnames(BG)[4] <- 'CopyNumber'
  
  p1 <- ggplot() + 
    
    geom_point(data=BG, aes(x=start,y=log),color="grey" , size=0.5) +
    
    geom_point(data=normal,aes(x=start,y=log),color="#A2CD5A", size=0.5 ,alpha = 1 ) +
    
    geom_point(data=amp, aes(x=start,y=log),color="#CD2626" , size=0.5) +
    
    geom_point(data=del, aes(x=start,y=log),color="#0000CD" , size=0.5) +
    
    facet_grid(.~chr_n,scale="free_x",space="free_x",switch='x') + 
    
    theme_bw() + 
    
    theme(axis.text.x = element_blank(),axis.text.y = element_text(color = "black",size=8),axis.title = element_text(size=12),axis.ticks.x = element_blank(),panel.spacing.x = unit(0,"lines"),panel.grid =element_blank(),panel.background = element_rect(fill="white"),strip.background = element_blank(),strip.placement = "outside",strip.text.x = element_text(size=10),strip.text.y = element_text(angle = 180),legend.position = "none",plot.title = element_text(hjust = 0.5,size=10,color="black"),axis.line.y = element_line(color="black", size = 0.8)) + 
    
    labs(x="",y="",title=prefix) + 
    
    scale_x_continuous(expand=c(0,0)) + 
    
    scale_y_continuous(expand=c(0,0),breaks=pretty_breaks(n=7)) 
  

#############################################
  files_prefix <- c("LHO","MDC-135","MDC-139")
  prefix <- files_prefix[2]
  f <- paste(prefix,'.CNV.anno.xls',sep = "")
  ratio <- read.delim(f,header=T,sep="\t")
  
  ratio <- ratio[,c(1,2,4,5)]
  
  ploidy <- type.convert(2)
  
  
  
  ## P1 log2 Ratio
  
  ratio <- ratio[which(ratio$chromosome != "X" & ratio$chromosome != "Y" ),]
  ratio <- ratio[grep("^N.*",ratio$chromosome,invert = T),]
  
  ratio$start <- ratio$start / (10^6)
  
  chrom = as.character(1:19) 
  
  ratio$chr_n <- factor(ratio$chromosome, levels=as.numeric(chrom))
  
  ratio$log <- ratio$log2
  
  colnames(ratio)[4] <- 'CopyNumber'
  normal <- ratio[which(ratio$CopyNumber == ploidy & ratio$CopyNumber!= -1 ),]
  
  amp <- ratio[which(ratio$CopyNumber > ploidy & ratio$CopyNumber!= -1 ),]
  
  del <- ratio[which(ratio$CopyNumber < ploidy & ratio$CopyNumber!= -1 ),]
  f2 <- paste(prefix,'.cns.xls',sep = "")
  BG <- read.delim(f2,header=T,sep="\t")
  BG <- BG[,c(1,2,5,6)]
  BG <- BG[which(BG$chromosome != "X" & BG$chromosome != "Y" ),]
  BG <- BG[grep("^N.*",BG$chromosome,invert = T),]
  BG$start <- BG$start / (10^6)
  
  
  BG$chr_n <- factor(BG$chromosome, levels=as.numeric(chrom))
  
  BG$log <- BG$log2
  
  colnames(BG)[4] <- 'CopyNumber'
  
  p2 <- ggplot() + 
    
    geom_point(data=BG, aes(x=start,y=log),color="grey" , size=0.5) +
    
    geom_point(data=normal,aes(x=start,y=log),color="#A2CD5A", size=0.5 ,alpha = 1 ) +
    
    geom_point(data=amp, aes(x=start,y=log),color="#CD2626" , size=0.5) +
    
    geom_point(data=del, aes(x=start,y=log),color="#0000CD" , size=0.5) +
    
    facet_grid(.~chr_n,scale="free_x",space="free_x",switch='x') + 
    
    theme_bw() + 
    
    theme(axis.text.x = element_blank(),axis.text.y = element_text(color = "black",size=8),axis.title = element_text(size=12),axis.ticks.x = element_blank(),panel.spacing.x = unit(0,"lines"),panel.grid =element_blank(),panel.background = element_rect(fill="white"),strip.background = element_blank(),strip.placement = "outside",strip.text.x = element_text(size=10),strip.text.y = element_text(angle = 180),legend.position = "none",plot.title = element_text(hjust = 0.5,size=10,color="black"),axis.line.y = element_line(color="black", size = 0.8)) + 
    
    labs(x="",y="normalized copy number profile (log2)",title=prefix) + 
    
    scale_x_continuous(expand=c(0,0)) + 
    
    scale_y_continuous(expand=c(0,0),breaks=pretty_breaks(n=7)) 
  #################################
  files_prefix <- c("LHO","MDC-135","MDC-139")
  prefix <- files_prefix[3]
  f <- paste(prefix,'.CNV.anno.xls',sep = "")
  ratio <- read.delim(f,header=T,sep="\t")
  
  ratio <- ratio[,c(1,2,4,5)]
  
  ploidy <- type.convert(2)
  
  
  
  ## P1 log2 Ratio
  
  ratio <- ratio[which(ratio$chromosome != "X" & ratio$chromosome != "Y" ),]
  ratio <- ratio[grep("^N.*",ratio$chromosome,invert = T),]
  
  ratio$start <- ratio$start / (10^6)
  
  chrom = as.character(1:19) 
  
  ratio$chr_n <- factor(ratio$chromosome, levels=as.numeric(chrom))
  
  ratio$log <- ratio$log2
  
  colnames(ratio)[4] <- 'CopyNumber'
  normal <- ratio[which(ratio$CopyNumber == ploidy & ratio$CopyNumber!= -1 ),]
  
  amp <- ratio[which(ratio$CopyNumber > ploidy & ratio$CopyNumber!= -1 ),]
  
  del <- ratio[which(ratio$CopyNumber < ploidy & ratio$CopyNumber!= -1 ),]
  f2 <- paste(prefix,'.cns.xls',sep = "")
  BG <- read.delim(f2,header=T,sep="\t")
  BG <- BG[,c(1,2,5,6)]
  BG <- BG[which(BG$chromosome != "X" & BG$chromosome != "Y" ),]
  BG <- BG[grep("^N.*",BG$chromosome,invert = T),]
  BG$start <- BG$start / (10^6)
  
  
  BG$chr_n <- factor(BG$chromosome, levels=as.numeric(chrom))
  
  BG$log <- BG$log2
  
  colnames(BG)[4] <- 'CopyNumber'
  
  p3 <- ggplot() + 
    
    geom_point(data=BG, aes(x=start,y=log),color="grey" , size=0.5) +
    
    geom_point(data=normal,aes(x=start,y=log),color="#A2CD5A", size=0.5 ,alpha = 1 ) +
    
    geom_point(data=amp, aes(x=start,y=log),color="#CD2626" , size=0.5) +
    
    geom_point(data=del, aes(x=start,y=log),color="#0000CD" , size=0.5) +
    
    facet_grid(.~chr_n,scale="free_x",space="free_x",switch='x') + 
    
    theme_bw() + 
    
    theme(axis.text.x = element_blank(),axis.text.y = element_text(color = "black",size=8),axis.title = element_text(size=12),axis.ticks.x = element_blank(),panel.spacing.x = unit(0,"lines"),panel.grid =element_blank(),panel.background = element_rect(fill="white"),strip.background = element_blank(),strip.placement = "outside",strip.text.x = element_text(size=10),strip.text.y = element_text(angle = 180),legend.position = "none",plot.title = element_text(hjust = 0.5,size=10,color="black"),axis.line.y = element_line(color="black", size = 0.8)) + 
    
    labs(x="Chromosome",y="",title=prefix) + 
    
    scale_x_continuous(expand=c(0,0)) + 
    
    scale_y_continuous(expand=c(0,0),breaks=pretty_breaks(n=7)) 
  
p = p1 / p2 / p3

ggsave(filename = paste("all",'_CNV.png',sep=""),plot = p,device = 'png',width = 8, height = 6)
ggsave(filename = paste("all",'_CNV.pdf',sep=""),plot = p,device = 'pdf',width = 8, height = 6)





