# Load necessary libraries
library(tidyverse)
library(ggplot2)
theme_set(theme_bw())

# Define common theme with Helvetica font
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
  df_final$sampleid_percent <- (df_final$sampleid / 100)  #(BE CAREFUL ABOUT BP VS KB VS MB)
  
  # Filter out fail-0 and fail-w 
  df_filtered = df_final %>% filter(!popstat %in% c("fail-0", "fail-w"))
  
  # Add a new column for transposition rate
  df_final$u <- u_value
  
  # Also add the 'u' column to df_filtered
  df_filtered$u <- u_value
  
  return(list(df_final = df_final, df_filtered = df_filtered))
}


df1 <- load_data('Simulation-Results_Files/simulation_storm/minfit/13thJul24at044203AM/combined.txt', 0.1)


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
      panel.background = element_rect(fill = "grey90")
    ) 
  
  return(plot)
}


plot3 <- plot_data(df1)
ggsave(filename = "images/minimum_fitness_new.jpg", plot = plot3, width = 10, height = 6)
ggsave(filename = "images/minimum_fitness_new.pdf", plot = plot3, width = 10, height = 6, device = "pdf")
