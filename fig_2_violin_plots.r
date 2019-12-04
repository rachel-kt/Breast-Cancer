
library(ggplot2)
rna_data = read.csv("/media/rachel/Part2/OneDrive - south.du.ac.in/project_jnu/Pallavi/heatmap/rna_seq_hmdata.csv")
coln_cbio = colnames(rna_data)
coln_cbio[4] = "Cancer_Subtype"
colnames(cbio_data) = coln_cbio
g_candidate = read.csv("/media/rachel/Part2/OneDrive - south.du.ac.in/project_jnu/Pallavi/Box_violin_plot/candidate_genes.csv", stringsAsFactors = F)
can_genes = g_candidate$dreg
plot_save_path = "/media/rachel/Part2/OneDrive - south.du.ac.in/project_jnu/Pallavi/Box_violin_plot/Plots/DR/"
cbbPalette <- c("#E69F00", "#56B4E9", "#F0E442", "#009E73")
for (gene in can_genes) 
{
  data = data.frame(cbio_data[,match(gene, colnames(cbio_data))], cbio_data[,4])
  colnames(data) = c("zscore", "subtype")
  vplot1 <- ggplot(data, aes(x = subtype, y = zscore, fill = subtype))
  vplot1 +
    theme_classic() +
    geom_violin(scale = "count", size = 0) +
    #scale_fill_manual(values = c("grey20", "grey40", "grey60", "grey80")) +
    scale_fill_manual(values = cbbPalette) +
    geom_boxplot(width = .05, fill = "black", outlier.colour = "black") +
    stat_summary(fun.y = median, geom = "point", fill = "white", shape = 21, size = 2) +
    theme(legend.position="none") +
    ggtitle(gene) +
    xlab("") + ylab("z score") +
    labs(fill = "Cancer subtype") +
    theme(plot.title = element_text(hjust = 0.5, size = 8)) +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
  ggsave(paste(gene,".png", sep = ""), plot = last_plot(), 
         device = NULL, 
         path = plot_save_path, 
         scale = 1, width = 20, height = 15, units = c("cm"), dpi = 300, limitsize = TRUE)
}

