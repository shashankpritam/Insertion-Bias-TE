# Minimum Fitness
Shashank Pritam

- [<span class="toc-section-number">1</span>
  Introduction](#introduction)
  - [<span class="toc-section-number">1.1</span> Initial
    conditions](#initial-conditions)
- [<span class="toc-section-number">2</span> Materials &
  Methods](#materials-methods)
  - [<span class="toc-section-number">2.1</span> Commands for the
    simulation](#commands-for-the-simulation)
- [<span class="toc-section-number">3</span> Visualization in
  R](#visualization-in-r)
  - [<span class="toc-section-number">3.1</span> Data
    Loading](#data-loading)
  - [<span class="toc-section-number">3.2</span> Plot 1](#plot-1)
- [<span class="toc-section-number">4</span> Conclusion](#conclusion)

## Introduction

What is the impact of insertion bias on the minimum fitness of a
population during the invasion of transposable elements (TEs), within
the parameter space of bias and cluster size?

### Initial conditions

## Materials & Methods

version: invadego0.1.3

### Commands for the simulation

The simulations were generated using the code from:

- [sim_storm.py](./Simulation-Results_Files/simulation_storm/sim_storm.py)

## Visualization in R

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
    ✔ ggplot2   3.4.3     ✔ tibble    3.2.1
    ✔ lubridate 1.9.2     ✔ tidyr     1.3.0
    ✔ purrr     1.0.2     
    ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
    ✖ dplyr::filter() masks stats::filter()
    ✖ dplyr::lag()    masks stats::lag()
    ℹ Use the conflicted package (<http://conflicted.r-lib.org/>) to force all conflicts to become errors

<details>
<summary>Code</summary>

``` r
library(ggplot2)
theme_set(theme_bw())
```

</details>

#### Data loading and parsing

<details>
<summary>Code</summary>

``` r
# Define and load DataFrame with column names
column_names <- c("rep", "gen", "popstat", "spacer_1", "fwte", "avw", "min_w", "avtes", "avpopfreq", "fixed", "spacer_2", "phase", "fwcli", "avcli", "fixcli", "spacer_3", "avbias", "3tot", "3cluster", "spacer_4", "sampleid")
df <- read_delim('/home/shashankp/Documents/Insertion-Bias-TE/Simulation-Results_Files/simulation_storm/23thAug23at110646PM/combined.txt', delim='\t', col_names = column_names)
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

### Data Loading

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
```

</details>

### Plot 1

<details>
<summary>Code</summary>

``` r
# Plotting Minimum Fitness
g_avbias_cluster_size <- ggplot(df_gen_5000, aes(x = avbias, y = sampleid, color = min_w)) +
  geom_point(alpha = 0.7, size = 0.8) +
  ylab("Cluster Size (in kb)") +
  xlab("Average Bias in TE Insertion") +
  labs(
    title = "Cluster Size (in kb) vs Average Bias at gen 5000",
    subtitle = "Different values of minimum fitness of the population represented by colors"
  ) +
  scale_color_gradient2(
    name = "Minimum fitness of the population",
    low = "red", 
    mid = "orange", 
    high = "blue", 
    midpoint = median(df_gen_5000$min_w, na.rm = TRUE)
  ) +
  theme_minimal() +
  theme(
    legend.position = "bottom", 
    panel.background = element_rect(fill = "grey90")
  )

# Display the plot
print(g_avbias_cluster_size)
```

</details>

![](sim_storm_minm_fit_files/figure-commonmark/unnamed-chunk-4-1.png)

<details>
<summary>Code</summary>

``` r
# Scatter plot of min_w vs sampleid with points colored by avbias and a vertical line at 300, on a log scale
ggplot(df_gen_5000, aes(x = sampleid, y = min_w)) +
  geom_point(aes(color = avbias), alpha = 0.7, size = 0.8) +
  scale_color_viridis_c(name = "Average Bias", option = "inferno") +
  scale_x_log10(
    name = "Cluster Size (in kb, log scale)",
    breaks = scales::trans_breaks("log10", function(x) 10^x),
    labels = scales::trans_format("log10", scales::math_format(10^.x))
  ) +
  ylab("Minimum Fitness of the Population") +
  labs(
    title = "Minimum Fitness vs Cluster Size (in kb) at gen 5000",
  ) +
  theme_minimal() +
  theme(panel.background = element_rect(fill = "grey90"))
```

</details>

![](sim_storm_minm_fit_files/figure-commonmark/unnamed-chunk-5-1.png)

## Conclusion

It is quite clear that the population fitness increases with cluster
size and avergae bias. Even with maximum cluster size negative bias
results in extinction. Similar observation for the bias is also apparent
from the graph - we need to have minimum cluster size with strong bias
for the population to survive.