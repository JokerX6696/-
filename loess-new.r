library(gdata)
#install.packages('gdata')
library(dplyr)
require(parallel)
library(tidyr)
library(ggplot2)
library(scales)
setwd('H:/new-20220715/������')
dir()
#args <- commandArgs(T)
#outname <-args[1] #输出图名

#inputfile <- args[2] #输入文件
#m=args[3] #输入模型aicc或者是gcv
m="aicc"
power <- as.numeric(6)
0.20469^6  
c1 <- makeCluster(as.numeric(3)) #输入线程�?
detectCores()
#file <- read.table("out.snp.xls",sep='\t',header=TRUE)
file1<-read.table("location.window.w5000000.s100000.step2.txt",sep='\t',header=TRUE)
head(file1)
#data <- file[,c("Chromosome","Position","ED")]
data1 <- file1[,c("Chromosome","Position","ED")]
chrs <- unique(data$Chromosome)
#data$nums <- as.numeric(gsub("\\D", "", data$Chromosome))
data1$nums <- as.numeric(gsub("\\D", "", data1$Chromosome))
head(data1)
loessopt <- function (s, e, p, m) {
	# extract values from loess object
	x <- try(loess(e ~ p, span=s, degree=1, family="symmetric", surface='direct'), silent=T)
	if(class(x)=="try-error"){return(NA)}
	span <- x$pars$span
	n <- x$n
	traceL <- x$trace.hat
	sigma2 <- sum( x$residuals^2 ) / (n-1)
	delta1 <- x$one.delta
	delta2 <- x$two.delta
	enp <- x$enp
	if(m=="aicc"){return(log(sigma2) + 1 + 2* (2*(traceL+1)) / (n-traceL-2))}
	if(m=="gcv"){return(n*sigma2 / (n-traceL)^2)}
}

for(chr in chrs) {
	e = data1$ED[data1$Chromosome == chr]^6
	p = data1$Position[data1$Chromosome == chr]
	#spanresults.span <- NULL
	#spanresults.aicc <- NULL
	#spanresults.span <- seq(round(50/length(p),digits=3), 1, .001)
	#spanresults.aicc <- parSapply(c1, spanresults.span, loessopt, e=e, p=p, m=m)       ####parSapply函数 span参数
	#usespan <- spanresults.span[spanresults.aicc==min(spanresults.aicc, na.rm=T)]
	#lo <- loess(e ~ p, span = 0.75, degree=1, family='symmetric', surface='direct') #designate usespan index incase of tie.
	lo <- loess(e ~ p, span = 0.5, degree=1) 
	data1$fitted[data1$Chromosome==chr] <- lo$fitted
	data1$unfitted[data1$Chromosome==chr] <- lo$y
	cat(chr, length(p), round(0.501, digits=3), "\n", sep="\t")
}

#span = 0.5, degree=1,family='symmetric', surface='direct'
#stopCluster(c1)
#plotdata <- data[!is.na(data$fitted),]
plotdata1 <- data1[!is.na(data1$fitted),]
head(plotdata1)
#cutoff <- 1.5*(sd(plotdata$fitted)+median(plotdata$fitted)) #置信
cutoff1 <- 3*(sd(plotdata1$fitted)+median(plotdata1$fitted)) #置信
plotdata1$Position <- plotdata1$Position/(10^6)
chrom <- unique(plotdata1$Chromosome)
plotdata1$chr_n <- factor(plotdata1$Chromosome, levels=chrom)
MAX=max(plotdata1[,5])*1.5
limit <- c(0,MAX)

p <- ggplot(plotdata1,aes(chr_n,Position)) + geom_point(data=plotdata1,aes(x=Position,y=unfitted,color=chr_n),size=0.5)+
  geom_line(data=plotdata1,aes(x=Position,y=fitted),size=0.8,stat="identity",color="red3")+
  facet_grid(.~chr_n,scale="free_x",space="free_x",switch='x')+
  geom_hline(yintercept = 0,size=0.8)+
  theme_bw()+
  theme(
        axis.text.x = element_blank(),
        axis.text.y = element_text(color = "black",size=8),
        axis.title = element_text(size=12),
        axis.ticks.x = element_blank(),
        panel.border = element_blank(),
        panel.spacing.x = unit(0,"lines"),
        panel.grid =element_blank(),
        panel.background = element_rect(fill="white"),
        strip.background = element_blank(),
        strip.placement = "outside",
        strip.text.x = element_text(size=10),
        strip.text.y = element_text(angle = 180),
        legend.position = "none",
        plot.title = element_text(hjust = 0.5,size=10,color="black"),
        axis.line.y = element_line(color="black", size = 0.8))+
  geom_hline(aes(yintercept=cutoff1), colour="black", linetype="dashed")+
  labs(x="Chromosome (Mb)",y=expression("ED"^"6"),title="")+
  scale_x_continuous(expand=c(0,0))+
  scale_y_continuous(expand=c(0,0),limits=limit,breaks=pretty_breaks(n=7))+
  scale_color_manual(values=rep(c("#0068B7","#90C31F"),11))
p

outname="HP.ED"
ggsave(plot=p,paste(outname,"manhatan.pdf",sep="."),height=20,width=50,units="cm")

ggsave(plot=p,paste(outname,"manhatan.png",sep="."),dpi=600,height=20,width=50,units="cm")


