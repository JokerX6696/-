rm(list=ls())
setwd('D:\\desk\\DZOE2023041442-王石-数据高级分析')
library("VennDiagram")
library('grid')
library('futile.logger')
for (variable in dir(pattern = ".*xls")) {
  

file <- variable
out_file <- sub("_0.8_stat.xls","_Venn.pdf",file)
df <- read.table(file,sep = '\t',header = F,row.names = 1)
names(df) <- 'reads_num'
N123 <- df$reads_num[1]
N12 <- df$reads_num[5] + N123
N23 <- df$reads_num[6] + N123
N13 <- df$reads_num[7] + N123
AREA1 <- df$reads_num[3] + N12 + N13 - N123 
AREA2 <- df$reads_num[2] + N23 + N12 - N123  
AREA3 <- df$reads_num[4] + N13 + N23 - N123 
pdf(file = out_file,width = 6,height = 6)
#par(mar=c(3,3,2,3),oma=c(1,1,1,1))
venn.plot <- draw.triple.venn(
  area1 = AREA1,
  area2 = AREA2,
  area3 = AREA3,
  n12 = N12,
  n23 = N23,
  n13 = N13,
  n123 = N123,
  category = c("Cyprinus carpio", "Carassius auratus", "Megalobrama amblycephala"),
  fill = c("#00468BFF", "#ED0000FF", "#42B540FF"),
  lty = "blank",
  cex = 1,
  cat.cex = 1.5,
  cat.col = c("#00468BFF", "#ED0000FF", "#42B540FF"),
  margin = 0.15,
  cex.label = 0.5
  #label.col = "black"
);
#grid.draw(venn.plot);#画图展示
dev.off()
png(file = sub("pdf","png",out_file),width = 600,height = 600)
#par(mar=c(3,3,2,3),oma=c(1,1,1,1))
venn.plot <- draw.triple.venn(
  area1 = AREA1,
  area2 = AREA2,
  area3 = AREA3,
  n12 = N12,
  n23 = N23,
  n13 = N13,
  n123 = N123,
  category = c("Cyprinus carpio", "Carassius auratus", "Megalobrama amblycephala"),
  fill = c("#00468BFF", "#ED0000FF", "#42B540FF"),
  lty = "blank",
  cex = 1,
  cat.cex = 1.5,
  cat.col = c("#00468BFF", "#ED0000FF", "#42B540FF"),
  margin = 0.15,
  cex.label = 0.5
  #label.col = "black"
);
#grid.draw(venn.plot);#画图展示
dev.off()
}
