library(ggplot2)
library(RColorBrewer)
library(plyr)
library(patchwork)
library(ggpubr)

t_1<-read.table("validation_7_1_mhp", fill = TRUE, sep = "\t")
names(t_1)<-c("rep","gen","chr","pos","locus","popfreq")
t_1$rep<-as.factor(t_1$rep)
t_1$gen<-as.factor(t_1$gen)
t_1<-subset(t_1,rep==10)
t_1<-subset(t_1,gen==0 | gen==25 | gen==50)
g_1<-ggplot(data=t_1,aes(x=pos, fill=locus))+geom_histogram(binwidth=10000)+facet_grid(gen~chr, scales="free_x", space = "free_x")+
  scale_x_continuous(breaks=c(0,500000,1000000,1500000),labels=c("0","0.5m","1m","1.5m"))+
  xlab("position")+ylab("counter per 10kb bin")
plot(g_1)


t_1_2<-read.table("validation_7_1_mhp", fill = TRUE, sep = "\t")
names(t_1_2)<-c("rep","gen","chr","pos","locus","popfreq")
t_1_2$gen<-as.factor(t_1_2$gen)
t_1_2<-subset(t_1_2, gen==0)
g_1_2<-ggplot()+
  geom_bar(data=t_1_2,aes(x = locus, y = (..count..)/sum(..count..), fill = locus))+ 
  scale_y_continuous(labels = scales::percent_format(accuracy = 1))+
  ggtitle("Generation 0")+
  theme(legend.position="none", plot.title = element_text(size=14, face="bold.italic"))+
  ylab("relative frequencies")

t_1_3<-read.table("validation_7_1_mhp", fill = TRUE, sep = "\t")
names(t_1_3)<-c("rep","gen","chr","pos","locus","popfreq")
t_1_3$gen<-as.factor(t_1_3$gen)
t_1_3<-subset(t_1_3, gen==50)
g_1_3<-ggplot()+
  geom_bar(data=t_1_3,aes(x = locus, y = (..count..)/sum(..count..), fill = locus))+ 
  scale_y_continuous(labels = scales::percent_format(accuracy = 1))+
  ggtitle("Generation 50")+
  theme(plot.title = element_text(size=14, face="bold.italic"))+
  ylab("relative frequencies")

g_1_2+g_1_3


t_2<-read.table("validation_7_2_mhp", fill = TRUE, sep = "\t")
names(t_2)<-c("rep","gen","chr","pos","locus","popfreq")
t_2$rep<-as.factor(t_2$rep)
t_2$gen<-as.factor(t_2$gen)
t_2<-subset(t_2,rep==1)
t_2<-subset(t_2,gen==0 | gen==25 | gen==50 | gen==75 | gen==100)
g_2<-ggplot(data=t_2,aes(x=pos, fill=locus))+geom_histogram(binwidth=10000)+facet_grid(gen~chr, scales="free_x", space = "free_x")+
  scale_x_continuous(breaks=c(0,500000,1000000,1500000),labels=c("0","0.5m","1m","1.5m"))+
  xlab("position")+ylab("counter per 10kb bin")
plot(g_2)


t_2_2<-read.table("validation_7_2_mhp", fill = TRUE, sep = "\t")
names(t_2_2)<-c("rep","gen","chr","pos","locus","popfreq")
t_2_2$gen<-as.factor(t_2_2$gen)
t_2_2<-subset(t_2_2, gen==0)
g_2_2<-ggplot()+
  geom_bar(data=t_2_2,aes(x = locus, y = (..count..)/sum(..count..), fill = locus))+ 
  scale_y_continuous(labels = scales::percent_format(accuracy = 1))+
  ggtitle("Generation 0")+
  theme(legend.position="none", plot.title = element_text(size=14, face="bold.italic"))+
  ylab("relative frequencies")

t_2_3<-read.table("validation_7_2_mhp", fill = TRUE, sep = "\t")
names(t_2_3)<-c("rep","gen","chr","pos","locus","popfreq")
t_2_3$gen<-as.factor(t_2_3$gen)
t_2_3<-subset(t_2_3, gen==100)
g_2_3<-ggplot()+
  geom_bar(data=t_2_3,aes(x = locus, y = (..count..)/sum(..count..), fill = locus))+ 
  scale_y_continuous(labels = scales::percent_format(accuracy = 1))+
  ggtitle("Generation 100")+
  theme(plot.title = element_text(size=14, face="bold.italic"))+
  ylab("relative frequencies")

g_2_2+g_2_3

df_sel<-read.table("2023_03_09_Validation_7_Selection", fill = TRUE, sep = "\t")
names(df_sel)<-c("rep", "gen", "popstat", "spacer_1", "fwte", "avw", "min_w", "avtes", "avpopfreq",
                 "fixed","spacer_2", "phase", "fwcli", "avcli", "fixcli", "spacer_3",
                 "avbias",	"3tot",	"3cluster",	"spacer 4", "sampleid")


g_sel<-ggplot(df_sel, aes(x=gen, y=avpopfreq , group=rep))+
  geom_line(alpha=1,size=0.7)+
  ylab("TE population frequency") + xlab("generation")+
  facet_wrap(~sampleid, ncol=3)+
  facet_wrap(~sampleid, labeller = labeller(sampleid =
                                              c("psel3" = "x = 0",
                                                "psel4" = "x = 0.1",
                                                "psel5" = "x = 0.01",
                                                "psel6" = "x = 0.001",
                                                "psel7" = "x = 0.0001")))
plot(g_sel)


df3_s<-subset(df_sel, sampleid=="psel3")

p0=0.5
p<-p0
q<-1-p0
t=1000
traj<- matrix(NA, ncol=3, nrow=max(t)+1)
traj[1,1]<-p
traj[1,2]<-0
s=0
g=1
wAA=1-(2*s)
wAa=1-s
waa=1
while(g<=max(t)){
  w<- (p^2)*wAA + (2*p*q*wAa) + (q^2)*waa
  p<-( p*(p*wAA + q*wAa) ) / w
  q<-1-p
  traj[g+1,1]<-p
  traj[g+1,2]<-g
  g<-g+1
}
traj<- as.data.frame(traj)
traj[,3]<- "black"
  colnames(traj)<- c("freq", "generations", "color")
  
  g_s_3<-ggplot()+ 
    geom_line(df3_s, mapping=aes(x=gen, y=avpopfreq, group=rep), alpha =0.5)+
    geom_line(traj, mapping=aes(x=generations, y=(freq)), color="blue", size = 1)+
    ggtitle("x = 0")+
    labs(x="generation", y="frequency of TEs in the population")
  
  plot(g_s_3)
  
  
df4_s<-subset(df_sel, sampleid=="psel4")
  
p0=0.5
p<-p0
q<-1-p0
t=1000
traj<- matrix(NA, ncol=3, nrow=max(t)+1)
traj[1,1]<-p
traj[1,2]<-0
s=0.1
g=1
wAA=1-(2*s)
wAa=1-s
waa=1
while(g<=max(t)){
  w<- (p^2)*wAA + (2*p*q*wAa) + (q^2)*waa
  p<-( p*(p*wAA + q*wAa) ) / w
  q<-1-p
  traj[g+1,1]<-p
  traj[g+1,2]<-g
  g<-g+1
}
traj<- as.data.frame(traj)
traj[,3]<- "black"
  colnames(traj)<- c("freq", "generations", "color")
  g_s_4<-ggplot()+ 
    geom_line(df4_s, mapping=aes(x=gen, y=avpopfreq, group=rep),alpha =0.5)+
    geom_line(traj, mapping=aes(x=generations, y=(freq)), color="blue", size = 0.5)+
    ggtitle("x = 0.1")+
    labs(x="generation", y="frequency of TEs in the population")
  
  plot(g_s_4)

df5_s<-subset(df_sel, sampleid=="psel5")

p0=0.5
p<-p0
q<-1-p0
t=1000
traj<- matrix(NA, ncol=3, nrow=max(t)+1)
traj[1,1]<-p
traj[1,2]<-0
s=0.01
g=1
wAA=1-(2*s)
wAa=1-s
waa=1
while(g<=max(t)){
  w<- (p^2)*wAA + (2*p*q*wAa) + (q^2)*waa
  p<-( p*(p*wAA + q*wAa) ) / w
  q<-1-p
  traj[g+1,1]<-p
  traj[g+1,2]<-g
  g<-g+1
}
traj<- as.data.frame(traj)
traj[,3]<- "black"
  colnames(traj)<- c("freq", "generations", "color")
  
  g_s_5<-ggplot()+ 
    geom_line(df5_s, mapping=aes(x=gen, y=avpopfreq, group=rep), alpha =0.5)+
    geom_line(traj, mapping=aes(x=generations, y=(freq)), color="blue", size = 1)+
    ggtitle("x = 0.01")+
    labs(x="generation", y="frequency of TEs in the population")
  
  plot(g_s_5)
  
df6_s<-subset(df_sel, sampleid=="psel6")

p0=0.5
p<-p0
q<-1-p0
t=1000
traj<- matrix(NA, ncol=3, nrow=max(t)+1)
traj[1,1]<-p
traj[1,2]<-0
s=0.001
g=1
wAA=1-(2*s)
wAa=1-s
waa=1
while(g<=max(t)){
  w<- (p^2)*wAA + (2*p*q*wAa) + (q^2)*waa
  p<-( p*(p*wAA + q*wAa) ) / w
  q<-1-p
  traj[g+1,1]<-p
  traj[g+1,2]<-g
  g<-g+1
}
traj<- as.data.frame(traj)
traj[,3]<- "black"
  colnames(traj)<- c("freq", "generations", "color")
  g_s_6<-ggplot()+ 
    geom_line(df6_s, mapping=aes(x=gen, y=avpopfreq, group=rep), alpha =0.5)+
    geom_line(traj, mapping=aes(x=generations, y=(freq)), color="blue", size = 1)+
    ggtitle("x = 0.001")+
    labs(x="generation", y="frequency of TEs in the population")
  
  plot(g_s_6)
  
df7_s<-subset(df_sel, sampleid=="psel7")
  
p0=0.5
p<-p0
q<-1-p0
t=1000
traj<- matrix(NA, ncol=3, nrow=max(t)+1)
traj[1,1]<-p
traj[1,2]<-0
s=0.0001
g=1
wAA=1-(2*s)
wAa=1-s
waa=1
while(g<=max(t)){
  w<- (p^2)*wAA + (2*p*q*wAa) + (q^2)*waa
  p<-( p*(p*wAA + q*wAa) ) / w
  q<-1-p
  traj[g+1,1]<-p
  traj[g+1,2]<-g
  g<-g+1
}
traj<- as.data.frame(traj)
traj[,3]<- "black"
  colnames(traj)<- c("freq", "generations", "color")
  g_s_7<-ggplot()+ 
    geom_line(df7_s, mapping=aes(x=gen, y=avpopfreq, group=rep), alpha =0.5)+
    geom_line(traj, mapping=aes(x=generations, y=(freq)), color="blue", size = 1)+
    ggtitle("x = 0.0001")+
    labs(x="generation", y="frequency of TEs in the population")
  
  plot(g_s_7)
ggarrange(g_s_3, g_s_7, g_s_6, g_s_5, g_s_4,
          ncol = 3, nrow = 2, align = ("v"),
          labels = c("A", "B", "C", "D", "E"), heights = c(2,2), widths = c(2,2)
)