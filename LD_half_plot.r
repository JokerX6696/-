rm(list=ls())
library(ggsci)
pal <- pal_locuszoom()(5)
setwd('D:/desk/R_temp')

pdf("LDdecay.new.pdf")
read.table("LDdecay.Old_Honghe")->ECultivar;
plot(ECultivar[,1]/1000,ECultivar[,2],type="l",col=pal[1],main="LD decay",xlab="Distance(Kb)",xlim=c(0,200),ylim=c(0,0.35),ylab=expression(r^{2}),bty="n")
read.table("LDdecay.Yangtze")->EFeral;
lines(EFeral[,1]/1000,EFeral[,2],col=pal[5])
read.table("LDdecay.Zhujiang")->EWild;
lines(EWild[,1]/1000,EWild[,2],col=pal[3])
legend("topright",c("Old_Honghe","Yangtze","Zhujiang"),col=c(pal[1],pal[5],pal[3]),cex=1,lty=c(1,1,1),bty="n");
#shuima
te <- read.table('LDdecay.Old_Honghe',sep='\t')
te <- te[,1:2]
ld_half <- te$V2[1]/2
ld_half_dis <- te[te$V2>=ld_half,]
ld_half_dis <- max(ld_half_dis$V1)/1000
#abline(v=ld_half_dis,col=pal[1],lty=2)
#abline(h=ld_half,col=pal[1],lty=2)
lines(x=c(-12,ld_half_dis),y=c(ld_half,ld_half),col=pal[1],lty=2)
lines(x=c(ld_half_dis,ld_half_dis),y=c(0,ld_half),col=pal[1],lty=2)
print(ld_half_dis)

te <- read.table('LDdecay.Yangtze',sep='\t')
te <- te[,1:2]
ld_half <- te$V2[1]/2
ld_half_dis <- te[te$V2>=ld_half,]
ld_half_dis <- max(ld_half_dis$V1)/1000
#abline(v=ld_half_dis,col=pal[5],lty=2)
#abline(h=ld_half,col=pal[5],lty=2)
lines(x=c(-12,ld_half_dis),y=c(ld_half,ld_half),col=pal[5],lty=2)
lines(x=c(ld_half_dis,ld_half_dis),y=c(0,ld_half),col=pal[5],lty=2)
print(ld_half_dis)

te <- read.table('LDdecay.Zhujiang',sep='\t')
te <- te[,1:2]
ld_half <- te$V2[1]/2
ld_half_dis <- te[te$V2>=ld_half,]
ld_half_dis <- max(ld_half_dis$V1)/1000
#abline(v=ld_half_dis,col=pal[3],lty=2)
#abline(h=ld_half,col=pal[3],lty=2)
lines(x=c(-12,ld_half_dis),y=c(ld_half,ld_half),col=pal[3],lty=2)
lines(x=c(ld_half_dis,ld_half_dis),y=c(0,ld_half),col=pal[3],lty=2)
print(ld_half_dis)

dev.off()


png("LDdecay.new.png")
read.table("LDdecay.Old_Honghe")->ECultivar;
plot(ECultivar[,1]/1000,ECultivar[,2],type="l",col=pal[1],main="LD decay",xlab="Distance(Kb)",xlim=c(0,200),ylim=c(0,0.35),ylab=expression(r^{2}),bty="n")
read.table("LDdecay.Yangtze")->EFeral;
lines(EFeral[,1]/1000,EFeral[,2],col=pal[5])
read.table("LDdecay.Zhujiang")->EWild;
lines(EWild[,1]/1000,EWild[,2],col=pal[3])
legend("topright",c("Old_Honghe","Yangtze","Zhujiang"),col=c(pal[1],pal[5],pal[3]),cex=1,lty=c(1,1,1),bty="n");
#shuima
te <- read.table('LDdecay.Old_Honghe',sep='\t')
te <- te[,1:2]
ld_half <- te$V2[1]/2
ld_half_dis <- te[te$V2>=ld_half,]
ld_half_dis <- max(ld_half_dis$V1)/1000
#abline(v=ld_half_dis,col=pal[1],lty=2)
#abline(h=ld_half,col=pal[1],lty=2)
lines(x=c(-12,ld_half_dis),y=c(ld_half,ld_half),col=pal[1],lty=2)
lines(x=c(ld_half_dis,ld_half_dis),y=c(0,ld_half),col=pal[1],lty=2)
print(ld_half_dis)

te <- read.table('LDdecay.Yangtze',sep='\t')
te <- te[,1:2]
ld_half <- te$V2[1]/2
ld_half_dis <- te[te$V2>=ld_half,]
ld_half_dis <- max(ld_half_dis$V1)/1000
#abline(v=ld_half_dis,col=pal[5],lty=2)
#abline(h=ld_half,col=pal[5],lty=2)
lines(x=c(-12,ld_half_dis),y=c(ld_half,ld_half),col=pal[5],lty=2)
lines(x=c(ld_half_dis,ld_half_dis),y=c(0,ld_half),col=pal[5],lty=2)
print(ld_half_dis)

te <- read.table('LDdecay.Zhujiang',sep='\t')
te <- te[,1:2]
ld_half <- te$V2[1]/2
ld_half_dis <- te[te$V2>=ld_half,]
ld_half_dis <- max(ld_half_dis$V1)/1000
#abline(v=ld_half_dis,col=pal[3],lty=2)
#abline(h=ld_half,col=pal[3],lty=2)
lines(x=c(-12,ld_half_dis),y=c(ld_half,ld_half),col=pal[3],lty=2)
lines(x=c(ld_half_dis,ld_half_dis),y=c(0,ld_half),col=pal[3],lty=2)
print(ld_half_dis)

dev.off()

