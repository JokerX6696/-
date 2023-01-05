rm(list=ls())
setwd('D:/desk/R_tmp')
#!/home/oebiotech/conda_env/R4.0/bin/R

library("ComplexHeatmap")

out='test'
mat = read.table('30n.plot.xls', header = TRUE, sep = "\t" , row.names=1)
mat[mat=="."] <- ""

if (nrow(mat) > 50) {
  mat=mat[1:50,]
}

data = mat[,c(1:ncol(mat)-1)]

col = c("Frameshift" = "#00468BFF", "Nonsense" = "#ED0000FF", "Missense" = "#42B540FF","In_frameshift" = "#0099B4FF" ,"Splice" = "#925E9FFF","Stoploss" = "#FDAF91FF","Multi_hit"="black")
heatmap_legend_param = list(title = "Mutation types", at = c("Multi_hit","Nonsense", "Stoploss","Splice","Frameshift","In_frameshift","Missense"),labels = c("Multi_hit","Nonsense","Stoploss","Splice_site", "Frameshift", "In_frameshift","Missense"))
# heatmap_legend_param = list(title = "Mutation types", at = c("Nonsense","Stoploss", "Splice","Missense"),labels = c("Nonsense","Nonstop","Splice_site","Missense"))



alter_fun = list(
  # background = function(x, y, w, h) {
  #   grid.rect(x, y, w-unit(0.5, "mm"), h-unit(0.5, "mm"),
  #             gp = gpar(fill = "#F8F8FF", col = "#F8F8FF", lwd =0, just = "top"))
  # },
  background = function(x, y, w, h) {
    grid.rect(x, y, w*0.95, h*0.95,
              gp = gpar(fill = "#F8F8FF", col = "#F8F8FF", lwd =0, just = "top"))
  },
  Missense = function(x, y, w, h) {
    grid.rect(x, y, w*0.95, h*0.95,
              gp = gpar(fill = col["Missense"], col = col["Missense"], lwd =0, just = "top"))
  },
  In_frameshift = function(x, y, w, h) {
    grid.rect(x, y, w*0.95, h*0.95,
              gp = gpar(fill = col["In_frameshift"], col = col["In_frameshift"], lwd =0, just = "top"))
  },
  Frameshift = function(x, y, w, h) {
    grid.rect(x, y, w*0.95, h*0.95,
              gp = gpar(fill = col["Frameshift"], col = col["Frameshift"], lwd =0, just = "top"))
  },
  Splice= function(x, y, w, h) {
    # grid.rect(x, y-0.33*h, w*0.95, 0.33*h,
    grid.rect(x, y, w*0.95, 0.95*h,
              gp = gpar(fill = col["Splice"], col = col["Splice"], lwd =0, just = "top"))
  },
  Stoploss= function(x, y, w, h) {
    grid.rect(x, y, w*0.95, h*0.95,
              gp = gpar(fill = col["Stoploss"], col = col["Stoploss"], lwd =2, just = "top"))
  },
  Nonsense = function(x, y, w, h) {
    # grid.rect(x, y, w*0.95, 0.33*h,
    grid.rect(x, y, w*0.95, 0.95*h,
              gp = gpar(fill = col["Nonsense"], col = col["Nonsense"], lwd =0, just = "top"))
  },
  Multi_hit = function(x, y, w, h) {
    grid.rect(x, y, w*0.95, h*0.95,
              gp = gpar(fill = col["Multi_hit"], col = col["Multi_hit"], lwd =0, just = "top"))
  }
)

show="FALSE"
if(ncol(data) <= 20) {
  show="TRUE"
}
#####################################################################
dt <- read.table('TMB.xls',sep='\t',row.names = 1)
top2 <- dt
p = HeatmapAnnotation(
  TMB = anno_barplot(top2,gp = gpar(fill = 'red', col = 'red'),border = FALSE))

#####################################################################


pdf('All_sample_waterfall.pdf',width=8,height=6)
oncoPrint(data, get_type = function(x) strsplit(x, ";")[[1]],
          alter_fun = alter_fun, 
          col = col,
          column_title = NA,
          heatmap_legend_param = heatmap_legend_param,
          top_annotation = p,
          show_column_names = show,
          show_row_names = TRUE,
          column_order = 1:ncol(data), 
          row_order = 1:nrow(data),
          row_names_side = "left", #基因在左
          pct_side = "right",
          right_annotation = NULL,
          column_labels = c('LHO','MDC-135','MDC-139','P135','P139'),
          column_title_rot = 90
          )

dev.off()

png('All_sample_waterfall.png',width=800,height=600)
oncoPrint(data, get_type = function(x) strsplit(x, ";")[[1]],
          alter_fun = alter_fun, 
          col = col,
          column_title = NA,
          heatmap_legend_param = heatmap_legend_param,
          top_annotation = p,
          show_column_names = show,
          show_row_names = TRUE,
          column_order = 1:ncol(data), 
          row_order = 1:nrow(data),
          row_names_side = "left", #基因在左
          pct_side = "right",
          right_annotation = NULL,
          column_labels = c('LHO','MDC-135','MDC-139','P135','P139'),
          column_title_rot = 90
)

dev.off()
