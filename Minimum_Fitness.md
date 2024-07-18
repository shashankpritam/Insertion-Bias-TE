# Minimum Fitness
Shashank Pritam

- [<span class="toc-section-number">1</span>
  Introduction](#introduction)
- [<span class="toc-section-number">2</span> Materials &
  Methods](#materials--methods)
  - [<span class="toc-section-number">2.1</span> Commands for the
    simulation](#commands-for-the-simulation)
  - [<span class="toc-section-number">2.2</span>
    Parameters](#parameters)
- [<span class="toc-section-number">3</span> Visualization in
  R](#visualization-in-r)
  - [<span class="toc-section-number">3.1</span> Set the environment by
    loading modules](#set-the-environment-by-loading-modules)
  - [<span class="toc-section-number">3.2</span> Load Data](#load-data)
  - [<span class="toc-section-number">3.3</span> ggplot function to Plot
    Data](#ggplot-function-to-plot-data)
  - [<span class="toc-section-number">3.4</span> Create the
    plots](#create-the-plots)
- [<span class="toc-section-number">4</span> Color Scheme in the
  Plot](#color-scheme-in-the-plot)
  - [<span class="toc-section-number">4.1</span> Variable -
    `min_w`](#variable---min_w)
  - [<span class="toc-section-number">4.2</span> Variables -
    `popstat`](#variables---popstat)
- [<span class="toc-section-number">5</span> Conclusion](#conclusion)

## Introduction

In this simulation we explore the question - What is the impact of
insertion bias on the minimum fitness of a population during the
invasion of transposable elements (TEs)?

## Materials & Methods

version: invadego0.1.3

### Commands for the simulation

The simulations were generated using the code from:

- [sim_storm.py](./Simulation-Results_Files/simulation_storm/minfit/sim_storm.py)

### Parameters

Simulations were ran with the following parameters:

- Number of simulations: 10000
- Number of threads: 64
- Number of replications (–rep): 1
- Transposition rate (–u): 0.1
- Number of steps (–steps): 5000
- Population size (–N): 1000
- Number of generations (–gen): 5000
- Negative effect of a TE insertion (–x): 0.01
- Genome (–genome) mb:10,10,10,10,10
- Recombination Rate (–rr): 4,4,4,4,4
- Silent mode: True

Random Clusters were Generated using this snippet:

<details class="code-fold">
<summary>Code</summary>

``` python
def get_rand_clusters(): 
    lower_limit = math.log10(1e+2)  # Lower bound
    upper_limit = math.log10(1e+7)  # Upper bound
    r = math.floor(10**random.uniform(lower_limit, upper_limit))
    return f"{r},{r},{r},{r},{r}"
```

</details>

## Visualization in R

### Set the environment by loading modules

<details class="code-fold">
<summary>Code</summary>

``` r
library(tidyverse)
library(ggplot2)
theme_set(theme_bw())
common_theme <- function() {
  theme(
    text = element_text(family = "Helvetica"),
    legend.position = "bottom",
    plot.title = element_text(hjust = 0.5, size = 20),
    axis.title = element_text(size = 16),
    axis.text.x = element_text(size = 16, angle = 45, hjust = 1),
    axis.text.y = element_text(size = 16),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    strip.background = element_rect(fill = "lightgrey"),
    strip.text = element_text(face = "bold", size = 20),
    axis.line = element_line(color = "black"),
    axis.ticks = element_line(color = "black"),
    panel.background = element_rect(fill = "white", colour = "white")
  )
}
```

</details>

### Load Data

<details class="code-fold">
<summary>Code</summary>

``` r
load_data <- function(folder_path, u_value) {
  column_names <- c("rep", "gen", "popstat", "spacer_1", "fwte", "avw", "min_w", "avtes", "avpopfreq", "fixed", "spacer_2", "phase", "fwcli", "avcli", "fixcli", "spacer_3", "avbias", "3tot", "3cluster", "spacer_4", "sampleid")
  
  df <- read_delim(folder_path, delim='\t', col_names = column_names, show_col_types = FALSE)
  numeric_columns <- c("rep", "gen", "fwte", "avw", "min_w", "avtes", "avpopfreq", "fixed", "fwcli", "avcli", "fixcli", "avbias", "sampleid")
  df[numeric_columns] <- lapply(df[numeric_columns], as.numeric)
  df_gen_not0 <- df %>% filter(gen != 0)
  df_gen_0 <- df %>% filter(gen == 0)
  
  
  #### Join dataframes
  df_final <- left_join(df_gen_not0, df_gen_0, by = "rep", suffix = c("", "_from_gen0"))
  columns_to_fill <- c("popstat", "avbias", "sampleid", "min_w")
  for (col in columns_to_fill) {
    df_final[[col]] <- ifelse(is.na(df_final[[col]]), df_final[[paste(col, "_from_gen0", sep = "")]], df_final[[col]])
  }
  
  #### Keep only the necessary columns
  df_final <- select(df_final, rep, popstat, avbias, sampleid, min_w)
  
  # Calculate sampleid_percent
  df_final$sampleid_percent <- (df_final$sampleid / 10000000) * 100 # At the time of writing this code the piRNA Cluster was generated in base pairs.
  
  # Filter out fail-0 and fail-w
  df_filtered = df_final %>% filter(!popstat %in% c("fail-0", "fail-w"))
  
  # Add a new column for transposition rate
  df_final$u <- u_value
  
  # Also add the 'u' column to df_filtered
  df_filtered$u <- u_value
  
  return(list(df_final = df_final, df_filtered = df_filtered))
}


df1 <- load_data('/Users/shashankpritam/github/Insertion-Bias-TE/Simulation-Results_Files/simulation_storm/minfit/17thJul24at050214PM/combined.txt', 0.1)
```

</details>

### ggplot function to Plot Data

<details class="code-fold">
<summary>Code</summary>

``` r
plot_data <- function(df_list) {
  df_final = df_list$df_final %>% filter(sampleid_percent > 0.001)
  df_cluster_filtered = df_list$df_filtered %>% filter(sampleid_percent > 0.001)

  breaks <- c(0.01, 0.1, 0.33, 0.66, 1)
  colors <- c("darkred", "red", "yellow", "lightgreen", "green")
  plot <- ggplot(df_cluster_filtered, aes(x = sampleid_percent, y = avbias, color = min_w)) +
    geom_point(alpha = 0.7, size = 0.8) +
    geom_point(data = df_final %>% filter(popstat == "fail-0"), aes(x = sampleid_percent, y = avbias), color = "darkgreen", alpha = 0.7, size = 0.8) +
    geom_point(data = df_final %>% filter(popstat == "fail-w"), aes(x = sampleid_percent, y = avbias), color = "darkgrey", alpha = 0.3, size = 0.75) +
    ylab("Average Bias in TE Insertion") +
    xlab("Cluster Size (% of 10 Mb Genome)") +
    labs(
      title = "Cluster Size (% of 10 Mb Genome) vs Average Bias",
      subtitle = paste("Minimum Fitness by Color | Transposition rate (u):", unique(df_final$u))
    ) +
    scale_color_gradientn(
      name = "Minimum Fitness of the Population",
      breaks = breaks,
      colors = colors
    ) +
    scale_x_log10(
      breaks = c(0.001, 0.01, 0.1, 1, 10, 100),
      labels = c("0.001%", "0.01%", "0.1%", "1%", "10%", "100%")
    ) +
    theme_minimal() +
    theme(
      legend.position = "bottom",
      panel.background = element_rect(fill = "white")
    )  +
    common_theme()
  
  return(plot)
}
```

</details>

### Create the plots

<details class="code-fold">
<summary>Code</summary>

``` r
plot3 <- plot_data(df1)
ggsave(filename = "images/minimum_fitness_new.jpg", plot = plot3, width = 10, height = 6)
ggsave(filename = "images/minimum_fitness_new.pdf", plot = plot3, width = 10, height = 6, device = "pdf")
```

</details>

![New Minimum Fitness at u = 0.1 and -nocluins
off](images/minimum_fitness_new.jpg)

## Color Scheme in the Plot

The color scheme used in the plot serves to represent different
categories and values effectively:

### Variable - `min_w`

For `min_w`, we have used a gradient of colors as follows:

- **Dark Red (0.01)**: Represents $min_{w} < 0.01$
- **Red (0.1)**: Represents $min_{w} < 0.1$
- **Yellow (0.33)**: Represents $min_{w} < 0.33$
- **Green (1)**: Represents $min_{w}= 11$

These colors visually guide the viewer through varying levels of fitness
from lowest to highest.

### Variables - `popstat`

Points where the `popstat` is either “fail-0” or “fail-w”. These are
represented by:

- **Dark Green (`fail-0`)**: Indicates no TEs are left in the
  population.
- **Dark Grey (`fail-w`)**: Indicates that population fitness is too
  low.

## Conclusion

According to Kofler\[2020\], piRNA clusters require a minimum size to
control transposable element invasions. These clusters may comprise up
to 3% of the genome in small populations, especially with high
transposition rates and recessive TE insertions. Here, we observe that
the compensation for lower cluster size comes through increased
insertion bias into the piRNA clusters. The population fitness increases
with cluster size and average bias; negative bias results in extinction
even with a large cluster size.

Another noticeable thing from the plot is that the change in
transposition rate has little effect on population fitness if they have
an appropriate cluster size with a strong enough bias.

------------------------------------------------------------------------

<cite><a href="https://doi.org/10.1093/gbe/evaa064">Robert Kofler,
“piRNA Clusters Need a Minimum Size to Control Transposable Element
Invasions,” Genome Biology and Evolution, Volume 12, Issue 5, May 2020,
Pages 736–749</a></cite>
