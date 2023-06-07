rm(list=ls())
setwd('D:\\desk\\DZOE2023041442-王石-数据高级分析')
library("VennDiagram")
library(grid)
library(futile.logger)
file <- 'CB-3_0.8_stat.xls'
df <- read.table(file,sep = '\t',header = F,row.names = 1)
names(df) <- 'reads_num'
N123 <- df$reads_num[1]
N12 <- df$reads_num[5] + N123
N23 <- df$reads_num[6] + N123
N13 <- df$reads_num[7] + N123
AREA1 <- df$reads_num[3] + N12 + N13
AREA2 <- df$reads_num[2] + N23 + N12
AREA3 <- df$reads_num[4] + N13 + N23
venn.plot <- draw.triple.venn(
  area1 = AREA1,
  area2 = AREA2,
  area3 = AREA3,
  n12 = N12,
  n23 = N23,
  n13 = N13,
  n123 = N123,
  category = c("Cyprinus carpio", "Carassius auratus", "Megalobrama amblycephala"),
  fill = c("blue", "red", "green"),
  lty = "blank",
  cex = 2,
  cat.cex = 2,
  cat.col = c("blue", "red", "green")
);
grid.draw(venn.plot);#画图展示
dev.off()
