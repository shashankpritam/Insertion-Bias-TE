library(ggplot2)
library(RColorBrewer)
library(plyr)
library(gridExtra)
theme_set(theme_bw())

cn<-seq(0,99,1)
res<-10*1.1^cn
#theo<-data.frame(x=1:100,y=res)
validation<-read.table("2023_02_21_Validation_1_invasion", fill = TRUE, sep = "\t")
names(validation)<-c("rep", "gen", "popstat", "spacer_1", "fwte", "avw", "minw","avtes", "avpopfreq", "fixed", "spacer_2", "phase", "fwcli","avcli","fixcli","spacer_4","avbias","3tot", "3cluster")

#gl<-ggplot()+geom_line(data=validation,aes(x=gen,group=rep,y=avtes*1000),alpha=0.15,size=0.3)+scale_y_log10()+geom_line(data=theo,aes(x=x,y=y),size=2)+theme(legend.position="none")+ylab("TE copies in the population")+xlab("generation")
#plot(gl)



theo<-data.frame(x=1:100,y=res/1000)
gl<-ggplot()+geom_line(data=validation,aes(x=gen,group=rep,y=avtes),alpha=0.15,size=0.3)+scale_y_log10()+geom_line(data=theo,aes(x=x,y=y),size=2)+theme(legend.position="none")+ylab("TEs insertions per diploid individual")+xlab("generation")
plot(gl)
