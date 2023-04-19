library(ggplot2)
library(dplyr)

validation<-read.table("2023_02_27_Validation_5_trigger_loci", fill = TRUE, sep = "\t")
names(validation)<-c("rep", "gen", "popstat", "spacer_1", "minw", "fwte", "avw", "avtes", "avpopfreq", "fixed","spacer_2","phase","fwcli","avcli","fixcli","spacer_3","avbias","3tot", "3cluster", "spacer 4", "sampleid")


data_new <- validation
data_new$sampleid <- factor(data_new$sampleid,
                            levels = c("pt1", "pt2", "pt3", "pt4", "pt5", "pt6", "pt7", "pt8", "pt9"))

gl<-ggplot()+geom_line(data=data_new,aes(x=gen,group=rep,y=avtes*1000),alpha=0.4)+scale_y_log10()+theme(legend.position="none")+ylab("TE copies in population")+xlab("generation")+facet_wrap(~sampleid, ncol=3)
plot(gl)