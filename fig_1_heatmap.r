# CBioportal
library(viridis)
library(ComplexHeatmap)
library(circlize)
library(preprocessCore)

cbio_data = read.csv("heatmap/cbio_hm_data.csv", stringsAsFactors = T)
cbio_data = cbio_data[order(cbio_data$X3.Gene.classifier.subtype),]
cbio_hm = cbio_data[,5:ncol(cbio_data)]
rownames(cbio_data) = cbio_data$SAMPLE_ID
rownames(cbio_hm) = cbio_data$SAMPLE_ID
head(cbio_hm)

library(viridis)

colours <- list("Caner Types"=c("Basal"="#440154FF" ,"claudin-low"="#443A83FF", "Her2"="#31688EFF", "LumA"="#21908CFF", "LumB"="#35B779FF", "NC"="#8FD744FF", "Normal"="#FDE725FF"))
  RowAnn <- data.frame(cbio_data$Pam50...Claudin.low.subtype)
colnames(RowAnn) <- c("Cancer Types")
#colours <- list("Gene family"=c("ncRNA"="royalblue","pseudogene"="red3"))
RowAnn <- HeatmapAnnotation(df=RowAnn, col=colours, which="row", annotation_legend_param = list(legend_direction="horizontal", legend_width=unit(1,"cm"), title_position="topcenter", title_gp=gpar(fontsize=10, fontface="bold")))
#RowAnn <- rowAnnotation(df=RowAnn, col=colours, annotation_legend_param = list(RowAnn =list(legend_direction="horizontal")), legend_width=unit(1,"cm"), title_position="topcenter", title_gp=gpar(fontsize=10, fontface="bold"))

hmap <- Heatmap(cbio_data[,5:ncol(cbio_data)],
                name="Z-score",
                #col=colorRamp2(myBreaks, myCol),
                heatmap_legend_param=list(color_bar="continuous", legend_direction="horizontal", legend_width=unit(1,"cm"), title_position="topcenter", title_gp=gpar(fontsize=10, fontface="bold")),
                split=cbio_data$X3.Gene.classifier.subtype,
                row_title="Transcript class",
                row_title_side="left",
                row_title_gp=gpar(fontsize=7),
                show_row_names=F,
                column_title="",
                column_title_side="top",
                column_title_gp=gpar(fontsize=3, fontface="bold"),
                column_title_rot=0,
                show_column_names=F,
                clustering_distance_columns=function(x) as.dist(1-cor(t(x))),
                clustering_method_columns="ward.D2",
                #clustering_distance_rows="euclidean",
                clustering_method_rows="ward.D2",
                row_dend_width=unit(10,"mm"),
                column_dend_height=unit(10,"mm"),
                #Row annotation configurations
                cluster_rows=TRUE,
                show_row_dend=F,
                cluster_columns = T,
                #row_title="Transcript", #overridden by 'split' it seems
                #row_names_side="right",
                row_title_rot=0
                
                #Annotations (row annotation must be added with 'draw' function, below)
                #top_annotation_height=unit(0.5,"cm"),
                #top_annotation=ColAnn
                
)
draw(hmap + RowAnn, heatmap_legend_side="bottom", annotation_legend_side = "bottom")
hc <- as.hclust(column_dend(hmap))
labels_hm = hc$labels
order_cluster = labels_hm[hc$order]

