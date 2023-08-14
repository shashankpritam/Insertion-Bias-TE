# Simulation Storm
Shashank Pritam

- [<span class="toc-section-number">1</span>
  Introduction](#introduction)
  - [<span class="toc-section-number">1.1</span> Initial
    conditions:](#initial-conditions)
- [<span class="toc-section-number">2</span> Materials &
  Methods](#materials-methods)
  - [<span class="toc-section-number">2.1</span> Commands for the
    simulation:](#commands-for-the-simulation)
  - [<span class="toc-section-number">2.2</span> Visualization in
    R](#visualization-in-r)

## Introduction

With this simulation we wanted to understand the role of insertion bias
on minimum fitness during a TEs invasion.

### Initial conditions:

A population of 1000, 5 chromosomes of size 10 Mb

Every dot in the red to green gradient is a simulation at generation
5000, or less if it failed. If it failed due to the extinction of the
population the dot will be white, if it failed because all TEs were
removed from the population it will be grey.

## Materials & Methods

version: invadego0.1.3

### Commands for the simulation:

The simulations were generated using the code from:

- simstorm_para_vs_selection
- simstorm_para_vs_clusters

### Visualization in R

#### Setting the environment

<details>
<summary>Code</summary>

``` r
library(tidyverse)
```

</details>

    ── Attaching core tidyverse packages ──────────────────────── tidyverse 2.0.0 ──
    ✔ dplyr     1.1.2     ✔ readr     2.1.4
    ✔ forcats   1.0.0     ✔ stringr   1.5.0
    ✔ ggplot2   3.4.2     ✔ tibble    3.2.1
    ✔ lubridate 1.9.2     ✔ tidyr     1.3.0
    ✔ purrr     1.0.1     
    ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
    ✖ dplyr::filter() masks stats::filter()
    ✖ dplyr::lag()    masks stats::lag()
    ℹ Use the conflicted package (<http://conflicted.r-lib.org/>) to force all conflicts to become errors

<details>
<summary>Code</summary>

``` r
library(RColorBrewer)
library(ggplot2)
library(patchwork)
library(dplyr)
theme_set(theme_bw())
```

</details>

#### Data loading and parsing

<details>
<summary>Code</summary>

``` r
# Define and load DataFrame with column names
column_names <- c("rep", "gen", "popstat", "spacer_1", "fwte", "avw", "min_w", "avtes", "avpopfreq", "fixed", "spacer_2", "phase", "fwcli", "avcli", "fixcli", "spacer_3", "avbias", "3tot", "3cluster", "spacer_4", "sampleid")
df <- read_delim('/Users/shashankpritam/github/Insertion-Bias-TE/Simulation-Results_Files/simulation_storm/11thAug23at083124PM/combined.txt', delim='\t', col_names = column_names)
```

</details>

    Rows: 20000 Columns: 22
    ── Column specification ────────────────────────────────────────────────────────
    Delimiter: "\t"
    chr  (8): popstat, spacer_1, spacer_2, phase, spacer_3, 3tot, 3cluster, spac...
    dbl (13): rep, gen, fwte, avw, min_w, avtes, avpopfreq, fixed, fwcli, avcli,...
    lgl  (1): X22

    ℹ Use `spec()` to retrieve the full column specification for this data.
    ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

<details>
<summary>Code</summary>

``` r
# Convert specific columns to numeric
numeric_columns <- c("rep", "gen", "fwte", "avw", "min_w", "avtes", "avpopfreq", "fixed", "fwcli", "avcli", "fixcli", "avbias", "sampleid")
df[numeric_columns] <- lapply(df[numeric_columns], as.numeric)
```

</details>

#### Visualization:

<details>
<summary>Code</summary>

``` r
# Define color gradient functions
color.gradient <- function(x, colors=c("#D7191C","#FDAE61","#A6D96A","#1A9641"), colsteps=100) { colorRampPalette(colors) (colsteps) [ findInterval(x, seq(min(df$min_w),1.0, length.out=colsteps)) ] }

# Assign colors based on the 'min_w' column
df$col <- color.gradient(df$min_w)
df[df$popstat == "fail-0",]$col <- "grey"
df$col <- as.factor(df$col)

# Create and plot the ggplot object
# Subset the data for gen 5000
df_gen_5000 <- df[df$gen == 5000,]

# Plot the ggplot object

g_avbias_phase <- ggplot(df_gen_5000, aes(x = avbias, y = phase, color = phase)) + # Updated the y-axis to phase
  geom_point(alpha = 0.7, size = 0.8) +
  ylab("Phase") + # Updated y-axis label
  xlab("Average Bias as [%]") +
  labs(title = "Phase vs Average Bias at gen 5000",
       subtitle = "Different phases represented by colors",
       caption = "As avbias increases the rapid invasion phase is predominant") +
  theme_minimal() +
  theme(legend.position = "bottom", panel.background = element_rect(fill="grey90"))

# Display the plot
plot(g_avbias_phase)
```

</details>

![](sim_storm_files/figure-commonmark/unnamed-chunk-3-1.png)
