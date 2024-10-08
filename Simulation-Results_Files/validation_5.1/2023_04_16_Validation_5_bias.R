# Load libraries
library(tidyverse)
library(RColorBrewer)
library(ggpubr)
theme_set(theme_bw())


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
    limits = as.character(seq(-100, 100, by = 10)),
    labels = setNames(
      c("-90", "-80", "-70", "-60", "-50", "-40", "-30", "-20", "-10", "0",
        "10", "20", "30", "40", "50", "60", "70", "80", "90"),
      unique(df0_stat$sampleid)
    )
  ) +
  geom_col(fill = "#525657") +
  xlab("Insertion Bias") +
  ylab("Successful Invasions (%)") +
  theme_minimal(base_size = 12) +
  theme(
    plot.background = element_rect(fill = "white", color = "white"),
    panel.background = element_rect(fill = "white", color = "white"),
    plot.margin = margin(20, 60, 20, 20, "pt"),  # Adjusted margin
    panel.grid.major.x = element_line(color = "grey90", size = 0.5),  # Custom major x grid lines
    panel.grid.major.y = element_line(color = "grey90", size = 0.5)   # Custom major y grid lines
  )

# Save the plot with a solid background and added padding
ggsave("images/2023_04_17_Validation_5a_bias.png", plot = g0, bg = "white", width = 10, height = 6)



