# 绘制 SNP 密度图
rm(list=ls())
library(ggplot2)
library(reshape2)
setwd('D:/desk/make_Script')
chr_size <- read.table('genome.fa.sizes.chrom')
chr_size <- data.frame(chr=chr_size$V1, start=rep(0, dim(chr_size)[1]), end=chr_size$V2)

#snp <- read.table('snp.annotation.xls',header = T,sep = '\t')
df <- read.table('snp.annotation.xls',header = T,sep = '\t')
Before <- which(colnames(df) == "Func.refGene")
df <- df[,c(1,2,6:(Before-1))]
#### 函数封装
getColor <- function(j){
  if(j < lev[2] ){
    return(color[1])
  }else if(j < lev[3] ){
    return(color[2])
  }else if(j < lev[4] ){
    return(color[3])
  }else if(j < lev[5] ){
    return(color[4])
  }else if(j < lev[6] ){
    return(color[5])
  }else if(j < lev[7] ){
    return(color[6])
  }else if(j < lev[8] ){
    return(color[7])
  }else if(j < lev[9] ){
    return(color[8])
  }else if(j < lev[10] ){
    return(color[9])
  }else if(j <= lev[11] ){
    return(color[10])
  }else{
    return(color[11])
  }
  
}

################################# 参数集合
iden <- 1000000
len = 15
TYPE = 'SNP'
Main = paste("The number of ",TYPE," within ",iden/1000000,"Mb window size",sep = '')


###############################################################################
if(0){
  for(sample_col in 4:length(df)){
    data <- df[grep("(\\./\\.|0/0)",df[,sample_col],invert = T),]  #  删除所有 0/0 ./. 的数据
    name <- sub("\\.","-",colnames(df)[sample_col])
    data <- data.frame(data[,1:3],data[sample_col])
    colnames(data)[4] <- colnames(df[sample_col])
    Main <- paste("The number of ",TYPE," within 1 Mb window size",sep = "")
    sample <- sub("\\.",'_',colnames(data)[4])
    outfile = paste(output,"/",TYPE,"_Density_",sample,sep="")
  }
}



#####################################################  统计每个样本密度
for (col in 3:6) {
  name <- colnames(df)[col]
  data <- df[grep("(\\./\\.|0/0)",df[,col],invert = T),]  #  删除所有 0/0 ./. 的数据
  col1 <- c()
  col2 <- c()
  col3 <- c()
  col4 <- c()
  # 每条染色体循环统计一次
  for(i in 1:dim(chr_size)[1]){
    l <- chr_size[i,]
    chr <- l[[1]]
    pos <- l[[3]]
    left <- 0
    right <- iden
    b = FALSE
    
    while(1){
      if(right >= pos){right = pos;b=TRUE}
      num <- dim(data[data$chromosome == chr & data$position >= left & data$position < right,])[1]
      col1 <- c(col1,chr)
      col2 <- c(col2,left)
      col3 <- c(col3,right)
      col4 <- c(col4,num)
      if(b){break}
      left <- left + iden
      right <- right + iden
    }
    
    
  }
  #绘图矩阵处理
  df_temp <- data.frame(chr=col1, start=col2, end=col3, num=col4)
  df_temp$end <- df_temp$end/1000000
  df_temp$start <- df_temp$start/1000000
  
  #df_temp <- df_temp[,-3]
  
  
  
  df_temp$chr <- factor(df_temp$chr,levels = rev(unique(df_temp$chr)))
  df_temp$chr_num <- as.numeric(sub(df_temp$chr,pattern = "chr",replacement = ''))
  ###################################################################################
  lev <- c(0,ceiling(seq(min(df_temp$num),max(df_temp$num),length.out = 10)))
  
  #ld = c('0-46','47-245','246-445','446-642','643-840','841-1039','1040-1237','1238-1436','1437-1634','>1635')
  ld = c()
  for (variable in 1:(length(lev)-1)) {
    ld <- c(ld, paste(lev[variable],'-',lev[variable+1]-1,sep=''))
  }
  ld[length(ld)] <- paste('>',lev[length(lev)-1],sep = '')
  color <- c('white','#BFAED4','#A6D854','#66C2A5','#8DA0CB','#984EA3','#FDBF6F','#FF7F00','#E78AC3','#AD002AFF')
  
  ######################################################################################
  
  
  
  
  ######################################################
  
  png(file=paste(name,'_',TYPE,".png",sep=""),width = 900,height = 600)
  par(mar=c(4,4,2,2))
  plot(1:len,1:len,type="n",ylim=c(0,len),xlim=c(0,26),bty="n",yaxt="n",xaxt="n",xlab="",ylab="",xaxs="i") # 打开画布
  axis(4,at=(c(1:len)-0.5),labels=rev(unique(df_temp$chr)),las=2,col = "NA", col.ticks = "NA",side = 2) # Y轴标签
  # 画密度方块
  for(i in 1:dim(df_temp)[1]){
    y_t <- 15 - (df_temp$chr_num[i] - 0.2) 
    y_b <- 15 - (df_temp$chr_num[i] - 0.8) 
    x_l <- df_temp$start[i]
    x_r <- df_temp$end[i]
    col_j <- df_temp$num[i]
    rect(x_l,y_b,x_r,y_t,border = getColor(col_j),angle = 30,lwd = 0, col = getColor(col_j)) # 矩形绘制
  }
  # 添加标题
  title(main = Main, xlab = "Chromosom Mb")
  # 添加坐标
  axis(side = 1,at = 0:23,tick = TRUE,labels = TRUE,font = 1)
  # 添加图例
  
  legend('bottomright',fill = color,legend = ld,bty='n')
  
  
  dev.off()
  
}
