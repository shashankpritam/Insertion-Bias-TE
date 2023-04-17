# Load libraries
library(tidyverse)
library(RColorBrewer)
library(ggpubr)
theme_set(theme_bw())

# Define palette
p <- c("#1a9850", "#ffd700", "#d73027")

# Read data and set column names
df0 <- read.table("2023_04_16_Validation_5_bias", fill = TRUE, sep = "\t") 
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

# Create and plot the graph
g0 <- ggplot(data = df0_stat, aes(x = as.factor(sampleid), y = ok_rate, fill = ok_rate)) +
  geom_col(show.legend = FALSE) +
  geom_hline(yintercept = 0.8, linetype = "dashed", color = "red") +
  scale_y_continuous(limits = c(0, 1), expand = expansion(mult = c(0, 0)), breaks = seq(0, 1, 0.2),
                     labels = scales::percent) +
  scale_x_discrete(labels = setNames(c("-90", "-80", "-70", "-60", "-50", "-40", "-30", "-20", "-10", "0",
                                       "10", "20", "30", "40", "50", "60", "70", "80", "90"),
                                     unique(df0_stat$sampleid))) +
  scale_fill_gradientn(colors = RColorBrewer::brewer.pal(3, "Dark2")) +
  xlab("Insertion Bias") +
  ylab("Successful Invasions (%)") +
  theme_minimal() +
  theme(text = element_text(size = 12))

plot(g0)

