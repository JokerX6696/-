#!/public/store5/DNA/Test/zhengfuxing/conda/bin/Rscript
# conda activate /public/store5/DNA/Test/zhengfuxing/conda
rm(list=ls())
.libPaths(c("/public/store5/DNA/Test/zhengfuxing/conda/lib/R/library","/data/software/R_package/DNA/3.5"))
# 传参
library(optparse)

option_list <- list(
  make_option(c("-d","--dir"),type="character",help="输入文件所在目录：GWAS 位点显著性统计所在目录，非 filter！"),
  make_option(c("-g","--genome_sizes"),type="character",help="参考基因组对应的 genome.fa.sizes.chrom ！"),
  make_option(c("-t","--threshold"),type="double",default=8,help="显著性阈值 取 log10(t)"),
  make_option(c("-b","--backColor"),type="character", default="#CCCCCC",help="背景染色体颜色，默认灰色，支持16进制颜色"),
  make_option(c("-s","--snpColor"),type="character", default="black", help="显著性位点颜色，默认黑色，支持16进制颜色"),
  make_option(c("-o","--output"),type="character", default="./",help="文件是输出路径"),
  make_option(c("-p","--phenotype_sort"),type="character", default="nosort",help="表型展示顺序排序，从上向下排序 使用逗号分隔，eg: high,weight")

)

opt <- parse_args(OptionParser(option_list=option_list))







# 脚本参数赋值
threshold = 10**-(opt$t)  #  阈值
out = opt$o
wkdir = opt$d  #  表型显著性结果所在目录

genome_fa_sizes_chrom = opt$g  #  基因组对应 genome.fa.sizes.chrom 路径
outfile <- paste(out,'/','Significant','_snp_plot',sep = "")
#bkcolor <- "#CCCCCC" 默认
bkcolor <- opt$b
snpcolor <- opt$s
Sort <-  opt$p
##################################################################
# 参数处理
# 为防止目录输入错误
if(grepl("/$",wkdir)){
  print('处理文件时间较长，请等待......')
}else if(grepl("\\\\$",wkdir)){
  print('处理文件时间较长，请等待......')
}else{
  print('处理文件时间较长，请等待......')
  wkdir <- paste(wkdir,'/',sep = '')
}
# 手动排序表型文件
# 如果不指定表型顺序
if(Sort == 'nosort'){
  files <- dir(wkdir,pattern = "*xls")
}else{  # 如果指定表型顺序
  temp <- strsplit(Sort,',')[[1]]
  files = c()
  for(i in temp)
    files = c(files,paste(i,"_GWAS.anno.xls",sep = ''))
}


##################################################################

phenotype = c()
for(i in files){a=sub("_GWAS.anno.xls","",i);phenotype = append(phenotype,a)}

len <- length(phenotype)


# 处理背景
ref <- read.table(genome_fa_sizes_chrom)
colnames(ref) <- c('chr', 'size')
ref$size <- ref$size/10000000

size2 <- c()
counts <- 0
space <- 0.2

for(i in ref$size){
  if(counts==0){
    size2 <- c(size2,i)
  }else{
    size2 <- c(size2,(i+space+size2[length(size2)]))
  }
  counts = counts + 1
}

size3 <- c(0,(size2[1:(length(size2)-1)]+space))
ref$xl <- size3
ref$xr <- size2




# 确定 X 轴 最大坐标
mx = ceiling(max(ref$xr))

########################################
#画背景

pdf(file=paste(outfile,".pdf",sep=""),width = 9,height = 6)
a<-dev.cur()
png(file=paste(outfile,".png",sep=""),width = 900,height = 600)
dev.control("enable")
par(mar=c(1,2,1,6))
plot(1:len,1:len,type="n",ylim=c(0,len+1),xlim=c(0,mx),bty="n",yaxt="n",xaxt="n",xlab="Chromosome",ylab="",xaxs="i") # 打开画布
axis(4,at=(c(1:len)-0.5),labels=rev(phenotype),las=2,col = "NA", col.ticks = "NA") # Y轴标签
# 开始处理文件
for(k in (1:length(phenotype))){
  y_b <- k-0.8
  y_t <- k-0.2
  #画背景
  for(j in (1:dim(ref)[1])){
    x_l <- ref$xl[j]
    x_r <- ref$xr[j]
    rect(x_l,y_b,x_r,y_t,border = bkcolor,angle = 30,lwd = 0, col = bkcolor) # 矩形绘制
  }

  # 处理显著位点
  file <- paste(wkdir,rev(files)[k],sep = '')
  print(file)
  df <- read.table(file,header = T);
  df <- df[,c(1,2,5)]
  df <- df[df$P.value<threshold, ]
  df$POS <- df$POS/10000000


  pxl <- c()
  pxr <- c()
  for(l in 1:dim(df)[1]){
    pos <- ref[ref$chr==df[l,1],3] + df[l,2]
    pxl <- c(pxl,pos)
    pxr <- c(pxr,pos+0.01)
  }
  if(dim(df)[1]!=0){
    df$pxl <- pxl
    df$pxr <- pxr
  }

  # 画显著的位点
  if(dim(df)[1]!=0){
    for(j in (1:dim(df)[1])){
      x_l <- df$pxl[j]
      x_r <- df$pxr[j]

      lines(x=c(x_l,x_l),y=c(y_b,y_t),col = snpcolor) # 显著位点绘制
    }
  }

}
dev.copy(which=a)
dev.off()
dev.off()
rm(a)
