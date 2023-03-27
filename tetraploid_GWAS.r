#!/home/fanyucai/software/R/R-v3.2.0/bin/Rscript
#================================================
#
#         Author: baozhigui
#          Email: zhigui.bao@oebiotech.com
#         Create: 2018-09-27 09:12:13
#    Description: -
#
#================================================
rm(list=ls())
library(GWASpoly)
library(data.table)
# load datat
# format can be ACGT or numeric
setwd('D:/desk/马铃薯_夏露露/')
#source("D:/desk/马铃薯_夏露露/read.GWASpoly.R")

data <- read.GWASpoly(ploidy=4,pheno.file="15trait.txt",geno.file="extract_snp.130samples.tetraploid.genotype",format="ACGT",n.traits=15,delim="\t")

# kinship
data2 <- set.K(data, LOCO = FALSE)

# fixed effect population structure
params <- set.params(fixed=c("Grp1","Grp2","Grp3","Grp4"),fixed.type=rep("numeric",4),n.PC=4)

trait_name <- as.character(colnames(data@pheno))
trait_name <- trait_name[2:16]
# Mixed model analysis
# data3 <- GWASpoly(data2,models=c("general","additive","1-dom"),traits=trait_name,n.core=15)
data3 <- GWASpoly(data2,models=c("general","additive"),traits=trait_name,n.core=15)
# model qq plot
for (i in 1:15){
  pdf(paste(trait_name[i],".qqplot.pdf",sep=""),height=8,width=10)
  par(mfrow=c(2,3))
  # models <- c("additive","general","1-dom-alt","1-dom-ref")
  models <- c("additive","general")
  for (j in 1:2){
    qq.plot(data3,trait=trait_name[i],model=models[j])
  }
  dev.off()
  
}

#manhattan.plot(data4,trait="Long_width",model="additive")
# get result
data4 <- set.threshold(data3,method="Bonferroni",level=0.05)

for (i in 1:15){
  pdf(paste(trait_name[i],".manhattan.plot.pdf",sep=""),height=16,width=20)
  par(mfrow=c(4,1))
  # models <- c("additive","general","1-dom-alt","1-dom-ref")
  models <- c("additive","general")
  for (j in 1:2){
    manhattan.plot(data4,trait=trait_name[i],model=models[j])
  }
  dev.off()
}

for (i in 1:16){
  write.GWASpoly(data4,trait_name[i], paste(trait_name[i],"_scores.xls",sep=""), what = "scores", delim = "\t")
  write.GWASpoly(data4,trait_name[i], paste(trait_name[i],"_effects.xls",sep=""), what = "effects", delim = "\t")
}
#write.GWASpoly(data3, "long_width", "tuber_shape_data3.effects.xls", what = "effects", delim = "\t")
