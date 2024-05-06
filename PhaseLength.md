# Phase Length
Shashank Pritam

- [<span class="toc-section-number">1</span>
  Introduction](#introduction)
- [<span class="toc-section-number">2</span> Materials &
  Methods](#materials--methods)
  - [<span class="toc-section-number">2.1</span> Commands for the
    simulation](#commands-for-the-simulation)
  - [<span class="toc-section-number">2.2</span> Seed values for the
    simulation](#seed-values-for-the-simulation)
- [<span class="toc-section-number">3</span> Visualization in
  R](#visualization-in-r)
  - [<span class="toc-section-number">3.1</span> Set the environment by
    loading modules](#set-the-environment-by-loading-modules)
  - [<span class="toc-section-number">3.2</span> Load Data and Plot
    Result](#load-data-and-plot-result)
- [<span class="toc-section-number">4</span> TE Insertion Per Diploid
  Individual Through
  Generations](#te-insertion-per-diploid-individual-through-generations)
- [<span class="toc-section-number">5</span> Average TE Insertions per
  Individual](#average-te-insertions-per-individual)
- [<span class="toc-section-number">6</span> Average Cluster Insertions
  per Individual](#average-cluster-insertions-per-individual)
- [<span class="toc-section-number">7</span> Average Phase Length of
  Simulations](#average-phase-length-of-simulations)

## Introduction

The simulation investigates how bias influences the dynamics of
transposon invasion throughout distinct phases: Rapid, Shotgun, and
Inactive.

## Materials & Methods

version: invadego0.1.3

### Commands for the simulation

<details class="code-fold">
<summary>Code</summary>

``` bash
#!/bin/bash
tool="./main"
N=1000
gen=5000
genome="mb:10,10,10,10,10"
cluster="kb:300,300,300,300,300"
rr="4,4,4,4,4"
rep=100
u=0.1
steps=10
folder="phase_len"

for i in -5 0 5; do
  multiplier=$(( i * 10 ))

  if [ $i -lt 0 ]; then
    sampleid="bm${multiplier#-}"
  else
    sampleid="b${multiplier}"
  fi

  basepop="10($multiplier)"
  output_file="$folder/$(date +%Y_%m_%d)_simulation_0_${sampleid}"

  command="$tool --N $N --gen $gen --genome $genome --cluster $cluster --rr $rr --rep $rep --u $u --basepop \"$basepop\" --steps $steps --sampleid $sampleid > $output_file"
  echo "Running command: $command"
  eval "$command" &
done
```

</details>

### Seed values for the simulation

| Bias | Sample ID | Seed Value          |
|------|-----------|---------------------|
| 0    | b0        | 1710966014330428879 |
| 50   | b50       | 1710966014334456379 |
| -50  | bm50      | 1710966014326260870 |

## Visualization in R

### Set the environment by loading modules

<details class="code-fold">
<summary>Code</summary>

``` r
library(tidyverse)
library(ggplot2)
library(dplyr)
library(ggpubr)
library(gridExtra) 
theme_set(theme_bw())
# Define a common theme
common_theme <- function() {
  theme(
    legend.position = "none",
    plot.title = element_text(hjust = 0.5, size = 24),
    axis.title = element_text(size = 20),
    axis.text.x = element_text(size = 16),
    axis.text.y = element_text(size = 16),
    panel.grid.major = element_line(colour = "gray90"),
    panel.grid.minor = element_line(colour = "gray95"),
    strip.background = element_rect(fill = "lightgrey"),
    strip.text = element_text(face = "bold", size = 20)
  )
}
```

</details>

### Load Data and Plot Result

<details class="code-fold">
<summary>Code</summary>

``` r
# Load necessary libraries
p <- c("#1a9850", "#ffd700", "#d73027")

# Set the path of the combined file
combined_file_path <- "Simulation-Results_Files/simulation_storm/phase_len_2/Phase_Length_Simulation_0_exploration"

# Read the data
df <- read.table(combined_file_path, fill = TRUE, sep = "\t", header = TRUE)

# Rename columns
names(df) <- c("rep", "gen", "popstat", "spacer_1", "fwte", "avw", "min_w", "avtes",
               "avpopfreq","fixed", "spacer_2", "phase", "fwcli", "avcli", "fixcli", "spacer_3", "avbias", "3tot", "3cluster", "spacer_4", "sampleid")

# Convert 'phase' and 'sampleid' to factors with specified levels
df$phase <- factor(df$phase, levels = c("rapi", "shot", "inac"))
df$sampleid <- factor(df$sampleid, levels = c("b0", "b50", "bm50"))
```

</details>

## TE Insertion Per Diploid Individual Through Generations

![](images/TE_Insertion_Per_Diploid_Individual_Through_Generations.jpg)

#### This plot depicts the average transposon insertion (‘avtes’ represented by the y-axis) as we trace the 100 replications of the diploid organism across 5000 generations.

## Average TE Insertions per Individual

![](images/Average_TE_insertions_per_individual.jpg)

#### In our analysis, we identified the first generation displaying both “Shotgun” and “Inactive” phases. To optimize computational resources and time, we utilize these generations as proxies for the preceding generations with “Rapid” and “Shotgun” phases. Following data filtration procedures, we determine the mean values of ‘avtes’ within each generation by calculating their averages. These avtes means are then represented on the y-axis of our plot.

#### This plot displays the average TE (Transposable Element) load at the conclusion of both “Rapid” and “Shotgun” phases. Moreover, the plot reveals a correlation: as the insertion bias increases, there is a corresponding decrease in transposon load, indicating a significant impact of insertion bias on host defense.

## Average Cluster Insertions per Individual

![](images/Average_Cluster_Insertions_per_Individual.jpg)

#### mean(avcli) of the first generation of Shotgun and Inactice (Proxies for last generation of Rapid and Shotgun) across 100 replication vs Generation

#### We observe consistent values across different bias values.

## Average Phase Length of Simulations

![](images/Phase_Length.jpg)

#### mean(gen) values of the first generation of Shotgun and Inactice (Proxies for last generation of Rapid and Shotgun) across 100 replication vs Generation

#### We observe consistent values across different bias values except bias = 50 has slightly longer Shotgun phase of transposon invasion.
