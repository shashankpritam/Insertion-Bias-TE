#folder="/home/vetlinux05/Almo/insertion_bias"
#tool="/home/vetlinux05/Almo/insertion_bias/invadego/insertionbias"

#$tool --N 1000 --gen 500 --genome mb:10,10,10,10,10 --cluster kb:300,300,300,300,300 --rr 4,4,4,4,4 --rep 1000 --u 0.1 --basepop "10(-100)" --steps 500 --sampleid bm100 > $folder/2023_03_07_simulation_0_m100_500gen &
#$tool --N 1000 --gen 500 --genome mb:10,10,10,10,10 --cluster kb:300,300,300,300,300 --rr 4,4,4,4,4 --rep 1000 --u 0.1 --basepop "10(-75)" --steps 500 --sampleid bm75 > $folder/2023_03_07_simulation_0_m75_500gen &
#$tool --N 1000 --gen 500 --genome mb:10,10,10,10,10 --cluster kb:300,300,300,300,300 --rr 4,4,4,4,4 --rep 1000 --u 0.1 --basepop "10(-50)" --steps 500 --sampleid bm50 > $folder/2023_03_07_simulation_0_m50_500gen &
#$tool --N 1000 --gen 500 --genome mb:10,10,10,10,10 --cluster kb:300,300,300,300,300 --rr 4,4,4,4,4 --rep 1000 --u 0.1 --basepop "10(-25)" --steps 500 --sampleid bm20 > $folder/2023_03_07_simulation_0_m25_500gen &
#$tool --N 1000 --gen 500 --genome mb:10,10,10,10,10 --cluster kb:300,300,300,300,300 --rr 4,4,4,4,4 --rep 1000 --u 0.1 --basepop "10(0)" --steps 500 --sampleid b0 > $folder/2023_03_07_simulation_0_0_500gen &
#$tool --N 1000 --gen 500 --genome mb:10,10,10,10,10 --cluster kb:300,300,300,300,300 --rr 4,4,4,4,4 --rep 1000 --u 0.1 --basepop "10(10)" --steps 500 --sampleid b10 > $folder/2023_03_07_simulation_0_10_500gen &
#$tool --N 1000 --gen 500 --genome mb:10,10,10,10,10 --cluster kb:300,300,300,300,300 --rr 4,4,4,4,4 --rep 1000 --u 0.1 --basepop "10(20)" --steps 500 --sampleid b20 > $folder/2023_03_07_simulation_0_20_500gen &
#$tool --N 1000 --gen 500 --genome mb:10,10,10,10,10 --cluster kb:300,300,300,300,300 --rr 4,4,4,4,4 --rep 1000 --u 0.1 --basepop "10(30)" --steps 500 --sampleid b30 > $folder/2023_03_07_simulation_0_30_500gen &
#$tool --N 1000 --gen 500 --genome mb:10,10,10,10,10 --cluster kb:300,300,300,300,300 --rr 4,4,4,4,4 --rep 1000 --u 0.1 --basepop "10(40)" --steps 500 --sampleid b40 > $folder/2023_03_07_simulation_0_40_500gen &
#$tool --N 1000 --gen 500 --genome mb:10,10,10,10,10 --cluster kb:300,300,300,300,300 --rr 4,4,4,4,4 --rep 1000 --u 0.1 --basepop "10(50)" --steps 500 --sampleid b50 > $folder/2023_03_07_simulation_0_50_500gen &
#$tool --N 1000 --gen 500 --genome mb:10,10,10,10,10 --cluster kb:300,300,300,300,300 --rr 4,4,4,4,4 --rep 1000 --u 0.1 --basepop "10(60)" --steps 500 --sampleid b60 > $folder/2023_03_07_simulation_0_60_500gen &
#$tool --N 1000 --gen 500 --genome mb:10,10,10,10,10 --cluster kb:300,300,300,300,300 --rr 4,4,4,4,4 --rep 1000 --u 0.1 --basepop "10(70)" --steps 500 --sampleid b70 > $folder/2023_03_07_simulation_0_70_500gen &
#$tool --N 1000 --gen 500 --genome mb:10,10,10,10,10 --cluster kb:300,300,300,300,300 --rr 4,4,4,4,4 --rep 1000 --u 0.1 --basepop "10(80)" --steps 500 --sampleid b80 > $folder/2023_03_07_simulation_0_80_500gen &
#$tool --N 1000 --gen 500 --genome mb:10,10,10,10,10 --cluster kb:300,300,300,300,300 --rr 4,4,4,4,4 --rep 1000 --u 0.1 --basepop "10(90)" --steps 500 --sampleid b90 > $folder/2023_03_07_simulation_0_90_500gen &
#$tool --N 1000 --gen 500 --genome mb:10,10,10,10,10 --cluster kb:300,300,300,300,300 --rr 4,4,4,4,4 --rep 1000 --u 0.1 --basepop "10(100)" --steps 5ß0 --sampleid b100 > $folder/2023_03_07_simulation_0_100_500gen
#cat 2023_03_07_simulation* |grep -v "^Invade"|grep -v "^#" > 2023_03_07_Simulation_0_500_gen_exploration

#folder="/Users/ascarpa/Desktop"
#tool="/Users/ascarpa/invadego-insertionbias/invadego-insertionbias"

#$tool --N 1000 --gen 5000 --genome mb:10,10,10,10,10 --cluster kb:300,300,300,300,300 --rr 4,4,4,4,4 --rep 100 --u 0.1 --basepop "10(-50)" --steps 20 --sampleid bm50 > $folder/2023_03_07_simulation_0_m50 &
#$tool --N 1000 --gen 5000 --genome mb:10,10,10,10,10 --cluster kb:300,300,300,300,300 --rr 4,4,4,4,4 --rep 100 --u 0.1 --basepop "10(-25)" --steps 20 --sampleid bm25 > $folder/2023_03_07_simulation_0_m25 &
#$tool --N 1000 --gen 5000 --genome mb:10,10,10,10,10 --cluster kb:300,300,300,300,300 --rr 4,4,4,4,4 --rep 100 --u 0.1 --basepop "10(0)" --steps 20 --sampleid b0 > $folder/2023_03_07_simulation_0_0 &
#$tool --N 1000 --gen 5000 --genome mb:10,10,10,10,10 --cluster kb:300,300,300,300,300 --rr 4,4,4,4,4 --rep 100 --u 0.1 --basepop "10(25)" --steps 20 --sampleid b25 > $folder/2023_03_07_simulation_0_25 &
#$tool --N 1000 --gen 5000 --genome mb:10,10,10,10,10 --cluster kb:300,300,300,300,300 --rr 4,4,4,4,4 --rep 100 --u 0.1 --basepop "10(50)" --steps 20 --sampleid b50 > $folder/2023_03_07_simulation_0_50 
#cat 2023_03_07_simulation_0* |grep -v "^Invade"|grep -v "^#" > 2023_03_07_Simulation_0_exploration

library(tidyverse)
library(RColorBrewer)
library(ggpubr)
theme_set(theme_bw())

p<-c("#1a9850","#ffd700","#d73027")

setwd("/Users/ascarpa/Desktop")

df0 <- read.table("2023_03_07_Simulation_0_500_gen_exploration", fill = TRUE, sep = "\t") 
names(df0)<-c("rep", "gen", "popstat", "spacer_1", "fwte", "avw", "min_w", "avtes", "avpopfreq",
             "fixed","spacer_2", "phase", "fwcli", "avcli", "fixcli", "spacer_3",
             "avbias","3tot", "3cluster","spacer_4", "sampleid")

df00 <- subset(df0, gen != 0)

df00<-select (df00,-c(22))

df0_stat <- df00 %>%
  group_by(sampleid) %>%
  summarize(fail = sum(popstat == "fail-0"),
            success = sum(popstat == "ok"),
            total = success + fail,
            ok_rate = success/total)


df0_stat <- df0_stat %>%
  mutate(sampleid = str_replace(sampleid,"bm75", "-75")) %>%
  mutate(sampleid = str_replace(sampleid,"bm50", "-50")) %>%
  mutate(sampleid = str_replace(sampleid,"bm20", "-25")) %>%
  mutate(sampleid = str_replace(sampleid,"b0", "0")) %>%
  mutate(sampleid = str_replace(sampleid,"b10", "10")) %>%
  mutate(sampleid = str_replace(sampleid,"b20", "20")) %>%
  mutate(sampleid = str_replace(sampleid,"b30", "30")) %>%
  mutate(sampleid = str_replace(sampleid,"b40", "40")) %>%
  mutate(sampleid = str_replace(sampleid,"b50", "50")) %>%
  mutate(sampleid = str_replace(sampleid,"b60", "60")) %>%
  mutate(sampleid = str_replace(sampleid,"b70", "70")) %>%
  mutate(sampleid = str_replace(sampleid,"b80", "80")) %>%
  mutate(sampleid = str_replace(sampleid,"b90", "90")) %>%
  mutate(sampleid = str_replace(sampleid,"b100", "100"))


df0_stat$sampleid<-as.integer(df0_stat$sampleid)
df0_stat <- df0_stat[order(df0_stat$sampleid),]

g0 <- ggplot(data=df0_stat,aes(x=as.factor(sampleid),y=ok_rate)) +
  geom_col() +
  geom_hline(yintercept = 0.8, linetype = "dashed", color = "red") +
  scale_y_continuous(limits = c(0,1), expand = expansion(mult = c(0, 0)), breaks = seq(0, 1, 0.2)) +
  xlab("insertion bias") +
  ylab("successful invasions")

plot(g0)


df<-read.table("2023_03_07_Simulation_0_exploration", fill = TRUE, sep = "\t")
names(df)<-c("rep", "gen", "popstat", "spacer_1", "fwte", "avw", "min_w", "avtes", "avpopfreq",
             "fixed","spacer_2", "phase", "fwcli", "avcli", "fixcli", "spacer_3",
             "avbias","3tot", "3cluster","spacer_4", "sampleid")

df$phase <- factor(df$phase, levels=c("rapi", "trig", "shot", "inac"))
df$sampleid <- factor(df$sampleid, levels=c("b50", "b25", "b0","bm25", "bm50"))


g<-ggplot()+
  geom_line(data=df,aes(x=gen,y=avtes,group=rep,color=phase), alpha = 1, linewidth = 0.7)+
  xlab("generation")+
  ylab("TEs insertions per diploid individual")+
  theme(legend.position="none")+
  scale_colour_manual(values=p)+
  facet_wrap(~sampleid, labeller = labeller(sampleid = 
                                              c("b0" = "bias = 0",
                                                "b25" = "bias = 25",
                                                "b50" = "bias = 50",
                                                "bm25" = "bias = -25",
                                                "bm50" = "bias = -50")))

plot(g)


#Divide in shot and inact pahses
df1 <- subset(df, phase %in% c("shot", "inac"))
df2 <- data.frame()

#new dataframe with only the first shotgun & the first inactive phase of each replicate
repcheck = 1
x = 1
y = 1
while (x<nrow(df1)) {
  if (repcheck != df1[x, 1]){
    y = 1
  }
  if (y == 1){
    if(df1[x, 12]  == "shot"){
      df2<-rbind(df2,df1[x,])
      y = 2
      repcheck = df1[x, 1]
    }
  }
  if (y == 2){
    if(df1[x, 12] == "inac"){
      df2<-rbind(df2,df1[x,])
      y = 1
    }
  }
  x = x+1
}

#Summary statistics
df2<-select (df2,-c(22))

df_count <- df2 %>%
  dplyr::count(sampleid, phase)

df_summary <- df2 %>% 
  dplyr::group_by(sampleid, phase) %>%
  dplyr::summarize(av_fwcli = mean(fwcli), sd_fwcli = sd(fwcli),
                   av_cli = mean(avcli), sd_cli = sd(avcli), cv_cli_percent = sd(avcli)/mean(avcli),
                   av_tes = mean(avtes), sd_tes = sd(avtes), cv_tes_percent = sd(avtes)/mean(avtes),
                   length_previous_phase = mean(gen),
                   sd_gen_phases = sd(gen))

df_summary <- cbind(df_count$n, df_summary)
colnames(df_summary)[1] ="n"

#CI 95%: z* sd/sqrt(population)
df_summary$ci_fwcli <- qt(0.975,df=df_summary$n-1)*(df_summary$sd_fwcli/sqrt(df_summary$n))
df_summary$ci_cli <- qt(0.975,df=df_summary$n-1)*(df_summary$sd_cli/sqrt(df_summary$n))
df_summary$ci_tes <- qt(0.975,df=df_summary$n-1)*(df_summary$sd_tes/sqrt(df_summary$n))

#Average TE insertions per individual shot and inac phases
g_avtes <- ggplot(df_summary, aes(x=phase, y=av_tes, fill = phase)) + 
  geom_bar(stat = "identity") +
  geom_errorbar( aes(x=phase, ymin=av_tes-sd_tes, ymax=av_tes+sd_tes), width=0.2, colour="black", alpha=0.9, size=0.8)+
  ylab("insertions per individual")+
  xlab("phase")+
  theme(legend.position = "none")+
  scale_y_continuous(expand = expansion(mult = c(0, 0.01)))+
  scale_fill_manual(values = c("#ffd700", "#d73027"))+
  facet_wrap(~sampleid, labeller = labeller(sampleid = 
                                              c("b0" = "bias = 0",
                                                "b25" = "bias = 25",
                                                "b50" = "bias = 50",
                                                "bm25" = "bias = -25",
                                                "bm50" = "bias = -50")))


plot(g_avtes)

# Average cluster insertions per individual shot and inac phases
g_avcli <- ggplot(df_summary, aes(x=phase, y=av_cli, fill = phase)) + 
  geom_bar(stat = "identity") +
  geom_errorbar( aes(x=phase, ymin=av_cli-sd_cli, ymax=av_cli+sd_cli), width=0.2, colour="black", alpha=0.9, size=0.8)+
  ylab("insertions per individual")+
  xlab("phase")+
  theme(legend.position = "none")+
  scale_y_continuous(expand = expansion(mult = c(0, 0.01)))+
  scale_fill_manual(values = c("#ffd700", "#d73027"))+
  facet_wrap(~sampleid, labeller = labeller(sampleid = 
                                              c("b0" = "bias = 0",
                                                "b25" = "bias = 25",
                                                "b50" = "bias = 50",
                                                "bm25" = "bias = -25",
                                                "bm50" = "bias = -50")))

plot(g_avcli)

g_bar_av_TEs <- ggplot(df2, aes(x=sampleid, y=avtes)) + 
  geom_boxplot() +
  ggtitle("insertions at 5000 generations")+
  ylab("ins. per individual") +
  xlab("insertion bias")+
  theme(legend.position="none",
        axis.text.x = element_text(size=14),
        axis.text.y = element_text(size=14),
        axis.title.x = element_text(size=14),
        axis.title.y = element_text(size=14),
        strip.text = element_text(size = 14))

plot(g_bar_av_TEs)

g_bar_av_cli <- ggplot(df2, aes(x=sampleid, y=avcli)) + 
  geom_boxplot() +
  ggtitle("cluseter insertions at 5000 generations") +
  ylab("cluseter ins. per individual") +
  xlab("insertion bias") +
  theme(legend.position="none",
        axis.text.x = element_text(size=14),
        axis.text.y = element_text(size=14),
        axis.title.x = element_text(size=14),
        axis.title.y = element_text(size=14),
        strip.text = element_text(size = 14))

plot(g_bar_av_cli)
