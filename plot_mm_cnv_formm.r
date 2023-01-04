rm(list=ls())
setwd('D:/desk/R_tmp')
library(colorRamps)
library(plotrix)
prefix1 <- 'MDC-135'
prefix2 <- 'P139'
file1 <- paste(prefix1,'.CNV.anno.xls',sep = '')
file2 <- paste(prefix2,'.CNV.anno.xls',sep = '')
df1 <- read.table(file1, sep = '\t', header = TRUE)
df1 <- df1[,c(1,2,3,5)]
df1 <- df1[grep('^[0-9]',df1$chromosome),]
df1$start <- df1$start/10000000
df1$end <- df1$end/10000000
size_l <- c()
size_r <- c()
outfile <- paste(prefix1,'_',prefix2,sep = '')

for(i in 1:length(df1$start)){
  if(as.numeric(df1$chromosome[i])==1){
    size_l <- c(size_l,df1$start[i])
    size_r <- c(size_r,df1$end[i])
  }else{
    size_l <- c(size_l,(df1$end[i]-df1$start[i]+size_l[length(size_l)]))
    size_r <- c(size_r,(df1$end[i]-df1$start[i]+size_r[length(size_r)]))
  }
}
df1$x_l <- size_l
df1$x_r <- size_r


df2 <- read.table(file2, sep = '\t', header = TRUE)
df2 <- df2[,c(1,2,3,5)]
df2 <- df2[grep('^[0-9]',df2$chromosome),]
df2$start <- df2$start/10000000
df2$end <- df2$end/10000000
size_l <- c()
size_r <- c()


for(i in 1:length(df2$start)){
  if(as.numeric(df2$chromosome[i])==1){
    size_l <- c(size_l,df2$start[i])
    size_r <- c(size_r,df2$end[i])
  }else{
    size_l <- c(size_l,(df2$end[i]-df2$start[i]+size_l[length(size_l)]))
    size_r <- c(size_r,(df2$end[i]-df2$start[i]+size_r[length(size_r)]))
  }
}
df2$x_l <- size_l
df2$x_r <- size_r

m <- max(max(df1$x_r),max(df2$x_r))

# 不同区域对应不同颜色

getcolor <- function(CNV)
{
  print(CNV)
  if(CNV==0){
    return('#0033FF')
  }else if(CNV >= 4){
    return('#990000')
  }else if(CNV == 1){
    return('#0099FF')
  }else if(CNV == 2){
    return('#FFFFFF')
  }else if(CNV == 3){
    return('#FF0000')
  }
}
pdf(file=paste(outfile,".pdf",sep=""),width = 9,height = 6)
a<-dev.cur()
png(file=paste(outfile,".png",sep=""),width = 900,height = 600)
par(mar=c(3,2,1,6))
plot(1:2,1:2,type="n",ylim=c(0,2),xlim=c(0,m),bty="n",yaxt="n",xaxt="n",xlab="Chromosome",ylab="",xaxs="i") # 打开画布
axis(4,at=(c(1:2)-0.5),labels=c(prefix1,prefix2),las=2,col = "NA", col.ticks = "NA") # Y轴标签

y_b = 0
y_t = 1
for(i in 1:dim(df1)[1]){
  x_l = df1$x_l[i]
  x_r = df1$x_r[i]
  rect(x_l,y_b,x_r,y_t,border = getcolor(df1$cn[i]),angle = 30,lwd = 0, col = getcolor(df1$cn[i]))
}
y_b = 1
y_t = 2
for(i in 1:dim(df2)[1]){
  x_l = df2$x_l[i]
  x_r = df2$x_r[i]
  rect(x_l,y_b,x_r,y_t,border = getcolor(df2$cn[i]),angle = 30,lwd = 0, col = getcolor(df2$cn[i]))
}
ll <- unique(df1$chromosome)
ll <- ll[-1]
xl <- c()
for (variable in ll) {
  x=df1[df1$chromosome==variable,][1,]$x_l
  xl <- c(xl,x)
  x=rep(x,3)
  y=0:2
  lines(x,y,type = "l",lty=2)
  
}
xl <- c(0,xl)
xl_m <- c()
for (i in 1:length(xl)) {
  xl_m <- c(xl_m,mean(c(xl[i],xl[i+1])))
}
axis(1,at=xl_m,labels=unique(df1$chromosome),las=0,col = "NA", col.ticks = "NA")
dev.copy(which=a)
dev.off()
dev.off()

rm(a)

