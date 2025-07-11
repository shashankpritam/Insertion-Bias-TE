# Load necessary libraries
library(tidyverse)
library(duckdb)
library(gridExtra)
library(cowplot)

# Define common theme with Helvetica font
common_theme <- function() {
  theme_classic() +  # Start with a classic theme (includes axis lines)
  theme(
    text = element_text(family = "Helvetica"),
    legend.position = "bottom",
    plot.title = element_text(hjust = 0.5, size = 24),
    axis.title = element_text(size = 20),
    axis.text.x = element_text(size = 16, angle = 45, hjust = 1),  # Rotate x-axis labels
    axis.text.y = element_text(size = 16),
    strip.background = element_blank(),  # Remove facet label background
    strip.text = element_text(face = "plain", size = 20),
    axis.line = element_line(color = "black"),
    axis.ticks = element_line(color = "black"),
    panel.background = element_rect(fill = "transparent", colour = NA), # Ensure transparent background
    plot.background = element_rect(fill = "transparent", colour = NA) # Ensure transparent plot area
  )
}

# Define a function to plot metrics
plot_metrics <- function(data) {
  # Define colors and styles
  colors <- c('red', 'green', 'blue')
  line_styles <- c("dotdash", "solid", "dotted")
  lighter_colors <- scales::alpha(colors, 0.2)
  
  # Map for sampleid labels
  bias_map <- c('bm50' = 'Insertion Bias = -50', 'b50' = 'Insertion Bias = 50', 'b0' = 'Insertion Bias = 0')
  sample_order <- c('bm50', 'b0', 'b50')
  
  # Create a plot for each sampleid
  plots <- list()
  for (i in seq_along(sample_order)) {
    sample_id <- sample_order[i]
    group <- data %>% dplyr::filter(sampleid == sample_id)
    p <- ggplot(group, aes(x = gen, y = avg_avw)) +
      geom_line(color = colors[i], linetype = line_styles[i]) +
      geom_ribbon(aes(ymin = avg_avw - stddev_avw, ymax = avg_avw + stddev_avw), fill = lighter_colors[i]) +
      labs(title = bias_map[[sample_id]], x = 'Generation') +
      ylim(0, 1.2) +
      common_theme()

    if (i == 1) {
      p <- p + ylab('Average Fitness of the Population') + theme(axis.title.y = element_text(size = 24))
    } else {
      p <- p + ylab(NULL)
    }
    plots[[i]] <- p
  }
  
  # Combine the plots into a single figure
  plot_combined <- plot_grid(plotlist = plots, nrow = 1, align = 'v')
  
  # Save the combined plot as PDF (default behavior)
  ggsave('Figure_4A.pdf', plot = plot_combined, path = "/Users/shashankpritam/github/Insertion-Bias-TE", device = cairo_pdf, width = 22, height = 8)
  
  # Save as high-quality PNG for the paper
  ggsave('Figure_4A.png', plot = plot_combined, path = "/Users/shashankpritam/github/Insertion-Bias-TE/paper_figure", device = "png", width = 22, height = 8, dpi = 300)
}

# Database connection and data fetching
conn <- dbConnect(duckdb::duckdb(), dbdir = "/Users/shashankpritam/github/Insertion-Bias-TE/Simulation-Results_Files/simulation_storm/fitness_ncs_2/fitness_ncs2.duckdb", read_only = TRUE)
query <- "
WITH data AS (
    SELECT sampleid, gen, AVG(avw) AS avg_avw, STDDEV(avw) AS stddev_avw
    FROM simulations
    WHERE sampleid IN ('b50', 'b0', 'bm50') AND popstat = 'ok'
    GROUP BY sampleid, gen
    ORDER BY sampleid, gen
)
SELECT * FROM data;
"
df <- dbGetQuery(conn, query)

# Plotting
plot_metrics(df)

# Close the database connection
dbDisconnect(conn)
