# 传参
library(optparse)

option_list <- list(
  make_option(c("-i","--input_dir"),type="character",help="06.somatic_CNV 目录：推荐使用绝对路径,使用相对路径请确认setwd()是否正确"),
  make_option(c("-g","--genome_sizes"),type="character",help="参考基因组对应的 genome.fa.sizes.chrom ！"),
  make_option(c("-o","--output"),type="character",default='./somatic_CNV_heatmap.pdf',help="输出 pdf 文件名,默认输出到当前路径下")

)

opt <- parse_args(OptionParser(option_list=option_list))

library(plotrix)
library(colorRamps)
## 参数设置

input_dir = opt$i
info_file <- opt$g
output<- opt$o
###自定义函数处理数据
get_df <- function(path){
  col_save <- c("chromosome", "start", "end", "cn")
  files <- list.files(path, full.names = TRUE, recursive = TRUE)
  files <- files[grepl(pattern = "CNV\\.xls$",perl = TRUE,x = files)]
  for (q in files) {
    df_temp <- read.table(file = q, sep = '\t', quote = "",header = TRUE)
    df_temp <- df_temp[,col_save]
    name_temp <- gsub('.+/','',q)
    name_temp <- gsub('.somatic_CNV.xls','',name_temp)
    name_temp <- gsub('\\.CNV.xls','',name_temp)
    df_temp$sample <- name_temp
    if(q == files[1]){
      df <- df_temp
    }else{
      df <- rbind(df,df_temp)
    }
  }
  df <- df[df$cn != 2,]
  df[df$cn > 4,4] <- 4
  df <- data.frame(
    chr=df$chromosome,
    sample=df$sample,
    start=df$start,
    end=df$end,
    CN=df$cn
  )

  return(df)
}

### 矩阵读取
pre_info <- read.delim(info_file,header=F,sep="\t")
df <- get_df(input_dir)
## 将 genome.fa.sizes.chrom 处理成 plussize
count = 0
counts <- c()
for (i in pre_info[,2]) {
  counts <- c(counts, count)
  count = count + i
}
info <- data.frame(pre_info,counts)
info <- info[!grepl("[A-Za-z]",info[,1]),]  #  这里要求所有的常染色体 都必须是数字!
########################################################

dat <- c()
for(line in 1:nrow(df)) {
  col_chr = df[line,1]
  col_sample = df[line,2]
  pre_distance = info[which(info[,1]==col_chr),3]
  col_start = pre_distance + df[line,3]
  col_end = pre_distance + df[line,4]
  col_CN = df[line,5]
  new_line = data.frame(sample=col_sample,start=col_start,end=col_end,CN=col_CN)
  dat <- rbind(dat,new_line)
}



my_palette <- t(col2rgb(colorRampPalette(c("blue", "white", "red"))(n = 5)))
#colors<-color.scale(as.numeric(dat$CN),my_palette[,1],my_palette[,2],my_palette[,3]);
color.legend<-color.gradient(my_palette[,1],my_palette[,2],my_palette[,3],nslices=5);
#color.legend <- color.legend[-3]
lev <- seq(0,4,length.out = 5)
getcolor <- function(CNV)
{

  if(CNV==0){
    return(color.legend[1])
  }else if(CNV == 1){
    return(color.legend[2])
  }else if(CNV==3){
    return(color.legend[4])
  }else if(CNV==4){
    return(color.legend[5])
  }else{
    print('拷贝数错误,请检查 dat 矩阵 是否有 其他拷贝数 拷贝数只有 0 1 3 4')
    q()
  }

}

colors <- c()
for(cn in dat$CN){
  colors=c(colors,getcolor(cn))
}

dat$color <- colors;


samples_num <- length(unique(dat$sample))
len <- samples_num
sample=unique(dat$sample)
max = info[nrow(info),2] + info[nrow(info),3]
per=(max/60)
chr=info[,1]


chr_pos <- as.numeric((info[,2]/2+info[,3]))/per
##### 如果遇到染色体无法显示的问题,可以考虑调整间隔,放开下方的注释  通过增大JIANGE 变量 显示所有染色体
# JIANGE = 1.1
# chr_pos_temp <- rev(chr_pos)
# for (i in 1:length((chr_pos_temp))) {
#   if(i==1){
#     next
#   }else{
#       last = i - 1
#       interval <- chr_pos_temp[last]-chr_pos_temp[i]
#       if(interval<JIANGE){
#         chr_pos_temp[i] = chr_pos_temp[i] - (JIANGE-interval)
#       }
#     }
# }
# chr_pos <- rev(chr_pos_temp)
########## 绘制图像 ##############################
pdf(output,width=16,height=samples_num/2)
par(mar=c(6,12,2,4),cex.axis = 0.7)
plot(1:len+2,1:len,type="n",ylim=c(0,len/4+1),xlim=c(0,60),bty="n",yaxt="n",xaxt="n",xlab="Chromosome",ylab="",xaxs="i");
axis(2,at=(c(1:len)-0.5)/4,labels=sample,las=2,col = "NA", col.ticks = "NA");
axis(1,at=(chr_pos),labels=chr,las=1,col = "NA", col.ticks = "NA");
axis(1,at=(unique(as.numeric(c(max,info[,3])))/per),labels=NA,las=1,col = "black", col.ticks = "black");
for (i in 1:nrow(dat)) {
  subset<-dat[i,];
  x.left<-subset$start/per;
  x.right<-subset$end/per;
  y.top<- which(subset$sample == sample)/4;
  y.bottom <- y.top-1/4
  col<-as.character(subset$color);
  rect(x.left,y.bottom,x.right,y.top,col=col,border="NA");
}
lines(c(0,60), c(0,0), type = 'l')
lines(c(0,60), c(len/4,len/4), type = 'l')
lines(c(0,0), c(0,len/4), type = 'l')
lines(c(60,60), c(0,len/4), type = 'l')
color.legend(53,len/4+0.3,59,len/4+0.5,c(0,1,2,3,'  >=4'),color.legend,gradient="x");
dev.off()
