---
title: "Bias Validation"
output: html_notebook
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
library(ggplot2)
library(readr)
library(dplyr)
library(stringr)
library(purrr)
library(tidyr)
```

# Introduction

This notebook illustrates the data processing and visualization steps. We start by loading necessary libraries, defining some parameters, and then we process the data files. The final part of the notebook presents a bar plot of `avtes` for 21 `sampleid`s.

# Data Processing

This part includes loading and cleaning the data. First, we specify the column names for our data. Then, we define a function `process_file` to read and process each file. 

```{r data-processing, message=FALSE, warning=FALSE}
# Define column names
column_names <- c("rep", "gen", "popstat", "spacer_1", "fwte", "avw", "min_w", "avtes", "avpopfreq",
                  "fixed","spacer_2", "phase", "fwcli", "avcli", "fixcli", "spacer_3",
                  "avbias", "3tot", "3cluster", "spacer_4", "sampleid")

# Define numeric columns
numeric_columns <- c("rep", "gen", "fwte", "avw", "min_w", "avtes", "avpopfreq",
                     "fixed", "fwcli", "avcli", "fixcli",
                     "avbias")

# Define N as the total number of result files
N <- 21

# Create a function to process each file
process_file <- function(i) {
  # Construct filename
  filename <- paste0("result_", i, ".out")
  
  # Read and process the result file
  result <- read_lines(filename) %>% 
    discard(~str_detect(., "^#|^Invade")) %>%  # Remove lines starting with '#' or 'Invade'
    str_split("\\s+", simplify = TRUE) %>%  # Split lines into columns by whitespace
    as_tibble()  # Convert matrix to tibble
  
  # Remove the last column ('sampleids')
  result <- result[,-ncol(result)]
  
  # Set column names
  colnames(result) <- column_names
  
  # Convert numeric columns to appropriate data types
  result <- mutate(result, across(all_of(numeric_columns), as.numeric), .keep = "all")
  
  return(result)
}

# Loop over result files and combine them into a single data frame
result_df <- map_df(seq_len(N), process_file)
```

# Data Visualization

After the data is cleaned, we create a barplot of `avtes` for 21 `sampleid`s.

```{r bias_validation, message=FALSE, warning=FALSE}
ggplot(result_df, aes(x=factor(sampleid), y=avtes)) + 
  geom_bar(stat='identity') + 
  labs(title = "Barplot of 'avtes' for 21 SampleIDs", x = "Sample ID", y = "avtes") +
  theme_minimal()
```
This bar plot gives us insights about ...

# Conclusion

The notebook illustrated how we can efficiently process our data files and generate insightful visualizations. The bar plot gives us an understanding of ...

```{r session-info, echo=FALSE}
sessionInfo()
```


