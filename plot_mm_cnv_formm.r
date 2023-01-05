rm(list=ls())
setwd('D:/desk/R_tmp')
library(colorRamps)
library(plotrix)
prefix1 <- 'MDC-139'
prefix2 <- 'P139'
file1 <- paste(prefix1,'.CNV.anno.xls',sep = '')
file2 <- paste(prefix2,'.CNV.anno.xls',sep = '')
df1 <- read.table(file1, sep = '\t', header = TRUE)
df1 <- df1[,c(1,2,3,5)]
df1 <- df1[grep('^[0-9]',df1$chromosome),]

size_l <- c()
size_r <- c()
outfile <- paste(prefix1,'_',prefix2,sep = '')

ref <- read.table('genome.fa.sizes.chrom',sep = '\t',nrows = 19)
colnames(ref) <- c('chr','len')
rl <- c()
for(i in 1:19){
  rl <- c(rl,sum(ref$len[1:i]))
}
rl <- c(0,rl)
for(i in 1:length(df1$start)){
  chr <- as.numeric(df1$chromosome[i])
  templ <- df1$start[i] + rl[chr]
  tempr <- df1$end[i] + rl[chr]
  size_l <- c(size_l,templ)
  size_r <- c(size_r,tempr)
}
df1$start <- size_l
df1$end <- size_r
df1$start <- df1$start/10000000
df1$end <- df1$end/10000000
colnames(df1)[2:3] <- c('x_l','x_r')



df2 <- read.table(file2, sep = '\t', header = TRUE)
df2 <- df2[,c(1,2,3,5)]
df2 <- df2[grep('^[0-9]',df2$chromosome),]
size_l <- c()
size_r <- c()
for(i in 1:19){
  rl <- c(rl,sum(ref$len[1:i]))
}
rl <- c(0,rl)
for(i in 1:length(df2$start)){
  chr <- as.numeric(df2$chromosome[i])
  templ <- df2$start[i] + rl[chr]
  tempr <- df2$end[i] + rl[chr]
  size_l <- c(size_l,templ)
  size_r <- c(size_r,tempr)
}
df2$start <- size_l
df2$end <- size_r
df2$start <- df2$start/10000000
df2$end <- df2$end/10000000
colnames(df2)[2:3] <- c('x_l','x_r')

m <- rl[20]/10000000

# 不同区域对应不同颜色

getcolor <- function(CNV)
{
  print(CNV)
  if(CNV==0){
    return('#00468BFF')
  }else if(CNV == 1){
    return('#80B1D3')
  }else if(CNV == 2){
    return('#FFFFFF')
  }else if(CNV == 3){
    return('#FDAF91FF')
  }else if(CNV >= 4){
    return('#AD002AFF')
  }
}
pdf(file=paste(outfile,".pdf",sep=""),width = 9,height = 6)
a<-dev.cur()
png(file=paste(outfile,".png",sep=""),width = 900,height = 600)
par(mar=c(2,6,1,2))
plot(1:2,1:2,type="n",ylim=c(0,2),xlim=c(0,m),bty="n",yaxt="n",xaxt="n",xlab="Chromosome",ylab="",xaxs="i") # 打开画布
axis(2,at=(c(1:2)-0.5),labels=c(prefix1,prefix2),las=2,col = "NA", col.ticks = "NA") # Y轴标签

y_b = 0
y_t = 0.9
for(i in 1:dim(df1)[1]){
  x_l = df1$x_l[i]
  x_r = df1$x_r[i]
  rect(x_l,y_b,x_r,y_t,border = getcolor(df1$cn[i]),angle = 30,lwd = 0, col = getcolor(df1$cn[i]))
}
y_b = 1.1
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
  x=rep(x,2)
  y=c(0,0.9)
  lines(x,y,type = "l",lty=2)
  y=c(1.1,2)
  lines(x,y,type = "l",lty=2)
}
xl <- c(0,xl)
xl_m <- c()
for (i in 1:length(xl)) {
  xl_m <- c(xl_m,mean(c(xl[i],xl[i+1])))
}
xl_m[length(xl_m)] <- (xl[length(xl)] + m)/2
xl_m[16:length(xl_m)] <- xl_m[16:length(xl_m)]+1
xl_m[length(xl_m)] <- m
axis(1,at=xl_m,labels=unique(df1$chromosome),las=0,col = "NA", col.ticks = "NA",tick = TRUE,line=-2)
# 添加图例
par(mai=c(2,0.5,0.5,0.5))
legend(m/5,-0.05, 
       legend = c('Copynum:0','Copynum:1','Copynum:2','Copynum:3','Copynum:4'),
       xpd=TRUE,
       ncol=5,
       fill=c(getcolor(0),getcolor(1),getcolor(2),getcolor(3),getcolor(4)),
       bty='n',
       x.intersp=1
)

dev.copy(which=a)
dev.off()
dev.off()

rm(a)

