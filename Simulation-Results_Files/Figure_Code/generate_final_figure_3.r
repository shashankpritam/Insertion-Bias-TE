library(tidyverse)
library(gridExtra)
library(ggpubr)
library(rstatix)

# --- 1. Setup: Aesthetics and Data Loading (Preserving Original Style) ---

# Preserve the original, correct theme
common_theme <- function() {
  theme_bw() + 
  theme(
    text = element_text(family = "Helvetica"),
    legend.position = "none",
    plot.title = element_text(hjust = 0, size = 28),
    axis.title = element_text(size = 12),
    axis.text.x = element_text(size = 10),
    axis.text.y = element_text(size = 10),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.border = element_blank(),
    axis.line = element_line(colour = "black"),
    strip.background = element_blank(),
    strip.text = element_text(size = 10)
  )
}

# Original color palette
phase_colors <- c("rapi" = "#1a9850", "shot" = "#ffd700", "inac" = "#d73027")
plot_colors <- c("#1a9850", "#ffd700") # For Rapid and Shotgun phase lengths

# Load data
combined_file_path <- "/Users/shashankpritam/github/Insertion-Bias-TE/Simulation-Results_Files/simulation_storm/phase_len_2/combined_data_for_figure3.tsv"
df <- read.table(combined_file_path, fill = TRUE, sep = "\t", header = FALSE)

# Assign column names and select the correct columns
names(df) <- c("rep", "gen", "popstat", "spacer_1", "fwte", "avw", "min_w", "avtes",
               "avpopfreq", "fixed", "spacer_2", "phase", "fwcli", "avcli", "fixcli", "spacer_3", "avbias", "3tot", "3cluster", "spacer_4", "sampleid")
df <- df[, 1:21]

# Filter for relevant data and set factor levels
df <- df %>% filter(sampleid %in% c("bm50", "b0", "b50"))
df$phase <- factor(df$phase, levels = c("rapi", "shot", "inac"))
df$sampleid <- factor(df$sampleid, levels = c("bm50", "b0", "b50"), labels = c("Insertion Bias = -50", "Insertion Bias = 0", "Insertion Bias = 50"))

# --- 2. Data Processing (Using the Original, Correct `while` loop logic) ---

df1 <- subset(df, phase %in% c("shot", "inac"))
df2 <- data.frame()

replicates <- unique(df1$rep)
for (r in replicates) {
  for (s_id in unique(df1$sampleid)){
    subset_data <- df1[df1$rep == r & df1$sampleid == s_id, ]
    if(nrow(subset_data) == 0) next

    y <- 1
    for (x in 1:nrow(subset_data)) {
      if (y == 1 && subset_data[x, "phase"] == "shot") {
        df2 <- rbind(df2, subset_data[x, ])
        y <- 2
      } else if (y == 2 && subset_data[x, "phase"] == "inac") {
        df2 <- rbind(df2, subset_data[x, ])
        break # Found the pair, move to next replicate
      }
    }
  }
}

# Create summary statistics dataframe
df_summary <- df2 %>% 
  group_by(sampleid, phase) %>% 
  summarize(
    length_previous_phase = mean(gen),
    sd_length_previous_phase = sd(gen),
    av_tes = mean(avtes),
    sd_tes = sd(avtes),
    av_cli = mean(avcli),
    sd_cli = sd(avcli),
    .groups = "drop"
  )

# --- 3. Statistical Analysis (Corrected Comparison) ---

# The 'gen' value for phase 'shot' is the length of the 'rapid' phase.
# The 'gen' value for phase 'inac' is the length of the 'shotgun' phase.
stat_test <- df2 %>% 
  group_by(sampleid) %>% 
  wilcox_test(gen ~ phase) %>% 
  add_significance("p") %>% 
  add_xy_position(x = "phase", dodge = 0.8)

# --- 4. Plotting Functions ---

# A: Average Phase Length
plot_phase_length <- function(data) {
  ggplot(data, aes(x = phase, y = length_previous_phase, fill = phase)) +
    geom_bar(stat = "identity") +
    geom_errorbar(aes(ymin = length_previous_phase - sd_length_previous_phase, 
                      ymax = length_previous_phase + sd_length_previous_phase), width = 0.2) +
    stat_pvalue_manual(stat_test, label = "p.signif", tip.length = 0.01, hide.ns = FALSE) +
    facet_wrap(~sampleid, nrow = 1) +
    scale_fill_manual(values = plot_colors) +
    scale_x_discrete(labels = c("shot" = "Rapid", "inac" = "Shotgun")) +
    labs(title = "B", x = NULL, y = "Average Phase Length") +
    common_theme()
}

# B: Average TE Insertions
plot_te_insertions <- function(data) {
  ggplot(data, aes(x = phase, y = av_tes, fill = phase)) +
    geom_bar(stat = "identity") +
    geom_errorbar(aes(ymin = av_tes - sd_tes, ymax = av_tes + sd_tes), width = 0.2) +
    facet_wrap(~sampleid, nrow = 1) +
    scale_fill_manual(values = plot_colors) +
    scale_x_discrete(labels = c("shot" = "Rapid", "inac" = "Shotgun")) +
    labs(title = "A", x = NULL, y = "Average TE Insertions per Individual") +
    common_theme()
}

# C: Average Cluster Insertions
plot_cluster_insertions <- function(data) {
  ggplot(data, aes(x = phase, y = av_cli, fill = phase)) +
    geom_bar(stat = "identity") +
    geom_errorbar(aes(ymin = av_cli - sd_cli, ymax = av_cli + sd_cli), width = 0.2) +
    facet_wrap(~sampleid, nrow = 1) +
    scale_fill_manual(values = plot_colors) +
    scale_x_discrete(labels = c("shot" = "Rapid", "inac" = "Shotgun")) +
    labs(title = "C", x = "Phase", y = "Average Cluster Insertions per Individual") +
    common_theme()
}

# --- 5. Generate and Save Figure ---

# Generate plots with new panel order (A=TE Insertions, B=Phase Length, C=Cluster Insertions)
pA <- plot_te_insertions(df_summary) + theme(plot.margin = unit(c(0.5, 1, 0.5, 0.5), "cm"))
pB <- plot_phase_length(df_summary) + theme(plot.margin = unit(c(0.5, 0.5, 0.5, 1), "cm"))
pC <- plot_cluster_insertions(df_summary) + theme(plot.margin = unit(c(0.5, 1, 0.5, 0.5), "cm"))

# Save individual plots with correct new filenames
ggsave("/Users/shashankpritam/github/InsertionBiasGENETICS-1/figures/Figure_3A_HQ.pdf", plot = pA, width = 6, height = 5, device = "pdf")
ggsave("/Users/shashankpritam/github/InsertionBiasGENETICS-1/figures/Figure_3B_HQ.pdf", plot = pB, width = 6, height = 5, device = "pdf")
ggsave("/Users/shashankpritam/github/InsertionBiasGENETICS-1/figures/Figure_3C_HQ.pdf", plot = pC, width = 6, height = 5, device = "pdf")

# Arrange the final combined plot in a 2x2 grid with the new order
final_plot <- grid.arrange(pA, pB, pC, layout_matrix = rbind(c(1, 2), c(3, NA)))
ggsave("/Users/shashankpritam/github/InsertionBiasGENETICS-1/figures/Figure_3_Combined_HQ.pdf", plot = final_plot, width = 10, height = 8, device = "pdf")

cat("Final Figure 3 and its individual components generated successfully in the figures directory.\n")
