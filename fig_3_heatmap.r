library(viridis)
library(ComplexHeatmap)
library(circlize)
library(preprocessCore)

rna_hm = read.csv("heatmap/rna_seq_hmdata.csv")
unscaled = read.csv("heatmap/rna_seq_hmdata.csv")
rna_hm = rna_hm[,4:7]
rownames(rna_hm) = rna_hm$Symbol
rna_hm = rna_hm[,-1]
rna_hm = t(scale(t(rna_hm)))
colnames(rna_hm) = c("ADM", "PTX", "WT")
Heatmap(rna_hm, 
        name = "z score", 
        cluster_rows = T, 
        row_title_gp = gpar(fontsize= 12),
        row_names_gp = gpar(fontsize = 7),
        column_title_gp = gpar(fontsize = 12),
        column_names_gp = gpar(fontsize = 18)
        )
