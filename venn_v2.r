rm(list=ls())
df <- as.data.frame(readxl::read_xlsx('Venn_data1.xlsx'))
library("VennDiagram")
library('grid')
library('futile.logger')

l <- list(control=df$control,case=na.omit(df$case))

venn.diagram(
  x = l,
  filename = 'venn.png',
  imagetype="png",
  alpha= 0.3,
  lwd='blank',lty='blank',col=c('#FFFFCC','#CCFFFF'),
  cat.pos = c(180,0),
  fill=c('#00468BFF','#ED0000FF')
             )
