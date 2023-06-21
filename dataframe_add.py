#!/bin/env python3
import pandas as pd

snp = 'snp_stat.xls'
snp_df = pd.read_csv(snp,sep='\t', index_col=0)
snp_bc = 'snp_bc.xls'
snp_bc_df = pd.read_csv(snp_bc,sep='\t', index_col=0)
# 确保两个矩阵具有相同的行索引和列标签
snp_bc_df = snp_bc_df.reindex(index=snp_df.index, columns=snp_df.columns, fill_value=0)

df_snp = snp_df + snp_bc_df


indel_bc = 'indel_bc.xls'
indel_bc_df = pd.read_csv(indel_bc,sep='\t', index_col=0)

indel = 'indel_stat.xls'
indel_df = pd.read_csv(indel,sep='\t', index_col=0)
# 确保两个矩阵具有相同的行索引和列标签
indel_bc_df = indel_bc_df.reindex(index=indel_df.index, columns=indel_df.columns, fill_value=0)

df_indel = indel_df + indel_bc_df


# 创建 ExcelWriter 对象
writer = pd.ExcelWriter('snv_stat.xlsx', engine='xlsxwriter')
# 将数据框保存为不同的工作表
snp_df.to_excel(writer, sheet_name='补充前snp', index=True)
df_snp.to_excel(writer, sheet_name='补充后snp', index=True)
indel_df.to_excel(writer, sheet_name='补充前indel', index=True)
df_indel.to_excel(writer, sheet_name='补充后indel', index=True)
snp_bc_df.to_excel(writer, sheet_name='补充snp', index=True)
indel_bc_df.to_excel(writer, sheet_name='补充indel', index=True)

# 保存 Excel 文件
writer.save()