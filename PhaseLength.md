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
| 0    | b0        | 1705607730979174052 |
| 50   | b50       | 1705607730980408965 |
| -50  | bm50      | 1705607730975817076 |

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
```

</details>

### Load Data and Plot Result

<details class="code-fold">
<summary>Code</summary>

``` r
# Load necessary libraries
p <- c("#1a9850", "#ffd700", "#d73027")

# Set the path of the combined file
combined_file_path <- "Simulation-Results_Files/simulation_storm/phase_len/Phase_Length_Simulation"

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

<details class="code-fold">
<summary>Code</summary>

``` r
g_min <- min(df$avtes, na.rm = TRUE)
g_max <- 1500

plot_diploid <- function(data, title) {
  ggplot(data, aes(x = gen, y = avtes, group = rep, color = phase)) +
    geom_line(alpha = 1, linewidth = 0.7) +
    xlab("Generation") +
    ylab("TE insertions per diploid individual") +
    ggtitle(title) +
    scale_colour_manual(values = p) +
    ylim(g_min, g_max) +  # Normalize y-axis
    theme(
      legend.position = "bottom",
      plot.title = element_text(hjust = 0.5),
      panel.grid.major = element_line(colour = "gray90"),
      panel.grid.minor = element_line(colour = "gray95"),
      strip.background = element_rect(fill = "lightgrey"),
      strip.text = element_text(face = "bold"),
      axis.text.x = element_text(margin = margin(t = 5))  # Increase x-axis margin
    )
}

g1 <- plot_diploid(subset(df, sampleid == "bm50"), "Bias = -50")
g2 <- plot_diploid(subset(df, sampleid == "b0"), "Bias = 0")
g3 <- plot_diploid(subset(df, sampleid == "b50"), "Bias = 50")

combined_plot <- grid.arrange(g1, g2, g3, nrow = 1, widths = c(1, 1, 1))
```

</details>

![](PhaseLength_files/figure-commonmark/unnamed-chunk-4-1.png)

<details class="code-fold">
<summary>Code</summary>

``` r
ggsave((filename = "images/TE_Insertion_Per_Diploid_Individual_Through_Generations.jpg"), plot = combined_plot, width = 16, height = 9, dpi = 600)
```

</details>

![](images/TE_Insertion_Per_Diploid_Individual_Through_Generations.jpg)

#### This plot depicts the average transposon insertion (‘avtes’ represented by the y-axis) as we trace the 100 replications of the diploid organism across 5000 generations.

## Average TE Insertions per Individual

<details class="code-fold">
<summary>Code</summary>

``` r
# Divide in shot and inact phases
df1 <- subset(df, phase %in% c("shot", "inac"))
df2 <- data.frame()

# New dataframe with only the first shotgun & the first inactive phase of each replicate
repcheck <- 1
x <- 1
y <- 1
while (x < nrow(df1)) {
  if (repcheck != df1[x, 1]) {
    y <- 1
  }
  if (y == 1) {
    if (df1[x, 12] == "shot") {
      df2 <- rbind(df2, df1[x,])
      y <- 2
      repcheck <- df1[x, 1]
    }
  }
  if (y == 2) {
    if (df1[x, 12] == "inac") {
      df2 <- rbind(df2, df1[x,])
      y <- 1
    }
  }
  x <- x + 1
}


# Summary statistics
df2 <- select(df2, -c(22))

df_count <- df2 %>%
  dplyr::count(sampleid, phase)
df_summary <- df2 %>%
  dplyr::group_by(sampleid, phase) %>%
  dplyr::summarize(av_fwcli = mean(fwcli), sd_fwcli = sd(fwcli),
                   av_cli = mean(avcli), sd_cli = sd(avcli), cv_cli_percent = sd(avcli) / mean(avcli),
                   av_tes = mean(avtes), sd_tes = sd(avtes), cv_tes_percent = sd(avtes) / mean(avtes),
                   length_previous_phase = mean(gen), sd_length_previous_phase = sd(gen)
                   )


df_summary <- cbind(df_count$n, df_summary)
colnames(df_summary)[1] <- "n"


# CI 95%: z* sd/sqrt(population)
df_summary$ci_fwcli <- qt(0.975, df = df_summary$n - 1) * (df_summary$sd_fwcli / sqrt(df_summary$n))
df_summary$ci_cli <- qt(0.975, df = df_summary$n - 1) * (df_summary$sd_cli / sqrt(df_summary$n))
df_summary$ci_tes <- qt(0.975, df = df_summary$n - 1) * (df_summary$sd_tes / sqrt(df_summary$n))


# Average TE insertions per individual in both phases
plot_diploid <- function(data, title, min_val, max_val) {
  ggplot(data, aes(x = phase, y = av_tes, fill = phase)) +
    geom_bar(stat = "identity") +
    geom_errorbar(aes(x = phase, ymin = av_tes - sd_tes, ymax = av_tes + sd_tes), width = 0.2, colour = "black", alpha = 0.9, size = 0.8) +
    xlab("Phase") +
    ylab("Insertions per individual") +
    scale_x_discrete(labels = c("Rapid", "Shotgun")) +  # Custom x-axis labels
    theme(legend.position = "none",
          plot.title = element_text(hjust = 0.5),
          panel.grid.major = element_line(colour = "gray90"),
          panel.grid.minor = element_line(colour = "gray95"),
          strip.background = element_rect(fill = "lightgrey"),
          strip.text = element_text(face = "bold")) +
    ggtitle(title) +
    scale_y_continuous(limits = c(0, 1000), expand = expansion(mult = c(0, 0.01))) +
    scale_fill_manual(values = c("#1a9850", "#ffd700"))
}


p1 <- plot_diploid(subset(df_summary, sampleid == "bm50"), "Bias = -50")
p2 <- plot_diploid(subset(df_summary, sampleid == "b0"), "Bias = 0")
p3 <- plot_diploid(subset(df_summary, sampleid == "b50"), "Bias = 50")


combined_p_plot <- grid.arrange(p1, p2, p3, nrow = 1, widths = c(1, 1, 1))
```

</details>

![](PhaseLength_files/figure-commonmark/unnamed-chunk-5-1.png)

<details class="code-fold">
<summary>Code</summary>

``` r
ggsave((filename = "images/Average_TE_insertions_per_individual.jpg"), plot = combined_p_plot, width = 16, height = 9, dpi = 600)
```

</details>

![](images/Average_TE_insertions_per_individual.jpg)

#### In our analysis, we identified the first generation displaying both “Shotgun” and “Inactive” phases. To optimize computational resources and time, we utilize these generations as proxies for the preceding generations with “Rapid” and “Shotgun” phases. Following data filtration procedures, we determine the mean values of ‘avtes’ within each generation by calculating their averages. These avtes means are then represented on the y-axis of our plot.

#### This plot displays the average TE (Transposable Element) load at the conclusion of both “Rapid” and “Shotgun” phases. Moreover, the plot reveals a correlation: as the insertion bias increases, there is a corresponding decrease in transposon load, indicating a significant impact of insertion bias on host defense.

## Average Cluster Insertions per Individual

<details class="code-fold">
<summary>Code</summary>

``` r
g_avcli_min <- 0
g_avcli_max <- 8
df_summary$sampleid <- factor(df_summary$sampleid, levels = c("bm50", "b0", "b50"))

g_avcli <- ggplot(df_summary, aes(x = phase, y = av_cli, fill = phase)) +
  geom_bar(stat = "identity") +
  geom_errorbar(aes(x = phase, ymin = av_cli - sd_cli, ymax = av_cli + sd_cli), width = 0.2, colour = "black", alpha = 0.9, size = 0.8) +
  ylab("Cluster Insertions per Individual") +
  xlab("Phase") +
  scale_x_discrete(labels = c("Rapid", "Shotgun")) +  # Custom x-axis labels
  ylim(g_avcli_min, g_avcli_max) +  # Normalize y-axis
  theme(legend.position = "none",
        plot.title = element_text(hjust = 0.5),
        panel.grid.major = element_line(colour = "gray90"),
        panel.grid.minor = element_line(colour = "gray95"),
        strip.background = element_rect(fill = "lightgrey"),
        strip.text = element_text(face = "bold")) +
  ggtitle("Bias vs Cluster Insertions") +
  scale_y_continuous(expand = expansion(mult = c(0, 0.01))) +
  scale_fill_manual(values = c("#1a9850", "#ffd700")) + 
  facet_wrap(~sampleid, labeller = labeller(sampleid =
                                             c("bm50" = "bias = -50",
                                              "b0" = "bias = 0",
                                               "b50" = "bias = 50"
                                               
)))


ggsave((filename = "images/Average_Cluster_Insertions_per_Individual.jpg"), plot = g_avcli, width = 16, height = 9, dpi = 600)
```

</details>

![](images/Average_Cluster_Insertions_per_Individual.jpg)

#### mean(avcli) of the first generation of Shotgun and Inactice (Proxies for last generation of Rapid and Shotgun) across 100 replication vs Generation

#### We observe consistent values across different bias values.

## Average Phase Length of Simulations

<details class="code-fold">
<summary>Code</summary>

``` r
g_len <- ggplot(df_summary, aes(x = phase, y = length_previous_phase, fill = phase)) +
  geom_bar(stat = "identity") +
  ylab("Average Length of Phases") +
  xlab("Phase") +
  scale_x_discrete(labels = c("Rapid", "Shotgun")) +  # Custom x-axis labels
  geom_errorbar(aes(x = phase, ymin = length_previous_phase - sd_length_previous_phase, ymax = length_previous_phase + sd_length_previous_phase), 
                width = 0.2, colour = "black", alpha = 0.9, size = 0.8) +
  theme(legend.position = "none",
        plot.title = element_text(hjust = 0.5),
        panel.grid.major = element_line(colour = "gray90"),
        panel.grid.minor = element_line(colour = "gray95"),
        strip.background = element_rect(fill = "lightgrey"),
        strip.text = element_text(face = "bold")) +
  ggtitle("Phase Length") +
  scale_y_continuous(expand = expansion(mult = c(0, 0.01))) +
  scale_fill_manual(values = c("#1a9850", "#ffd700")) + 
  facet_wrap(~sampleid, labeller = labeller(sampleid =
                                             c("bm50" = "bias = -50",
                                              "b0" = "bias = 0",
                                               "b50" = "bias = 50"
                                               
)))


ggsave((filename = "images/Phase_Length.jpg"), plot = g_len, width = 16, height = 9, dpi = 600)
```

</details>

![](images/Phase_Length.jpg)

#### mean(gen) values of the first generation of Shotgun and Inactice (Proxies for last generation of Rapid and Shotgun) across 100 replication vs Generation

#### We observe consistent values across different bias values except bias = 50 has slightly longer Shotgun phase of transposon invasion.
