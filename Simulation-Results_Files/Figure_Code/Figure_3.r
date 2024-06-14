library(tidyverse)
library(ggplot2)
library(dplyr)
library(ggpubr)
library(gridExtra) 
library(conflicted)
library(Cairo)  # Make sure the Cairo library is loaded
conflict_prefer("lag", "dplyr")
conflict_prefer("combine", "gridExtra")

theme_set(theme_bw())

common_theme <- function() {
  theme(
    text = element_text(family = "Helvetica"),
    legend.position = "none",
    plot.title = element_text(hjust = 0.5, size = 24),
    axis.title = element_text(size = 20),
    axis.text.x = element_text(size = 16),
    axis.text.y = element_text(size = 16),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    strip.background = element_rect(fill = "lightgrey"),
    strip.text = element_text(face = "bold", size = 20)
  )
}


p <- c("#1a9850", "#ffd700", "#d73027")

# Set the path of the combined file
combined_file_path <- "/Users/shashankpritam/github/Insertion-Bias-TE/Simulation-Results_Files/simulation_storm/phase_len_2/Phase_Length_Simulation_0_exploration"

# Read the data
df <- read.table(combined_file_path, fill = TRUE, sep = "\t", header = TRUE)

# Rename columns
names(df) <- c("rep", "gen", "popstat", "spacer_1", "fwte", "avw", "min_w", "avtes",
               "avpopfreq", "fixed", "spacer_2", "phase", "fwcli", "avcli", "fixcli", "spacer_3", "avbias", "3tot", "3cluster", "spacer_4", "sampleid")

# Convert 'phase' and 'sampleid' to factors with specified levels
df$phase <- factor(df$phase, levels = c("rapi", "shot", "inac"))
df$sampleid <- factor(df$sampleid, levels = c("b0", "b50", "bm50"))


g_min <- min(df$avtes, na.rm = TRUE)
g_max <- 1500

library(ggplot2)
library(gridExtra)

# Updated plot_diploid function with control over y-axis label display
plot_diploid <- function(data, title, show_y_label = FALSE) {
  p <- ggplot(data, aes(x = gen, y = avtes, group = rep, color = phase)) +
    geom_line(alpha = 1, linewidth = 0.7) +
    xlab("Generation") +
    ggtitle(title) +
    scale_colour_manual(values = p) +
    ylim(g_min, g_max) +
    common_theme()  # Apply the common theme

  # Conditionally add y-axis label
  if (show_y_label) {
    p <- p + ylab("Insertions per Individual")
  } else {
    p <- p + ylab("") + theme(axis.text.y = element_blank(), axis.ticks.y = element_blank())
  }

  return(p)
}

# Generate plots for each sampleid with y-axis control
g1 <- plot_diploid(subset(df, sampleid == "bm50"), "Insertion Bias = -50", TRUE)  # Y-label on
g2 <- plot_diploid(subset(df, sampleid == "b0"), "Insertion Bias = 0")           # Y-label off
g3 <- plot_diploid(subset(df, sampleid == "b50"), "Insertion Bias = 50")         # Y-label off

# Combine plots in a grid
combined_plot <- grid.arrange(g1, g2, g3, nrow = 1, widths = c(1, 1, 1))

# Save the combined plot
ggsave("Figure_1C.pdf", plot = combined_plot, width = 16, height = 9, dpi = 600, device = "pdf")



df1 <- subset(df, phase %in% c("shot", "inac"))
df2 <- data.frame()

# New dataframe with only the first shotgun & the first inactive phase of each replicate
repcheck <- 1
x <- 1
y <- 1
while (x < nrow(df1)) {
  if (repcheck != df1[x, 1]) {
    y <- 1
  }
  if (y == 1) {
    if (df1[x, 12] == "shot") {
      df2 <- rbind(df2, df1[x,])
      y <- 2
      repcheck <- df1[x, 1]
    }
  }
  if (y == 2) {
    if (df1[x, 12] == "inac") {
      df2 <- rbind(df2, df1[x,])
      y <- 1
    }
  }
  x <- x + 1
}


# Summary statistics
df2 <- select(df2, -c(22))

df_summary <- df2 %>%
  dplyr::group_by(sampleid, phase) %>%
  dplyr::summarize(
    av_fwcli = mean(fwcli),
    sd_fwcli = sd(fwcli),
    av_cli = mean(avcli),
    sd_cli = sd(avcli),
    cv_cli_percent = sd(avcli) / mean(avcli),
    av_tes = mean(avtes),
    sd_tes = sd(avtes),
    cv_tes_percent = sd(avtes) / mean(avtes),
    av_w = mean(avw),
    min_w = min(min_w),
    length_previous_phase = mean(gen),
    sd_length_previous_phase = sd(gen),
    .groups = "drop"
  )

df_count <- df2 %>%
  dplyr::count(sampleid, phase)

df_summary <- cbind(df_count$n, df_summary)
colnames(df_summary)[1] <- "n"


# CI 95%: z* sd/sqrt(population)
df_summary$ci_fwcli <- qt(0.975, df = df_summary$n - 1) * (df_summary$sd_fwcli / sqrt(df_summary$n))
df_summary$ci_cli <- qt(0.975, df = df_summary$n - 1) * (df_summary$sd_cli / sqrt(df_summary$n))
df_summary$ci_tes <- qt(0.975, df = df_summary$n - 1) * (df_summary$sd_tes / sqrt(df_summary$n))

plot_diploid <- function(data, title, min_val, max_val) {
  ggplot(data, aes(x = phase, y = av_tes, fill = phase)) +
    geom_bar(stat = "identity") +
    geom_errorbar(aes(x = phase, ymin = av_tes - sd_tes, ymax = av_tes + sd_tes), 
                  width = 0.2, colour = "black", alpha = 0.9, linewidth = 0.8) +
    xlab("Phase") +
    ylab("Insertions per Individual") +
    scale_x_discrete(labels = c("Rapid", "Shotgun")) +
    ggtitle(title) +
    scale_y_continuous(limits = c(min_val, max_val), expand = expansion(mult = c(0, 0.01))) +
    scale_fill_manual(values = c("#1a9850", "#ffd700")) +
    common_theme()  # Apply the common theme
}

# Generate the plots
p1 <- plot_diploid(subset(df_summary, sampleid == "bm50"), "Insertion Bias = -50", 0, 1000)
p2 <- plot_diploid(subset(df_summary, sampleid == "b0"), "Insertion Bias = 0", 0, 1000)
p3 <- plot_diploid(subset(df_summary, sampleid == "b50"), "Insertion Bias = 50", 0, 1000)

# Combine and save the plots
combined_p_plot <- grid.arrange(p1, p2, p3, nrow = 1, widths = c(1, 1, 1))
ggsave("Figure_3B.pdf", plot = combined_p_plot, width = 16, height = 9, dpi = 600, device = "pdf")


g_avcli_min <- 0
g_avcli_max <- 10
df_summary$sampleid <- factor(df_summary$sampleid, levels = c("bm50", "b0", "b50"))


# Updated create_plot function with control over y-axis label display
create_plot <- function(data_subset, title, show_y_label = FALSE) {
  p <- ggplot(data_subset, aes(x = phase, y = av_cli, fill = phase)) +
    geom_bar(stat = "identity") +
    geom_errorbar(aes(x = phase, ymin = av_cli - sd_cli, ymax = av_cli + sd_cli), width = 0.2, colour = "black", alpha = 0.9, linewidth = 0.8) +
    scale_x_discrete(labels = c("Rapid", "Shotgun")) +
    scale_fill_manual(values = c("#1a9850", "#ffd700")) +
    xlab("Phase") +
    ggtitle(title) +
    scale_y_continuous(limits = c(g_avcli_min, g_avcli_max), expand = expansion(mult = c(0, 0.01))) +
    common_theme()  # Apply the common theme

  # Conditionally add y-axis label
  if (show_y_label) {
    p <- p + ylab("Average Cluster Insertions Individual")
  } else {
    p <- p + ylab("") + theme(axis.text.y = element_blank(), axis.ticks.y = element_blank())
  }

  return(p)
}

# Generate plots for each sampleid with y-axis control
plot_bm50 <- create_plot(df_summary[df_summary$sampleid == "bm50", ], "Insertion Bias = -50", TRUE)  # Y-label on
plot_b0   <- create_plot(df_summary[df_summary$sampleid == "b0", ], "Insertion Bias = 0")           # Y-label off
plot_b50  <- create_plot(df_summary[df_summary$sampleid == "b50", ], "Insertion Bias = 50")         # Y-label off

# Combine plots in a grid
combined_plots <- arrangeGrob(plot_bm50, plot_b0, plot_b50, nrow = 1, widths = c(1, 1, 1))


ggsave(filename = "Figure_3C.pdf", plot = combined_plots, width = 16, height = 9, dpi = 600)



# Updated plot_phase_length function with control over y-axis label display
plot_phase_length <- function(data, sampleid, title, show_y_label = FALSE) {
  p <- ggplot(data, aes(x = phase, y = length_previous_phase, fill = phase)) +
    geom_bar(stat = "identity") +
    geom_errorbar(aes(ymin = length_previous_phase - sd_length_previous_phase, ymax = length_previous_phase + sd_length_previous_phase),
                  width = 0.2, colour = "black", alpha = 0.9, linewidth = 0.8) +
    scale_x_discrete(labels = c("Rapid", "Shotgun")) +
    scale_fill_manual(values = c("#1a9850", "#ffd700")) +
    xlab("Phase") +
    ggtitle(title) +
    scale_y_continuous(expand = expansion(mult = c(0, 0.01))) +
    common_theme()  # Apply the common theme

  # Conditionally add y-axis label
  if (show_y_label) {
    p <- p + ylab("Average Phase Length")
  } else {
    p <- p + ylab("") + theme(axis.text.y = element_blank(), axis.ticks.y = element_blank())
  }

  return(p)
}

# Generate plots for each sampleid with y-axis control
p1 <- plot_phase_length(subset(df_summary, sampleid == "bm50"), "bm50", "Insertion Bias = -50", TRUE)  # Y-label on
p2 <- plot_phase_length(subset(df_summary, sampleid == "b0"), "b0", "Insertion Bias = 0")             # Y-label off
p3 <- plot_phase_length(subset(df_summary, sampleid == "b50"), "b50", "Insertion Bias = 50")         # Y-label off


combined_plot <- invisible(grid.arrange(p1, p2, p3, nrow = 1, widths = c(1, 1, 1)))

ggsave(filename = "Figure_3A.pdf", plot = combined_plot, width = 16, height = 9, dpi = 600, device = "pdf")

