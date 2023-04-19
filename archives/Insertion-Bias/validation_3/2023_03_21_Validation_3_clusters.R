library(ggplot2)
library(RColorBrewer)
library(plyr)
library(gridExtra)
theme_set(theme_bw())

validation<-read.table("2023_02_21_Validation_3_piRNA_clusters", fill = TRUE, sep = "\t")
names(validation)<-c("rep", "gen", "popstat", "spacer_1", "fwte", "avw", "minw","avtes", "avpopfreq", "fixed", "spacer_2", "phase", "fwcli","avcli","fixcli","spacer_3","avbias","3tot","3cluster","spacer_4","sampleids")

data_new <- validation
data_new$sampleid <- factor(data_new$sampleid,
                            levels = c("pc0", "pc50", "pc100"))

#gl<-ggplot()+geom_line(data=data_new,aes(x=gen,group=rep,y=avtes*1000),alpha=0.4)+scale_y_log10()+theme(legend.position="none")+ylab("TE copies in population")+xlab("generation")+facet_grid(.~sampleid)
#plot(gl)

g<-ggplot()+geom_line(data=data_new,aes(x=gen,group=rep,y=avtes),alpha=0.4)+
  scale_y_log10()+
  ylab("TEs insertions per diploid individual")+xlab("generation")+
  facet_grid(.~sampleid)+
  facet_wrap(~sampleid, ncol=3)

plot(g)