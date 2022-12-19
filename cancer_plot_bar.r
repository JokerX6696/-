rm(list=ls())
setwd('D:/desk/R_tmp')
file <- 'Case1_BT.annotation.xls'
OutName <- 'test'
df <- read.table(file,header = TRUE,sep = '\t')
# 将 总矩阵 分解为 snp 矩阵 和 indel 矩阵
col_num <- length(df$chromosome)

ref <- c()
alt <- c()
for (col in 1:col_num) {
  ref <- c(ref,(nchar(df[col,3]) == 1))
  alt <- c(alt,(nchar(df[col,4]) == 1))
}

SNP <- ref & alt
INDEL <- !(ref & alt)


snp <- df[SNP,][,c(3,4)]
indel <- df[INDEL,][,c(3,4)]
# 这里必须再处理一下，否则行号有问题
snp <- data.frame(ref=snp$ref,alt=snp$alt)
indel <- data.frame(ref=indel$ref,alt=indel$alt)

# 统计 snp 替换情况
SNP <- c()
for(i in 1:length(snp$ref)){
  SNP <- c(SNP,paste(snp[i,1],snp[i,2],sep = ''))
}
AC=AG=AT=CA=CT=CG=GC=GA=GT=TA=TC=TG=0
for (i in SNP) {
  switch(i,
         AC = (AC=AC+1),
         AG = (AG=AG+1),
         AT = (AT=AT+1),
         CA = (CA=CA+1),
         CT = (CT=CT+1),
         CG = (CG=CG+1),
         GC = (GC=GC+1),
         GA = (GA=GA+1),
         GT = (GT=GT+1),
         TA = (TA=TA+1),
         TC = (TC=TC+1),
         TG = (TG=TG+1),
  )
}

df_snp <- data.frame(num=c(AC,AG,AT,CA,CT,CG,GC,GA,GT,TA,TC,TG))
rownames(df_snp) <- c('A>C','A>G','A>T','C>A','C>T','C>G','G>C','G>A','G>T','T>A','T>C','T>G')

# 画SNP 图

pal <- pal_locuszoom()(7)



df_snp$type1 <- row.names(df_snp)
#增加两列
  
for (i in 1:nrow(df_snp)){
    
  if (grepl("A>",df_snp$type1[i])){
      
  df_snp$type2[i] <- "A>N"
      
  }
    
  if (grepl("T>",df_snp$type1[i])){
      
    df_snp$type2[i] <- "T>N"
      
  }
    
  if (grepl("C>",df_snp$type1[i])){
      
    df_snp$type2[i] <- "C>N"
      
  }
    
  if (grepl("G>",df_snp$type1[i])){
      
    df_snp$type2[i] <- "G>N"
      
  }
    
  if (grepl("A>G",df_snp$type1[i]) | grepl("G>A",df_snp$type1[i]) | grepl("T>C",df_snp$type1[i]) | grepl("C>T",df_snp$type1[i])){
      
    df_snp$type3[i] <- "transition"
      
  }else{
      
    df_snp$type3[i] <- "transversion"
      
  }
    
}
ggplot(df_snp,aes(x=type1,y=num,fill=type3)) + 
    
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
  
  
ggsave(paste(OutName,'_snp',".pdf",sep=""),height=16*0.618,width=20,dpi=300,units = "cm")
  
ggsave(paste(OutName,'_snp',".png",sep=""),height=16*0.618,width=20,dpi=300,units = "cm")

# 处理 indel 矩阵
I <- c()
for (i in 1:length(indel$ref)) {
  a <- as.numeric(nchar(indel[i,2])-nchar(indel[i,1]))
  I <- c(I,a)
}
I <- I[I!=0]
I[I < -16] <- -16
I[I > 16] <- 16

DI <- c()
for(v in -16:16){
  counts <- 0
  for (i in I){
    if(i == v){
      counts = counts + 1
    }
  }
  DI <- c(DI,counts)
}

df_indel <- data.frame(type=-16:16,num=DI)
df_indel <- df_indel[!df_indel$type==0,]
df_indel$type[df_indel$type==-16] <- "<-15"
df_indel$type[df_indel$type==16] <- ">15"

rn <- df_indel$type
df_indel <- data.frame(num=df_indel$num)
rownames(df_indel) <- rn
rawdata <- df_indel
mean_v <- apply(rawdata,1,mean)

max_v <- apply(rawdata,1,max)

min_v <- apply(rawdata,1,min)

df <- data.frame(mean_v,max_v,min_v)[1:32,]  #取前32行


#增加两列

for (i in 1:nrow(df)){
  
  if (grepl("<-",row.names(df)[i])){
    
    df$type1[i] <- ">15"
    
    df$type2[i] <- "Deletion"
    
  }else{
    
    if (grepl(">",row.names(df)[i])){
      
      df$type1[i] <- ">15"
      
      df$type2[i] <- "Insertion"
      
    }else{
      
      if (grepl("^-",row.names(df)[i])){    #开头匹配“-”
        
        df$type1[i] <- gsub("-","",row.names(df)[i])
        
        df$type2[i] <- "Deletion"
        
      }else{
        
        df$type1[i] <- row.names(df)[i]
        
        df$type2[i] <- "Insertion"
        
      }
      
    }
    
  }
  
}


#使x轴坐标按指定顺序排列

level <- c(seq(1:15),">15")

df$type1 <- factor(df$type1,levels = level)


df1 <- df[which(df$type2=="Deletion"),]

df2 <- df[which(df$type2=="Insertion"),]


df1$mean_v = df1$mean_v*-1

df1$max_v = df1$max_v*-1

df1$min_v = df1$min_v*-1


df_plot <- rbind(df1,df2)


#设置要展示的y轴刻度和对应的标签

y_max = max(df$max_v)

yunit = 10**floor(log10(y_max))

ylimit = ceiling(y_max/yunit)

seq1=seq(-ylimit,ylimit,ylimit/5)*yunit

label=abs(seq1)


ggplot(df_plot,aes(x=type1,y=mean_v,fill=type2)) + 
  
  geom_bar(stat="identity",width = .7) +
  
  facet_grid(.~ type2,scales="free",space="free") +
  
  #geom_errorbar(aes(ymin=min_v,ymax=max_v),width=.3,size=0.25,colour="black") +
  
  coord_flip() +      #交换x,y坐标
  
  theme_bw()+
  
  theme(
    
    axis.text = element_text(color = "black",size=8),
    
    axis.text.y = element_text(color = "black",size=10),
    
    axis.title = element_text(color = "black",size=10),
    
    axis.ticks.y = element_blank(),
    
    panel.grid =element_blank(),
    
    panel.spacing.x = unit(0, "cm"),
    
    panel.background = element_rect(fill="white"),
    
    strip.background = element_rect(fill="grey"),
    
    strip.text.x = element_text(color = "black", size=10),
    
    legend.position = "none",
    
    axis.line = element_line(color="black", size = .5)) +                                                                                                
  
  labs(fill="",x="",y="Number") +
  
  scale_x_discrete(limits=rev(levels(df1$type1))) +   #反转x轴坐标
  
  scale_y_continuous(breaks = seq1,labels = label) +
  
  scale_fill_manual(values=c(pal[5],pal[3]))


ggsave(paste(OutName,'_indel',".pdf",sep=""),height=16*0.618,width=20,dpi=300,units = "cm")

ggsave(paste(OutName,'_indel',".png",sep=""),height=16*0.618,width=20,dpi=300,units = "cm")
