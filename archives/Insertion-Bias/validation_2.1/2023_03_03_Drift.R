library(ggplot2)
library(dplyr)
library(patchwork)

validation<-read.table("2023_03_03_Validation_2_Drift", fill = TRUE, sep = "\t")
names(validation)<-c("rep", "gen", "popstat", "spacer_1", "fwte", "avw", "minw","avtes", "avpopfreq", "fixed", "spacer_2", "phase", "fwcli","avcli","fixcli","spacer_4","avbias","3tot", "3cluster", "spacer 5", "sampleid")

data_1 <- validation[which(validation$sampleid == "pd250"),names(validation) %in% c("rep","fixed")]
gl_1<-ggplot(data_1,aes(x=fixed))+
  geom_histogram(binwidth = 1)+
#  ylim(0,65)+
  ggtitle("N = 250")+
  geom_vline(xintercept=20, lwd=1,lty=2, colour="blue")

data_2 <- validation[which(validation$sampleid == "pd500"),names(validation) %in% c("rep","fixed")]
gl_2<-ggplot(data_2,aes(x=fixed))+
  geom_histogram(binwidth = 1)+
#  ylim(0,65)+
  ggtitle("N = 500")+
  geom_vline(xintercept=10, lwd=1,lty=2, colour="blue")

data_3 <- validation[which(validation$sampleid == "pd1000"),names(validation) %in% c("rep","fixed")]
gl_3<-ggplot(data_3,aes(x=fixed))+
  geom_histogram(binwidth = 1)+
#  ylim(0,65)+
  ggtitle("N = 1000")+
  geom_vline(xintercept=5, lwd=1,lty=2, colour="blue")

gl_1+gl_2+gl_3