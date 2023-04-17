Validation of Insertion Bias
================
Shashank Pritam


## Introduction

With this simulation we wanted to understand the impact of the insertion
bias on the transposable elements invasion dynamics.

### Initial conditions:

A population of 1000, 5 chromosomes of size 10 Mb, 5 piRNA clusters of
size 300 Kb and an initial number of TEs in the population equal to 10.

We used 1000 replicates for the establishment probability simulation.

We used 100 replicates for the other simulations.

## Materials & Methods

version: invadego-insertionbias

- seed bm90: 1681416686772742525
- seed bm80: 1681416686774110472
- seed bm70: 1681416686775454804
- seed bm60: 1681416686777197238
- seed bm50: 1681416686800571008
- seed bm40: 1681416686781159100
- seed bm30: 1681416686799564808
- seed bm20: 1681416686789184445
- seed bm10: 1681416686852215098
- seed b0: 1681416686895551778
- seed b10: 1681416686901710885
- seed b20: 1681416686922069349
- seed b30: 1681416686945831086
- seed b40: 1681416686916556559
- seed b50: 1681416686923950537
- seed b60: 1681416686979799130
- seed b70: 1681416686963536390
- seed b80: 1681416687018751364
- seed b90: 1681416687027712625




version: invadego 0.1.3

### Commands for the simulation:

``` bash
tool="./main"
N=1000
gen=500
genome="mb:10,10,10,10,10"
cluster="kb:300,300,300,300,300"
rr="4,4,4,4,4"
rep=1000
u=0.1
steps=500
folder="Simulation-Results/Insertion-Bias/validation_5.1"

for i in {-9..9}; do
  i=$(($i * 10))

  if (( $i < 0 )); then
    sampleid="mb$(($i * -1))"
  else
    sampleid="b$(($i))"
  fi

  basepop="10($i)"
  output_file="$folder/$(date +%Y_%m_%d)_simulation_0_m100_500gen_basepop_$i"
  command="$tool --N $N --gen $gen --genome $genome --cluster $cluster --rr $rr --rep $rep --u $u --basepop \"$basepop\" --steps $steps --sampleid $sampleid > $output_file"
  echo "Running command: $command"
  eval "$command" &
done

# wait for all simulations to finish
wait

# concatenate output files with system date
for i in {-9..9}; do
  i=$(($i * 10))
  cat "$folder"/"$(date +%Y_%m_%d)"_simulation_*"$i"* | grep -v "^Invade" | grep -v "^#" > "$folder"/"$(date +%Y_%m_%d)"_Simulation_"$i"_500_gen_exploration
done

```

### Visualization in R

Setting the environment

``` r
library(tidyverse)
library(RColorBrewer)
library(ggpubr)
theme_set(theme_bw())
```

Visualization:

``` r
p<-c("#1a9850","#ffd700","#d73027")

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
```

## Conclusions
