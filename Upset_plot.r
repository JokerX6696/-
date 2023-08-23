rm(list=ls())
setwd('D:/desk/XMSH_202308_5809')
if(!require('UpSetR')){
  install.packages('UpSetR')
}
library('UpSetR')

out <- 'Met'
f <- 'met.txt'
df <- read.table(f,header = T,row.names = 1,sep = '\t',comment.char = "",quote = "")
g <- unique(gsub('_\\d+$', '',names(df)))


all <- list()
for (i in g) {
  pos <- grepl(i,names(df))
  temp_df <- df[,pos]
  temp_vec <- apply(temp_df,1,sum)
  temp_pos <- names(which(0 != temp_vec))
  all[[i]] <- temp_pos
}


pdf(file = paste0(out,'_Upset.pdf'),width = 9,height = 6)
upset(
  fromList(all),
  nsets=length(all)
  )


dev.off()
