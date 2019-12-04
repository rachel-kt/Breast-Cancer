cbio_data = read.csv("heatmap/cbio_hm_data.csv", stringsAsFactors = T)
cbio_data = cbio_data[order(cbio_data$X3.Gene.classifier.subtype),]
data = data.frame(cbio_data${gene_name}, cbio_data$Cancer_Subtype)
colnames(data) = c("zscore", "subtype")
aov.out = aov(zscore ~ subtype, data=data)
summary(aov.out)
TukeyHSD(aov.out)

