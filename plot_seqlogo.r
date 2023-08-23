rm(list=ls())
setwd('D:/desk/R_wkdir')
library('ggplot2')
library('ggseqlogo')



data(ggseqlogo_sample)
df <- pfms_dna$MA0018.2
colnames(df)  <- 1:8

df[,1] <- c(25,25,25,25)
df[,2] <- c(50,50,0,0)
df[,3] <- c(0,0,50,50)
df[,4] <- c(100,0,0,0)
df[,5] <- c(0,100,0,0)
df[,6] <- c(0,0,100,0)
df[,7] <- c(80,10,8,2)
df[,8] <- c(33,24,26,17)

p <- ggseqlogo(df) + 
  theme_logo()

ggsave(filename = 'seqlogo.png',plot = p,device = 'png',width = 9,height = 6)




v1 <- rep(0.1,10)
v2 <- c(0.91,rep(0.01,9))

d <- data.frame(Species=1:10,sample1=v1,sample2=v2)
d <- melt(d,id.vars = 'Species')
names(d)[2] <- 'Samples'
ggplot(data = d,mapping = aes(x=factor(d$Samples), y = value, fill = factor(Species))) + 
  geom_bar(stat = 'identity',colour="#414141",width=0.6,position = "fill",show.legend = F) +
  scale_y_continuous(breaks=c(0.00,0.25,0.50,0.75,1.00), labels = c('0%','25%','50%','75%','100%')) +
  #geom_text(data = data,mapping = aes(x=factor(variable,levels = rev(unique(data$variable))), y = value),label = 2) +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 0,vjust = 0.5,hjust = 0.5) ) +
  labs(x = '',y="")
ggsave(filename = 'All_sample.png',device = 'png',width = 8, height = 6)
ggsave(filename = 'All_sample.pdf',device = 'pdf',width = 8, height = 6)
