# Load necessary libraries
library(ggplot2)
library(readr)
library(dplyr)
library(stringr)
library(purrr)
library(tidyr)

# Initialize an empty dataframe to store results
result_df <- data.frame()

# Define N as the total number of result files
N <- 21

# Loop over result files
for(i in seq(1, N)) {
  filename <- paste0("result_", i, ".out")
  
  # Read the result file
  result <- read_lines(filename) %>% 
    discard(~str_detect(., "^#|^Invade")) %>%  # Remove lines starting with '#' or 'Invade'
    str_split("\\s+", simplify = TRUE) %>%  # Split lines into columns by whitespace
    as_tibble()  # Convert matrix to tibble
  
  # Remove the last column ('sampleids')
  result <- result[,-ncol(result)]
  
  # Set column names
  colnames(result) <-c("rep", "gen", "popstat", "spacer_1", "fwte", "avw", "min_w", "avtes", "avpopfreq",
                       "fixed","spacer_2", "phase", "fwcli", "avcli", "fixcli", "spacer_3",
                       "avbias",	"3tot",	"3cluster",	"spacer 4", "sampleid")
  
  # Convert columns to appropriate data types
  result <- mutate(result, across(everything(), as.numeric), .keep = "all")
  
  # Append result to result_df
  result_df <- rbind(result_df, result)
}

