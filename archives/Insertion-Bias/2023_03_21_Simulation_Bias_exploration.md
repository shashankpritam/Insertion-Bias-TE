2023-03-21-Simulation-Bias-Exploration
================
Shashank
2023-03-21

## Introduction

With this simulation we wanted to understand the impact of the insertion
bias on the transposable elements invasion dynamics.

### Initial conditions:

A population of 1000, 5 chromosomes of size 10 Mb, 5 piRNA clusters of
size 300 Kb and an initial number of TEs in the population equal to 1000.

We used 1000 replicates for the establishment probability simulation.


## Materials & Methods

version: invadego-insertionbias

-   seed bm100:

-   seed bm90:

-   seed bm80:

-   seed bm70:

-   seed bm60:

-   seed bm50:

-   seed bm40:

-   seed bm30:

-   seed bm20:

-   seed bm10:

-   seed b0:

-   seed b10:

-   seed b20:

-   seed b30:

-   seed b40:

-   seed b50:

-   seed b60:

-   seed b70:

-   seed b80:

-   seed b90:

-   seed b100:

### Commands for the simulation:

``` bash
tool="./main"
folder="Simulation-Results/Insertion-Bias/Simulation_IB"


$tool --N 1000 --gen 500 --genome mb:10,10,10,10,10 --cluster kb:300,300,300,300,300 --rr 4,4,4,4,4 --rep 1000 --u 0.1 --basepop "1000(-100)" --steps 500 --sampleid mb100 > $folder/2023_03_21_simulation_0_m100_500gen &
$tool --N 1000 --gen 500 --genome mb:10,10,10,10,10 --cluster kb:300,300,300,300,300 --rr 4,4,4,4,4 --rep 1000 --u 0.1 --basepop "1000(-90)" --steps 500 --sampleid mb90 > $folder/2023_03_21_simulation_0_m90_500gen &
$tool --N 1000 --gen 500 --genome mb:10,10,10,10,10 --cluster kb:300,300,300,300,300 --rr 4,4,4,4,4 --rep 1000 --u 0.1 --basepop "1000(-80)" --steps 500 --sampleid mb80 > $folder/2023_03_21_simulation_0_m80_500gen &
$tool --N 1000 --gen 500 --genome mb:10,10,10,10,10 --cluster kb:300,300,300,300,300 --rr 4,4,4,4,4 --rep 1000 --u 0.1 --basepop "1000(-70)" --steps 500 --sampleid mb70 > $folder/2023_03_21_simulation_0_m70_500gen &
$tool --N 1000 --gen 500 --genome mb:10,10,10,10,10 --cluster kb:300,300,300,300,300 --rr 4,4,4,4,4 --rep 1000 --u 0.1 --basepop "1000(-60)" --steps 500 --sampleid mb60 > $folder/2023_03_21_simulation_0_m60_500gen &
$tool --N 1000 --gen 500 --genome mb:10,10,10,10,10 --cluster kb:300,300,300,300,300 --rr 4,4,4,4,4 --rep 1000 --u 0.1 --basepop "1000(-50)" --steps 500 --sampleid mb50 > $folder/2023_03_21_simulation_0_m50_500gen &
$tool --N 1000 --gen 500 --genome mb:10,10,10,10,10 --cluster kb:300,300,300,300,300 --rr 4,4,4,4,4 --rep 1000 --u 0.1 --basepop "1000(-40)" --steps 500 --sampleid mb40 > $folder/2023_03_21_simulation_0_m40_500gen &
$tool --N 1000 --gen 500 --genome mb:10,10,10,10,10 --cluster kb:300,300,300,300,300 --rr 4,4,4,4,4 --rep 1000 --u 0.1 --basepop "1000(-30)" --steps 500 --sampleid mb30 > $folder/2023_03_21_simulation_0_m30_500gen &
$tool --N 1000 --gen 500 --genome mb:10,10,10,10,10 --cluster kb:300,300,300,300,300 --rr 4,4,4,4,4 --rep 1000 --u 0.1 --basepop "1000(-20)" --steps 500 --sampleid mb20 > $folder/2023_03_21_simulation_0_m20_500gen &
$tool --N 1000 --gen 500 --genome mb:10,10,10,10,10 --cluster kb:300,300,300,300,300 --rr 4,4,4,4,4 --rep 1000 --u 0.1 --basepop "1000(-10)" --steps 500 --sampleid mb10 > $folder/2023_03_21_simulation_0_m10_500gen &
$tool --N 1000 --gen 500 --genome mb:10,10,10,10,10 --cluster kb:300,300,300,300,300 --rr 4,4,4,4,4 --rep 1000 --u 0.1 --basepop "1000(0)" --steps 500 --sampleid b0 > $folder/2023_03_21_simulation_0_0_500gen &
$tool --N 1000 --gen 500 --genome mb:10,10,10,10,10 --cluster kb:300,300,300,300,300 --rr 4,4,4,4,4 --rep 1000 --u 0.1 --basepop "1000(10)" --steps 500 --sampleid b10 > $folder/2023_03_21_simulation_0_10_500gen &
$tool --N 1000 --gen 500 --genome mb:10,10,10,10,10 --cluster kb:300,300,300,300,300 --rr 4,4,4,4,4 --rep 1000 --u 0.1 --basepop "1000(20)" --steps 500 --sampleid b20 > $folder/2023_03_21_simulation_0_20_500gen &
$tool --N 1000 --gen 500 --genome mb:10,10,10,10,10 --cluster kb:300,300,300,300,300 --rr 4,4,4,4,4 --rep 1000 --u 0.1 --basepop "1000(30)" --steps 500 --sampleid b30 > $folder/2023_03_21_simulation_0_30_500gen &
$tool --N 1000 --gen 500 --genome mb:10,10,10,10,10 --cluster kb:300,300,300,300,300 --rr 4,4,4,4,4 --rep 1000 --u 0.1 --basepop "1000(40)" --steps 500 --sampleid b40 > $folder/2023_03_21_simulation_0_40_500gen &
$tool --N 1000 --gen 500 --genome mb:10,10,10,10,10 --cluster kb:300,300,300,300,300 --rr 4,4,4,4,4 --rep 1000 --u 0.1 --basepop "1000(50)" --steps 500 --sampleid b50 > $folder/2023_03_21_simulation_0_50_500gen &
$tool --N 1000 --gen 500 --genome mb:10,10,10,10,10 --cluster kb:300,300,300,300,300 --rr 4,4,4,4,4 --rep 1000 --u 0.1 --basepop "1000(60)" --steps 500 --sampleid b60 > $folder/2023_03_21_simulation_0_60_500gen &
$tool --N 1000 --gen 500 --genome mb:10,10,10,10,10 --cluster kb:300,300,300,300,300 --rr 4,4,4,4,4 --rep 1000 --u 0.1 --basepop "1000(70)" --steps 500 --sampleid b70 > $folder/2023_03_21_simulation_0_70_500gen &
$tool --N 1000 --gen 500 --genome mb:10,10,10,10,10 --cluster kb:300,300,300,300,300 --rr 4,4,4,4,4 --rep 1000 --u 0.1 --basepop "1000(80)" --steps 500 --sampleid b80 > $folder/2023_03_21_simulation_0_80_500gen &
$tool --N 1000 --gen 500 --genome mb:10,10,10,10,10 --cluster kb:300,300,300,300,300 --rr 4,4,4,4,4 --rep 1000 --u 0.1 --basepop "1000(90)" --steps 500 --sampleid b90 > $folder/2023_03_21_simulation_0_90_500gen &
$tool --N 1000 --gen 500 --genome mb:10,10,10,10,10 --cluster kb:300,300,300,300,300 --rr 4,4,4,4,4 --rep 1000 --u 0.1 --basepop "1000(100)" --steps 500 --sampleid b100 > $folder/2023_03_21_simulation_0_100_500gen

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

```

<img src="images/2023_02_21_Validation_IB_1.png" alt="IB 1">

### Visualization in R


``` r

df0_stat$sampleid<-as.integer(df0_stat$sampleid)
```

<img src="images/2023_02_21_Validation_IB_2.png" alt="IB 2">

``` r
# Divide in shot and inact pahses
                   ```

    ## `summarise()` has grouped output by 'sampleid'. You can override using the
    ## `.groups` argument.

``` r
df_summary <- cbind(df_count$n, df_summary)

```

<img src="images/2023_02_21_Validation_IB_3.png" alt="IB 3">

``` r
# Average cluster insertions per individual shot and inac phases
g_avcli <- ggplot(df_summary, aes(x=phase, y=av_cli, fill = phase)) + 
  geom_bar(stat = "identity") +
  geom_errorbar( aes(x=phase, ymin=av_cli-sd_cli, ymax=av_cli+sd_cli), width=0.2, colour="black", alpha=0.9, size=0.8)+
  ylab("cluster insertions per individual")+
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
```

<img src="images/2023_02_21_Validation_IB_4.png" alt="IB 4">

``` r
# Average cluster insertions per individual shot and inac phases
```

<img src="images/2023_02_21_Validation_IB_5.png" alt="IB 5">

``` r
g_bar_av_cli <- ggplot(df2, aes(x=sampleid, y=avcli)) + 
```

<img src="images/2023_02_21_Validation_IB_6.png" alt="IB 6">

## Conclusions

<del>-   The insertion bias affects the probability of a successful invasion
    establishment.

<del>-   The average number of insertions are affected by insertion bias.

<del>-   The average number of cluster insertions is not affected by the
    insertion bias.