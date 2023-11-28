# Phase Length
Shashank Pritam

- [<span class="toc-section-number">1</span>
  Introduction](#introduction)
- [<span class="toc-section-number">2</span> Materials &
  Methods](#materials-methods)
  - [<span class="toc-section-number">2.1</span> Commands for the
    simulation](#commands-for-the-simulation)
  - [<span class="toc-section-number">2.2</span>
    Parameters](#parameters)
- [<span class="toc-section-number">3</span> Visualization in
  R](#visualization-in-r)
  - [<span class="toc-section-number">3.1</span> Set the environment by
    loading modules](#set-the-environment-by-loading-modules)
  - [<span class="toc-section-number">3.2</span> Load Data](#load-data)

## Introduction

In this simulation we explore the question - How does various phases of
invasion change with bias?

## Materials & Methods

version: invadego0.1.3

### Commands for the simulation

The simulations were generated using the code from:

- [sim_storm.py](./Simulation-Results_Files/Slurm-Jobs/sim_storm.py)

### Parameters

Simulations were ran with the following parameters:

- Number of simulations: 10000
- Number of threads: 4
- Number of replications (–rep): 1
- Transposition rate (–u): 0.2
- Number of steps (–steps): 1
- Population size (–N): 1000
- Number of generations (–gen): 5000
- Negative effect of a TE insertion (–x): 0.01
- Genome (–genome) mb:10,10,10,10,10
- Recombination Rate (–rr): 4,4,4,4,4
- Negative effect of a cluster insertions (-no-x-cluins, i.e, x=0)
- Silent mode: False

Random Clusters were Generated using this snippet:

<details>
<summary>Code</summary>

``` python
def get_rand_clusters(): 
    lower_limit = 0  # Lower bound
    upper_limit = math.log10(1e+7)  # Upper bound
    r = math.floor(10**random.uniform(lower_limit, upper_limit))
    return f"{r},{r},{r},{r},{r}"
```

</details>

## Visualization in R

### Set the environment by loading modules

<details>
<summary>Code</summary>

``` r
library(tidyverse)
library(ggplot2)
theme_set(theme_bw())
```

</details>

### Load Data

<details>
<summary>Code</summary>

``` r
library(tidyverse)

# Define column names and numeric columns
column_names <- c("rep", "gen", "popstat", "spacer_1", "fwte", "avw", "min_w", "avtes", "avpopfreq", "fixed", "spacer_2", "phase", "fwcli", "avcli", "fixcli", "spacer_3", "avbias", "3tot", "3cluster", "spacer_4", "sampleid")
numeric_columns <- c("rep", "gen", "fwte", "avw", "min_w", "avtes", "avpopfreq", "fixed", "fwcli", "avcli", "fixcli", "avbias", "sampleid")

# Set the folder path where your txt files are stored
folder_path <- "Simulation-Results_Files/simulation_storm/phaselen/20thNov23at091514PM"

# Read all files into one data frame
all_data <- map_df(0:9999, ~read_delim(file.path(folder_path, paste0(.x, ".txt")), 
                                       delim = '\t', 
                                       col_names = column_names, 
                                       show_col_types = FALSE))

# Convert columns to numeric where necessary
all_data[numeric_columns] <- lapply(all_data[numeric_columns], as.numeric)

# Separate data frames for each phase
data_rapi <- all_data %>% filter(phase == "rapi")
data_shot <- all_data %>% filter(phase == "shot")
data_inac <- all_data %>% filter(phase == "inac")

# Function to plot data for a phase
plot_phase <- function(data, phase_name) {
    data %>% 
        group_by(sampleid) %>%
        summarize(phase_length = n(), 
                  mean_avbias = mean(avbias, na.rm = TRUE)) %>%
        ggplot(aes(x = sampleid, y = phase_length, color = mean_avbias)) +
        geom_point() +
        scale_color_gradient(low = "blue", high = "orange") +
        labs(title = paste("Phase:", phase_name), 
             x = "Pirna Cluster Size", 
             y = "Phase Length") +
        theme_minimal()
}

# Plot for each phase
plot_rapi <- plot_phase(data_rapi, "rapi")
plot_shot <- plot_phase(data_shot, "shot")
plot_inac <- plot_phase(data_inac, "inac")

# Display the plots
plot_rapi
```

</details>

![](PhaseLength_files/figure-commonmark/unnamed-chunk-3-1.png)

<details>
<summary>Code</summary>

``` r
plot_shot
```

</details>

![](PhaseLength_files/figure-commonmark/unnamed-chunk-3-2.png)

<details>
<summary>Code</summary>

``` r
plot_inac
```

</details>

![](PhaseLength_files/figure-commonmark/unnamed-chunk-3-3.png)
