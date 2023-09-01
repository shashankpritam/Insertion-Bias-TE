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
  - [<span class="toc-section-number">3.2</span> Plot](#plot)
- [<span class="toc-section-number">4</span> Conclusion](#conclusion)

## Introduction

What is the impact of insertion bias on the minimum fitness of a
population during the invasion of transposable elements (TEs)?

### Initial conditions

## Materials & Methods

version: invadego0.1.3

### Commands for the simulation

The simulations were generated using the code from:

- [sim_storm.py](./Simulation-Results_Files/simulation_storm/minfit/sim_storm.py)

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
df <- read_delim('./23thAug23at110646PM/combined.txt', delim='\t', col_names = column_names)
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

### Plot

<details>
<summary>Code</summary>

``` r
# Convert sampleid to % of the genome (given that genome size is 10,000 kb)
df_gen_5000$sampleid_percent = (df_gen_5000$sampleid / 10000) * 100

# Custom color breaks and colors for fitness
breaks = c(0.01, 0.1, 0.33, 0.66, 1)
colors = c("white", "red", "yellow", "lightgreen", "green")

# Update ggplot
g_avbias_cluster_size <- ggplot(df_gen_5000, aes(x = sampleid_percent, y = avbias, color = min_w)) +
  geom_point(alpha = 0.7, size = 0.8) +
  ylab("Average Bias in TE Insertion") +
  xlab("Cluster Size (% of 10 Mb Genome)") +
  labs(
    title = "Cluster Size (% of 10 Mb Genome) vs Average Bias at gen 5000",
    subtitle = "Different values of minimum fitness of the population represented by colors"
  ) +
  scale_color_gradientn(
    name = "Minimum fitness of the population",
    breaks = breaks,
    colors = colors
  ) +
  scale_x_log10(
    breaks = c(0.001, 0.01, 0.1, 1, 10),
    labels = c("0.001%", "0.01%", "0.1%", "1%", "10%")
  ) +  
  theme_minimal() +
  theme(
    legend.position = "bottom", 
    panel.background = element_rect(fill = "grey90")
  )

# Save the plot
ggsave(filename = "../../../images/minimum_fitness.jpg", plot = g_avbias_cluster_size, width = 10, height = 6)

# To display the saved image in R 
library(grid)

# Read the saved plot into a grob
plot_grob <- ggplotGrob(g_avbias_cluster_size)

# Draw the grob
grid.draw(plot_grob)
```

</details>

![minimum_fitness](./images/minimum_fitness.jpg)

## Conclusion

In the above diagram, we have a fixed transposition rate of 0.2.

Previously, it has been shown by Kofler[2020] that [piRNA Clusters Need a Minimum Size to Control Transposable Element Invasions](https://doi.org/10.1093/gbe/evaa064), and with small sized population, piRNA clusters may need to make up as much as 3% of the genome, given there is a high rate of transposition alongside with recessive TE insertions. 

Here, we observe that the compensation for lower cluster size comes through increased insertion bias. 







 <cite><a href="https://doi.org/10.1093/gbe/evaa064">Robert Kofler, "piRNA Clusters Need a Minimum Size to Control Transposable Element Invasions," Genome Biology and Evolution, Volume 12, Issue 5, May 2020, Pages 736–749</a></cite>





It is quite clear that the population fitness increases with cluster
size and avergae bias. Even with maximum cluster size negative bias
results in extinction. Similar observation for the bias is also apparent
from the graph - we need to have minimum cluster size with strong bias
for the population to survive.
