Validation of Insertion Bias
================
Shashank Pritam


## Introduction

With this simulation we wanted to understand the impact of the insertion
bias on the transposable elements invasion dynamics.

### Initial conditions:

* A population of 1000, 5 chromosomes of size 10 Mb, 5 piRNA clusters of size 300 Kb and an initial number of TEs in the population equal to 10.
* We used 1000 replicates for the establishment probability simulation.
* We used 100 replicates for the other simulations.

## Part A

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
  cat "$folder"/*_simulation_* | grep -v "^Invade" | grep -v "^#" > "$folder"/"$(date +%Y_%m_%d)"_Validation_5_bias
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
# Define palettep <- c("#1a9850", "#ffd700", "#d73027")# Read data and set column namesdf0 <- read.table("2023_04_16_Validation_5_bias", fill = TRUE, sep = "\t") names(df0) <- c("rep", "gen", "popstat", "spacer_1", "fwte", "avw", "min_w", "avtes", "avpopfreq",                "fixed", "spacer_2", "phase", "fwcli", "avcli", "fixcli", "spacer_3",                "avbias", "3tot", "3cluster", "spacer_4", "sampleid")# Filter and select columnsdf00 <- subset(df0, gen != 0)df00 <- select(df00, -c(22))# Calculate statisticsdf0_stat <- df00 %>%  group_by(sampleid) %>%  summarize(fail = sum(popstat == "fail-0"),            success = sum(popstat == "ok"),            total = success + fail,            ok_rate = success/total)# Modify sampleid valuesdf0_stat <- df0_stat %>%  mutate(sampleid = str_replace_all(sampleid, c("mb90" = "-90", "mb80" = "-80", "mb70" = "-70", "mb60" = "-60",                                                "mb50" = "-50", "mb40" = "-40", "mb30" = "-30", "mb20" = "-20",                                                "mb10" = "-10", "b90" = "90", "b80" = "80", "b70" = "70",                                                "b60" = "60", "b50" = "50", "b40" = "40", "b30" = "30",                                                "b20" = "20", "b10" = "10", "b0" = "0")))# Convert sampleid to integer and sortdf0_stat$sampleid <- as.integer(df0_stat$sampleid)df0_stat <- df0_stat[order(df0_stat$sampleid),]# Create and plot the graphg0 <- ggplot(data = df0_stat, aes(x = as.factor(sampleid), y = ok_rate, fill = ok_rate)) +  geom_col(show.legend = FALSE) +  geom_hline(yintercept = 0.8, linetype = "dashed", color = "red") +  scale_y_continuous(limits = c(0, 1), expand = expansion(mult = c(0, 0)), breaks = seq(0, 1, 0.2),                     labels = scales::percent) +  scale_x_discrete(labels = setNames(c("-90", "-80", "-70", "-60", "-50", "-40", "-30", "-20", "-10", "0",                                       "10", "20", "30", "40", "50", "60", "70", "80", "90"),                                     unique(df0_stat$sampleid))) +  scale_fill_gradientn(colors = RColorBrewer::brewer.pal(3, "Dark2")) +  xlab("Insertion Bias") +  ylab("Successful Invasions (%)") +  theme_minimal() +  theme(text = element_text(size = 12))plot(g0)
```

<img src="images/2023_04_17_Validation_5a_bias.png" alt="5A.">


## Part B

## Materials & Methods

version: invadego-insertionbias

- seed bm90:
- seed bm80:
- seed bm70:
- seed bm60:
- seed bm50:
- seed bm40:
- seed bm30:
- seed bm20:
- seed bm10:
- seed b0:
- seed b10:
- seed b20:
- seed b30:
- seed b40:
- seed b50:
- seed b60:
- seed b70:
- seed b80:
- seed b90:




version: invadego 0.1.3

### Commands for the simulation:

``` bash
tool="./main"
N=1000
gen=5000
genome="mb:10,10,10,10,10"
cluster="kb:300,300,300,300,300"
rr="4,4,4,4,4"
rep=100
u=0.1
steps=20
folder="Simulation-Results/Insertion-Bias/validation_5.2"

for i in {-9..9}; do
  i=$(($i * 10))

  if (( $i < 0 )); then
    sampleid="bm$(($i * -1))"
  else
    sampleid="b$(($i))"
  fi

  basepop="10($i)"
  output_file="$folder/$(date +%Y_%m_%d)_simulation_0_${sampleid}"
  command="$tool --N $N --gen $gen --genome $genome --cluster $cluster --rr $rr --rep $rep --u $u --basepop \"$basepop\" --steps $steps --sampleid $sampleid > $output_file"
  echo "Running command: $command"
  eval "$command" &
done

# wait for all simulations to finish
wait

# concatenate output files with system date
cat $folder/$*simulation_0_* | grep -v "^Invade" | grep -v "^#" > $folder/$(date +%Y_%m_%d)_Simulation_0_exploration

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





## Conclusions
