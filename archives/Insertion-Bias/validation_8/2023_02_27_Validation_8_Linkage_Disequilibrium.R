library(ggplot2)
library(dplyr)
library(patchwork)

D0 = 0.25

Dnc_0.00<-((1-0.00)**(0:150))*D0
Dnc_0.01<-((1-0.01)**(0:150))*D0
Dnc_0.05<-((1-0.05)**(0:150))*D0
Dnc_0.1<-((1-0.1)**(0:150))*D0
Dnc_0.5<-((1-0.5)**(0:150))*D0

gen = c(0:150)
df<- data.frame(Dnc_0.00, Dnc_0.01, Dnc_0.05, Dnc_0.1, Dnc_0.5, gen)


gl<-ggplot(df, aes( x = gen))+
  geom_line(aes(y = Dnc_0.00), color = "blue")+
  geom_line(aes(y = Dnc_0.01), color = "green")+
  geom_line(aes(y = Dnc_0.05), color = "yellow")+
  geom_line(aes(y = Dnc_0.1), color = "orange")+
  geom_line(aes(y = Dnc_0.5), color = "red")+
  geom_label(aes(x = 48.5, y = 0.25,label = "c = 0.00"))+
  geom_label(aes(x = 30, y = 0.185,label = "c = 0.01"))+
  geom_label(aes(x = 18.5, y = 0.10,label = "c = 0.05"))+
  geom_label(aes(x = 12, y = 0.07,label = "c = 0.1"))+
  geom_label(aes(x = 4, y = 0.02,label = "c = 0.5"))+
  xlim(0,50)+
  ylab("D Linkage disequilibrium")+xlab("generation")
plot(gl)

t_8_1<-read.table("validation_8_1_debug", fill = TRUE, sep = "\t")
names(t_8_1)<-c("rep", "gen", "D")
g_8_1<-ggplot()+
  geom_line(data = t_8_1, aes(x = gen, y = D, group = rep), color = "grey")+
  geom_line(data = df, aes(x = gen, y = Dnc_0.00), color = "blue")+
  xlab("generation")+ylab("D")+
  ggtitle("c = 0")+
  ylim(0, 0.25)


t_8_2<-read.table("validation_8_2_debug", fill = TRUE, sep = "\t")
names(t_8_2)<-c("rep", "gen", "D")
g_8_2<-ggplot()+
  geom_line(data = t_8_2, aes(x = gen, y = D, group = rep), color = "grey")+
  geom_line(data = df, aes(x = gen, y = Dnc_0.01), color = "green")+
  xlab("generation")+ylab("D")+
  ggtitle("c = 0.01")+
  ylim(-0.01, 0.25)


t_8_3<-read.table("validation_8_3_debug", fill = TRUE, sep = "\t")
names(t_8_3)<-c("rep", "gen", "D")
g_8_3<-ggplot()+
  geom_line(data = t_8_3, aes(x = gen, y = D, group = rep), color = "grey")+
  geom_line(data = df, aes(x = gen, y = Dnc_0.05), color = "yellow")+
  xlab("generation")+ylab("D")+
  ggtitle("c = 0.05")+
  ylim(-0.01, 0.25)


t_8_4<-read.table("validation_8_4_debug", fill = TRUE, sep = "\t")
names(t_8_4)<-c("rep", "gen", "D")
g_8_4<-ggplot()+
  geom_line(data = t_8_4, aes(x = gen, y = D, group = rep), color = "grey")+
  geom_line(data = df, aes(x = gen, y = Dnc_0.1), color = "orange")+
  xlab("generation")+ylab("D")+
  ggtitle("c = 0.1")+
  ylim(-0.01, 0.25)

(g_8_1+g_8_2)/
  (g_8_3+g_8_4)