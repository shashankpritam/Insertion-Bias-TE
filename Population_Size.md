# Population_Size
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
  - [<span class="toc-section-number">3.1</span> Setting the
    environment](#setting-the-environment)

## Introduction

In this simulation we explore the question - How does a species adapt to
Transposable Element (TE) invasion across dynamic population sizes due
to annual cycles and geographical variations?

## Materials & Methods

version: invadego0.1.3

### Commands for the simulation

The simulations were generated using the code from:

- [sim_storm.py](./Simulation-Results_Files/simulation_storm/minfit/sim_storm.py)

### Parameters

Simulations were ran with the following parameters:

- Number of simulations: 10000
- Number of threads: 4
- Number of replications (–rep): 1
- Transposition rate (–u): 0.2
- Number of steps (–steps): 5000
- Population size (–N): Variable
- Number of generations (–gen): 5000
- Negative effect of a TE insertion (–x): 0.01
- Genome (–genome) mb:10,10,10,10,10
- Recombination Rate (–rr): 4,4,4,4,4
- Negative effect of a cluster insertions (-no-x-cluins, i.e, x=0)
- Silent mode: True

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

### Setting the environment

<details>
<summary>Code</summary>

``` r
library(tidyverse)
library(ggplot2)
library(readr)
library(animation)
theme_set(theme_bw())
```

</details>
<details>
<summary>Code</summary>

``` r
simulation_folder_path <- "/Users/shashankpritam/github/Insertion-Bias-TE/Simulation-Results_Files/simulation_storm/popvar/10thDec2023at072107PM/"

month_folders <- c("January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December")


load_month_data <- function(folder_path, month) {
  # Define column names
  column_names <- c("rep", "gen", "popstat", "spacer_1", "fwte", "avw", "min_w", "avtes", "avpopfreq", "fixed", "spacer_2", "phase", "fwcli", "avcli", "fixcli", "spacer_3", "avbias", "3tot", "3cluster", "spacer_4", "sampleid")
  
  # Construct the file path
  file_path <- paste0(folder_path, month, "/combined.txt")

  # Read the data
  df <- read_delim(file_path, delim = '\t', col_names = column_names, show_col_types = FALSE)

  # Convert necessary columns to numeric
  numeric_columns <- c("rep", "gen", "fwte", "avw", "min_w", "avtes", "avpopfreq", "fixed", "fwcli", "avcli", "fixcli", "avbias", "sampleid")
  df[numeric_columns] <- lapply(df[numeric_columns], as.numeric)

  # Create the sampleid_percent column
  df <- df %>%
        mutate(sampleid_percent = (sampleid / 10000) * 100)

  return(df)
}
```

</details>
<details>
<summary>Code</summary>

``` r
plot_data <- function(df, month, u_value) {
  ggplot(df, aes(x = sampleid_percent, y = avbias, color = min_w)) +
    geom_point(alpha = 1.2, size = 2.5) +
    ylab("Average Bias in TE Insertion") +
    xlab("Cluster Size (% of 10 Mb Genome)") +
    labs(
      title = paste("Cluster Size vs Average Bias -", month),
      subtitle = paste("Transposition rate (–u):", u_value)
    ) +
    theme_minimal() +
    scale_color_gradientn(
      name = "Minimum Fitness of the Population",
      breaks = c(0.01, 0.1, 0.33, 0.66, 1),
      colors = c("darkred", "red", "yellow", "lightgreen", "green")
    ) +
    scale_x_log10() +
    theme(legend.position = "bottom")
}
```

</details>
<details>
<summary>Code</summary>

``` r
u_value <- 0.02

# Create the plots and save them as individual image files
for (month in month_folders) {
  df <- load_month_data(simulation_folder_path, month)
  plot <- plot_data(df, month, u_value)
  
  # Save the plot
  ggsave(paste0("images/pop_var_", month, ".jpg"), plot, width = 10, height = 8)
}
```

</details>

    Warning: Removed 11 rows containing missing values (`geom_point()`).

    Warning: Removed 7 rows containing missing values (`geom_point()`).

    Warning: Removed 6 rows containing missing values (`geom_point()`).

    Warning: Removed 7 rows containing missing values (`geom_point()`).
    Removed 7 rows containing missing values (`geom_point()`).

    Warning: Removed 9 rows containing missing values (`geom_point()`).

    Warning: Removed 7 rows containing missing values (`geom_point()`).

    Warning: Removed 6 rows containing missing values (`geom_point()`).

    Warning: Removed 3 rows containing missing values (`geom_point()`).

    Warning: Removed 2 rows containing missing values (`geom_point()`).

    Warning: Removed 3 rows containing missing values (`geom_point()`).

    Warning: Removed 7 rows containing missing values (`geom_point()`).

<details>
<summary>Code</summary>

``` r
# Create a string with the sorted image filenames
image_files <- paste0("images/pop_var_", month_folders, ".jpg")
image_files_str <- paste(image_files, collapse = " ")

# Create the GIF with the images in the correct order
system(paste("convert -delay 100 -loop 0", image_files_str, "images/pop_var.gif"))
```

</details>
<html>
<body>
<h2>
Population Variation Plots
</h2>

<img src="images/pop_var_January.jpg" alt="January">
<img src="images/pop_var_February.jpg" alt="February">
<img src="images/pop_var_March.jpg" alt="March">
<img src="images/pop_var_April.jpg" alt="April">
<img src="images/pop_var_May.jpg" alt="May">
<img src="images/pop_var_June.jpg" alt="June">
<img src="images/pop_var_July.jpg" alt="July">
<img src="images/pop_var_August.jpg" alt="August">
<img src="images/pop_var_September.jpg" alt="September">
<img src="images/pop_var_October.jpg" alt="October">
<img src="images/pop_var_November.jpg" alt="November">
<img src="images/pop_var_December.jpg" alt="December">

<img src="images/pop_var.gif" alt="Annual Variation">
</body>
</html>
