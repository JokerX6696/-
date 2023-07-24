rm(list=ls())
setwd('D:/desk/temp')
# para
point_size = 2
prefix = paste0('./','jiyu')

# 防止标签重叠,自定义处理函数
ADjust <- function(tl){
  counts = 0
  for (i in order(tl$x)) {
    counts = counts + 1
    if(counts == 1){last_i = i;next}
    if(tl$x[i] - tl$x[last_i]< 0.2){
      tl$x[i] = tl$x[i] + (0.2 - (tl$x[i] - tl$x[last_i]))
    }
    last_i = i
  }
  
  counts = 0
  for (i in order(tl$y)) {
    counts = counts + 1
    if(counts == 1){last_i = i;next}
    if(tl$y[i] - tl$y[last_i]< 0.2){
      tl$y[i] = tl$y[i] + (0.2 - (tl$y[i] - tl$y[last_i]))
    }
    last_i = i
  }
  tl$x <- tl$x -0.1
  tl$y <- tl$y -0.1
  return(tl)
}





library(ggplot2)
library(ggsci)
library(scatterplot3d)
library(ggrepel)

# data load
pcas <- read.table('plink.PCA.evec',header = F)
spind <- read.table('pca.ind',header=F,sep="\t")
pcn <- paste("PC",seq(1:8),sep="")
colnames(pcas) <- c("ID",pcn,"sp")
pcas$sp <- spind$V6
pop <- length(levels(pcas$sp))

# egi percent
egivals <- read.table('plink.PCA.evec',nrows = 1,header = F,comment.char = "")
egivals <- egivals[2:9]
pc <- c()

for (i in 2:9)
{
  j <- i-1
  pc[j] <- round(egivals[j]/(length(pcas$sp)-1),4)*100
}
pcas$ID <- NULL

# 2D PCA
t2d <- combn(4,2)
pal <- c('#00468BFF','#ED0000FF','#42B540FF','#0099B4FF','#925E9FFF','#FDAF91FF','#AD002AFF','#ADB6B6FF')#pal_locuszoom()(8)

for (i in 1:6)
{
  x <- t2d[,i][1]
  y <- t2d[,i][2]
  data <- data.frame("PC1"=pcas[,x],"PC2"=pcas[,y],"sp"=pcas$sp)
  ggplot(data)+
    geom_point(aes(x=PC1,y=PC2,color=sp),alpha=1,size=point_size)+
    theme_bw(base_family="Helvetica") +
    theme(
      axis.text.x = element_text(color = "black",size=12),
      axis.text.y = element_text(color = "black",size=12),
      axis.title = element_text(color = "black",size=14),
      panel.border = element_rect(size=1),
      panel.grid =element_blank(),
      legend.title=element_blank(),
      legend.text = element_text(size=12),
      #legend.position=c(0.8,0.2),
      legend.background = element_rect(),
      plot.title = element_text(hjust = 0.5,size=16),
      panel.background = element_rect(fill="white"))+
    labs(x=paste("PC",x," (",pc[x],"%)",sep=""),y=paste("PC",y," (",pc[y],"%)",sep=""),title="")+
    scale_color_manual(values = pal) + 
    geom_text_repel(aes(x = data[,1],y=data[,2],label = data$sp), box.padding = 0.5, force = 0.5,geom = "text",segment.colour = NA)

  ggsave(paste(prefix,".pca",x,"_",y,".pdf",sep=""),height =9 ,width=12)
  ggsave(paste(prefix,".pca",x,"_",y,".png",sep=""),dpi=300,height =9 ,width=12)
}

# 3D PCA
t3d <- combn(4,3)

for (i in 1:4)
{

  x <- t3d[,i][1]
  y <- t3d[,i][2]
  z <- t3d[,i][3]
  pdf(paste(prefix,".3DPCA_",x,y,z,".pdf",sep=""),height =9 ,width=12)
  subpca <- data.frame("PC1"=pcas[,x],"PC2"=pcas[,y],"PC3"=pcas[,z],"sp"=pcas$sp)
  colors <- pal
  colors <- pal[1:length(subpca$sp)]
  layout(matrix(1:2,1,2),width=c(7,2))
  par(mar=c(5,2,5,2),family='sans')
  s3d <- scatterplot3d(subpca$PC1,subpca$PC2,subpca$PC3,pch=16,color = colors,angle=25,
                       xlab = paste("PC",x," (",pc[x],"%)",sep=""),
                       ylab = paste("PC",y," (",pc[y],"%)",sep=""),
                       zlab = paste("PC",z," (",pc[z],"%)",sep="")
                       )
  text(ADjust(s3d$xyz.convert(subpca[,1:3])),labels = subpca$sp,cex= 0.7)
  par(mar=c(0.5,0.5,0.5,0.3),family='sans')
  plot.new()
  legend("center",s3d$xyz.convert(2,0.5,2),xjust=-1,yjust=-1,legend = factor(subpca$sp),
         col =  pal, pch = 16)
  
  dev.off()
  png(paste(prefix,".3DPCA_",x,y,z,".png",sep=""),res=300,height =1800 ,width=3000)
  subpca <- data.frame("PC1"=pcas[,x],"PC2"=pcas[,y],"PC3"=pcas[,z],"sp"=pcas$sp)
  colors <- pal
  colors <- pal[1:length(subpca$sp)]
  layout(matrix(1:2,1,2),width=c(7,2))
  par(mar=c(5,2,5,2),family='sans')
  s3d <- scatterplot3d(subpca$PC1,subpca$PC2,subpca$PC3,pch=16,color = colors,angle=25,
                       xlab = paste("PC",x," (",pc[x],"%)",sep=""),
                       ylab = paste("PC",y," (",pc[y],"%)",sep=""),
                       zlab = paste("PC",z," (",pc[z],"%)",sep=""))
  text(ADjust(s3d$xyz.convert(subpca[,1:3])),labels = subpca$sp,cex= 0.7)
  par(mar=c(0.5,0.5,0.5,0.3),family='sans')
  plot.new()
  legend("center",s3d$xyz.convert(2,0.5,2),xjust=-1,yjust=-1,legend = factor(subpca$sp),
         col =  pal, pch = 16)
  dev.off()
}


