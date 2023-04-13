#!/public/store5/DNA/Test/zhengfuxing/conda/bin/Rscript
# conda activate /public/store5/DNA/Test/zhengfuxing/conda
# unset R_LIBS_SITE
library(GWASpoly)
library(data.table)
library(ggplot2)
# load datat
# format can be ACGT or numeric
###########################
#traits_num = 27


###########################
data <- read.GWASpoly(ploidy=4,pheno.file="27BLUE.txt",geno.file="extract_snp.130samples.tetraploid.genotype",format="ACGT",n.traits=27,delim="\t")

# kinship
data2 <- set.K(data, LOCO = TRUE)

# fixed effect population structure
params <- set.params(fixed=c("Grp1","Grp2","Grp3","Grp4"),fixed.type=rep("numeric",4),n.PC=4)

trait_name <- as.character(colnames(data@pheno))
trait_name <- trait_name[2:28]
# Mixed model analysis
# data3 <- GWASpoly(data2,models=c("general","additive","1-dom"),traits=trait_name,n.core=15)
data3 <- GWASpoly(data2,models=c("general","additive","1-dom","2-dom"),traits=trait_name,n.core=15)
# model qq plot
models <- c("additive","general",'1-dom-alt','1-dom-ref','2-dom-alt','2-dom-ref')
for (i in 1:27){
  for (j in 1:6){
    p <- qq.plot(data3,trait=trait_name[i],model=models[j])
    ggsave(filename = paste(trait_name[i],models[j],"qqplot.pdf",sep="_"),plot = p,height=8,width=10,device = 'pdf')
    ggsave(filename = paste(trait_name[i],models[j],"qqplot.png",sep="_"),plot = p,height=8,width=10,device = 'png')
  }
}

#manhattan.plot(data4,trait="Long_width",model="additive")
# get result
data4 <- set.threshold(data3,method="Bonferroni",level=0.05)

for (i in 1:27){
  for (j in 1:6){
    p <- manhattan.plot(data4,trait=trait_name[i],model=models[j])
    ggsave(filename = paste(trait_name[i],models[j],"manhattan.pdf",sep="_"),plot = p,height=8,width=10,device = 'pdf')
    ggsave(filename = paste(trait_name[i],models[j],"manhattan.png",sep="_"),plot = p,height=8,width=10,device = 'png')
  }
}

for (i in 1:27){
  write.GWASpoly(data4,trait_name[i], paste(trait_name[i],"_scores.xls",sep=""), what = "scores", delim = "\t")
  write.GWASpoly(data4,trait_name[i], paste(trait_name[i],"_effects.xls",sep=""), what = "effects", delim = "\t")
}

