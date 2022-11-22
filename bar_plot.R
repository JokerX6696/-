rm(list=ls())
setwd('D:/desk/RTEST')
library(ggplot2)
library(ggsci)
df <- read.table('result_snp.xls',header = T)
pal <- pal_locuszoom()(7)
df$type1 <- df[,1]

for (i in 1:nrow(df)){
  if (grepl("A>",df$type1[i])){
    df$type2[i] <- "A>N"
  }
  if (grepl("T>",df$type1[i])){
    df$type2[i] <- "T>N"
  }
  if (grepl("C>",df$type1[i])){
    df$type2[i] <- "C>N"
  }
  if (grepl("G>",df$type1[i])){
    df$type2[i] <- "G>N"
  }
  if (grepl("A>G",df$type1[i]) | grepl("G>A",df$type1[i]) | grepl("T>C",df$type1[i]) | grepl("C>T",df$type1[i])){
    df$type3[i] <- "transition"
  }else{
    df$type3[i] <- "transversion"
  }
}




ggplot(df,aes(x=sample,y=cancer,fill=type3)) +
geom_bar(stat="identity",width = .7) +
facet_grid(.~ type2,scales="free_x",space="free") +
theme_bw()+
theme(
axis.text = element_text(color = "black",size=8),
axis.title = element_text(color = "black",size=10),
axis.ticks.x = element_blank(),
panel.grid =element_blank(),
panel.spacing.x = unit(0, "cm"),
panel.background = element_rect(fill="white"),
strip.background = element_rect(fill="grey"),
strip.text.x = element_text(color = "black", size=10),
legend.position = "right",
axis.line = element_line(color="black", size = .5)) +
labs(fill="",x="",y="Number") +
scale_fill_manual(values=c(pal[5],pal[3]))
dev.off
