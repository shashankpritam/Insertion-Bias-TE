# Load necessary libraries
library(tidyverse)

# Define common theme
common_theme <- function() {
  theme(
    text = element_text(family = "Helvetica"),
    legend.position = "none",
    plot.title = element_text(hjust = 0.5, size = 12),
    axis.title = element_text(size = 12),
    axis.text.x = element_text(size = 12, angle = 45, hjust = 1),  # Rotate x-axis labels
    axis.text.y = element_text(size = 12),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    strip.background = element_rect(fill = "lightgrey"),
    strip.text = element_text(face = "bold", size = 20),
    axis.line = element_line(color = "black"),
    axis.ticks = element_line(color = "black"),
    panel.background = element_rect(fill = "white", colour = "white")
  )
}

# Read data and set column names
df0 <- read.table("Simulation-Results_Files/validation_5.1/2023_04_16_Validation_5_bias", fill = TRUE, sep = "\t")
names(df0) <- c("rep", "gen", "popstat", "spacer_1", "fwte", "avw", "min_w", "avtes", "avpopfreq",
                "fixed", "spacer_2", "phase", "fwcli", "avcli", "fixcli", "spacer_3",
                "avbias", "3tot", "3cluster", "spacer_4", "sampleid")

# Filter and select columns
df00 <- subset(df0, gen != 0)
df00 <- select(df00, -c(22))

# Calculate statistics
df0_stat <- df00 %>%
  group_by(sampleid) %>%
  summarize(fail = sum(popstat == "fail-0"),
            success = sum(popstat == "ok"),
            total = success + fail,
            ok_rate = success/total)

# Modify sampleid values
df0_stat <- df0_stat %>%
  mutate(sampleid = str_replace_all(sampleid, c("mb90" = "-90", "mb80" = "-80", "mb70" = "-70", "mb60" = "-60",
                                                "mb50" = "-50", "mb40" = "-40", "mb30" = "-30", "mb20" = "-20",
                                                "mb10" = "-10", "b90" = "90", "b80" = "80", "b70" = "70",
                                                "b60" = "60", "b50" = "50", "b40" = "40", "b30" = "30",
                                                "b20" = "20", "b10" = "10", "b0" = "0")))

# Convert sampleid to integer and sort
df0_stat$sampleid <- as.integer(df0_stat$sampleid)
df0_stat <- df0_stat[order(df0_stat$sampleid),]

# Define the sample ID labels to include
sampleid_labels <- c("-90", "-80", "-70", "-60", "-50", "-40", "-30", "-20", "-10", "0",
                     "10", "20", "30", "40", "50", "60", "70", "80", "90")

# Create and plot the graph with well-defined grid and margin
g0 <- ggplot(data = df0_stat, aes(x = as.factor(sampleid), y = ok_rate, fill = ok_rate)) +
  geom_col(show.legend = FALSE) +
  geom_hline(yintercept = 0.8, linetype = "dashed", color = "red") +
  scale_y_continuous(
    limits = c(0, 1), 
    expand = expansion(mult = c(0, 0)), 
    breaks = seq(0, 1, 0.2),
    labels = scales::percent
  ) +
  scale_x_discrete(
    limits = sampleid_labels,
    labels = setNames(sampleid_labels, sampleid_labels)
  ) +
  geom_col(fill = "darkgreen") +
  xlab("Insertion Bias") +
  ylab("Successful Invasions (%)") +
  theme_minimal(base_size = 12) +
  common_theme() +
  theme(
    plot.margin = margin(20, 60, 20, 20, "pt")
  )

# Save the plot with a solid background and added padding
#ggsave("Figure_2.png", plot = g0, bg = "white", width = 10, height = 6)
ggsave("Figure_2.pdf", plot = g0, bg = "white", width = 10, height = 6, device = "pdf")

