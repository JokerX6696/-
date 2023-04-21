rm(list=ls())
setwd('D:\\desk\\R_temp')
#library()

gene_file <- 'var.gene.xls'

gene_level <- read.table(gene_file,header = TRUE,sep = "\t")

p_list <- c()
p_name <- c()
for(i in 1:dim(gene_level)[1]){
  
  g1_var <- gene_level$s2A.mut[i]
  g1_nor <- gene_level$s2A.normal[i]
  
  g2_var <- gene_level$s2S.mut[i]
  g2_nor <- gene_level$s2S.normal[i]
  
  fis_mat <- matrix(c(g1_var,g1_nor,g2_var,g2_nor),nrow=2)
  
  result <- fisher.test(fis_mat)
  p_list <- c(p_list,result$p.value)
  p_name <- c(p_name,gene_level$Gene[i])
}

df <- data.frame(gene=p_name,p_value=p_list)

df <- df[order(df$p_value),]
df_2 <- unique(df[df$p_value<0.05,1])

write.table(df_2,file = 'fisher_significant_genelist.txt',sep = "",quote = F,col.names = F,row.names = F)


gene_file <- 'var.site.xls'

gene_level <- read.table(gene_file,header = TRUE,sep = "\t")

p_list <- c()
p_name <- c()
for(i in 1:dim(gene_level)[1]){
  
  g1_var <- gene_level$s2A.mut[i]
  g1_nor <- gene_level$s2A.normal[i]
  
  g2_var <- gene_level$s2S.mut[i]
  g2_nor <- gene_level$s2S.normal[i]
  
  fis_mat <- matrix(c(g1_var,g1_nor,g2_var,g2_nor),nrow=2)
  
  result <- fisher.test(fis_mat)
  p_list <- c(p_list,result$p.value)
  p_name <- c(p_name,gene_level$Gene[i])
}

df <- data.frame(gene=p_name,p_value=p_list)

df <- df[order(df$p_value),]
df_2 <- unique(df[df$p_value<0.05,1])

write.table(df_2,file = 'fisher_significant_sitelist.txt',sep = "",quote = F,col.names = F,row.names = F)

