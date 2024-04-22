library(duckdb)
library(dplyr)
library(ggplot2)
library(gridExtra)
library(scales)

# Adjust plot theme globally
theme_set(theme_bw(base_size = 14) + 
            theme(text = element_text(family = "serif", face = "plain")))

# Parse the '3tot' column and extract values based on keys
parse_3tot <- function(df, y_col_series, z_col_series) {
  extract_values <- function(series) {
    y_vals <- numeric(length(series))
    z_vals <- numeric(length(series))
    
    for (i in seq_along(series)) {
      parts <- strsplit(as.character(series[i]), ",")[[1]]
      for (part in parts) {
        matches <- regmatches(part, regexec("([0-9.-]+)\\((-?[0-9]+)\\)", part))
        if (length(matches[[1]]) > 1) {
          value <- as.numeric(matches[[1]][2])
          key <- as.integer(matches[[1]][3])
          if (key == y_col_series[i]) {
            y_vals[i] <- value
          } else if (key == z_col_series[i]) {
            z_vals[i] <- value
          }
        }
      }
    }
    
    list(y = y_vals, z = z_vals)
  }
  
  vals <- extract_values(df$`3tot`)
  df %>% mutate(`3tot_y` = vals$y, `3tot_z` = vals$z)
}

# Fetch and process data
fetch_and_process_data <- function(database, rep, gen) {
  print(sprintf("Fetching data for generation %s from %s", gen, database))
  conn <- dbConnect(duckdb::duckdb(), dbdir = database, read_only = TRUE)
  on.exit(dbDisconnect(conn))
  
  df <- dbGetQuery(conn, sprintf("SELECT y, z, '3tot', gen FROM simulations WHERE popstat = 'ok' AND rep = %d AND gen = %d ORDER BY gen;", rep, gen))
  if (nrow(df) > 0) {
    parsed_data <- parse_3tot(df, df$y, df$z)
    summarise(group_by(parsed_data, y, z), `3tot_y` = mean(`3tot_y`, na.rm = TRUE), `3tot_z` = mean(`3tot_z`, na.rm = TRUE))
  } else {
    data.frame()
  }
}

# Plot data for all generations
plot_data <- function(database, output_file) {
  generations <- seq(1, 5000, by = 500)
  plots <- lapply(generations, function(gen) {
    gen_data <- fetch_and_process_data(database, 1, gen)
    if (nrow(gen_data) > 0) {
      ggplot(gen_data, aes(x = z, y = y, fill = (`3tot_y` - `3tot_z`) / (`3tot_y` + `3tot_z`))) +
        geom_tile() +
        scale_fill_gradient2(low = "blue", high = "red", mid = "white", midpoint = 0) +
        labs(title = sprintf("Gen %s", gen))
    } else {
      ggplot() + labs(title = sprintf("Gen %s: No data", gen))
    }
  })
  
  do.call(grid.arrange, c(plots, ncol = 3))
  ggsave(output_file, width = 22, height = 18)
}



# Example usage
database_path <- '/Users/shashankpritam/github/Insertion-Bias-TE/Simulation-Results_Files/simulation_storm/storm/reStorm1.duckdb'
output_file_path <- '/Users/shashankpritam/github/Insertion-Bias-TE/Simulation-Results_Files/simulation_storm/storm/debug_reStorm1.pdf'
plot_data(database_path, output_file_path)

