library(tidyverse)
library(RColorBrewer)
library(ggpubr)
theme_set(theme_bw())

p <- c("#1a9850", "#ffd700", "#d73027")

df <- read.table("2023_04_18_simulation_5_2_bias", fill = TRUE, sep = "\t")
names(df) <- c("rep", "gen", "popstat", "spacer_1", "fwte", "avw", "min_w", "avtes", "avpopfreq",
               "fixed", "spacer_2", "phase", "fwcli", "avcli", "fixcli", "spacer_3",
               "avbias", "3tot", "3cluster", "spacer_4", "sampleid")

df$phase <- factor(df$phase, levels = c("rapi", "trig", "shot", "inac"))
df$sampleid <- factor(df$sampleid, levels = c("b0", "b10", "b20", "b30", "b40", "b50", "b60", "b70", "b80", "b90", "bm10", "bm20", "bm30", "bm40", "bm50", "bm60", "bm70", "bm80", "bm90"))

g <- ggplot() +
  geom_line(data = df, aes(x = gen, y = avtes, group = rep, color = phase), alpha = 1, linewidth = 0.7) +
  xlab("Generation") +
  ylab("TEs insertions per diploid individual") +
  theme(legend.position = "bottom",
        plot.title = element_text(hjust = 0.5),
        panel.grid.major = element_line(colour = "gray90"),
        panel.grid.minor = element_line(colour = "gray95"),
        strip.background = element_rect(fill = "lightgrey"),
        strip.text = element_text(face = "bold")) +
  ggtitle("Bias vs TE Insertions") +
  scale_colour_manual(values = p) +
  facet_wrap(~sampleid, labeller = labeller(sampleid =
                                              c("b0" = "bias = 0",
                                                "b10" = "bias = 10",
                                                "b20" = "bias = 20",
                                                "b30" = "bias = 30",
                                                "b40" = "bias = 40",
                                                "b50" = "bias = 50",
                                                "b60" = "bias = 60",
                                                "b70" = "bias = 70",
                                                "b80" = "bias = 80",
                                                "b90" = "bias = 90",
                                                "bm10" = "bias = -10",
                                                "bm20" = "bias = -20",
                                                "bm30" = "bias = -30",
                                                "bm40" = "bias = -40",
                                                "bm50" = "bias = -50",
                                                "bm60" = "bias = -60",
                                                "bm70" = "bias = -70",
                                                "bm80" = "bias = -80",
                                                "bm90" = "bias = -90")))

plot(g)


# Divide in shot and inact phases
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

df_count <- df2 %>%
  dplyr::count(sampleid, phase)

df_summary <- df2 %>%
  dplyr::group_by(sampleid, phase) %>%
  dplyr::summarize(av_fwcli = mean(fwcli), sd_fwcli = sd(fwcli),
                   av_cli = mean(avcli), sd_cli = sd(avcli), cv_cli_percent = sd(avcli) / mean(avcli),
                   av_tes = mean(avtes), sd_tes = sd(avtes), cv_tes_percent = sd(avtes) / mean(avtes),
                   length_previous_phase = mean(gen),
                   sd_gen_phases = sd(gen))
df_summary <- cbind(df_count$n, df_summary)

colnames(df_summary)[1] <- "n"

# CI 95%: z* sd/sqrt(population)
df_summary$ci_fwcli <- qt(0.975, df = df_summary$n - 1) * (df_summary$sd_fwcli / sqrt(df_summary$n))
df_summary$ci_cli <- qt(0.975, df = df_summary$n - 1) * (df_summary$sd_cli / sqrt(df_summary$n))
df_summary$ci_tes <- qt(0.975, df = df_summary$n - 1) * (df_summary$sd_tes / sqrt(df_summary$n))

# Average TE insertions per individual shot and inac phases
g_avtes <- ggplot(df_summary, aes(x = phase, y = av_tes, fill = phase)) +
  geom_bar(stat = "identity") +
  geom_errorbar(aes(x = phase, ymin = av_tes - sd_tes, ymax = av_tes + sd_tes), width = 0.2, colour = "black", alpha = 0.9, size = 0.8) +
  ylab("Insertions per individual") +
  xlab("Phase") +
  theme(legend.position = "bottom",
        plot.title = element_text(hjust = 0.5),
        panel.grid.major = element_line(colour = "gray90"),
        panel.grid.minor = element_line(colour = "gray95"),
        strip.background = element_rect(fill = "lightgrey"),
        strip.text = element_text(face = "bold")) +
  ggtitle("Bias vs TE Insertions") +
  scale_y_continuous(expand = expansion(mult = c(0, 0.01))) +
  scale_fill_manual(values = c("#ffd700", "#d73027")) +
  facet_wrap(~sampleid, labeller = labeller(sampleid =
                                              c("b0" = "bias = 0",
                                                "b10" = "bias = 10",
                                                "b20" = "bias = 20",
                                                "b30" = "bias = 30",
                                                "b40" = "bias = 40",
                                                "b50" = "bias = 50",
                                                "b60" = "bias = 60",
                                                "b70" = "bias = 70",
                                                "b80" = "bias = 80",
                                                "b90" = "bias = 90",
                                                "bm10" = "bias = -10",
                                                "bm20" = "bias = -20",
                                                "bm30" = "bias = -30",
                                                "bm40" = "bias = -40",
                                                "bm50" = "bias = -50",
                                                "bm60" = "bias = -60",
                                                "bm70" = "bias = -70",
                                                "bm80" = "bias = -80",
                                                "bm90" = "bias = -90")))

plot(g_avtes)


# Average cluster insertions per individual shot and inac phases
g_avcli <- ggplot(df_summary, aes(x = phase, y = av_cli, fill = phase)) +
  geom_bar(stat = "identity") +
  geom_errorbar(aes(x = phase, ymin = av_cli - sd_cli, ymax = av_cli + sd_cli), width = 0.2, colour = "black", alpha = 0.9, size = 0.8) +
  ylab("Cluster insertions per individual") +
  xlab("Phase") +
  theme(legend.position = "bottom",
        plot.title = element_text(hjust = 0.5),
        panel.grid.major = element_line(colour = "gray90"),
        panel.grid.minor = element_line(colour = "gray95"),
        strip.background = element_rect(fill = "lightgrey"),
        strip.text = element_text(face = "bold")) +
  ggtitle("Bias vs Cluster Insertions") +
  scale_y_continuous(expand = expansion(mult = c(0, 0.01))) +
  scale_fill_manual(values = c("#ffd700", "#d73027")) +
  facet_wrap(~sampleid, labeller = labeller(sampleid =
                                              c("b0" = "bias = 0",
                                                "b10" = "bias = 10",
                                                "b20" = "bias = 20",
                                                "b30" = "bias = 30",
                                                "b40" = "bias = 40",
                                                "b50" = "bias = 50",
                                                "b60" = "bias = 60",
                                                "b70" = "bias = 70",
                                                "b80" = "bias = 80",
                                                "b90" = "bias = 90",
                                                "bm10" = "bias = -10",
                                                "bm20" = "bias = -20",
                                                "bm30" = "bias = -30",
                                                "bm40" = "bias = -40",
                                                "bm50" = "bias = -50",
                                                "bm60" = "bias = -60",
                                                "bm70" = "bias = -70",
                                                "bm80" = "bias = -80",
                                                "bm90" = "bias = -90")))

plot(g_avcli)


g_bar_av_TEs <- ggplot(df2, aes(x = sampleid, y = avtes)) +
  geom_boxplot() +
  ggtitle("Insertions at 5000 generations") +
  ylab("Ins. per individual") +
  xlab("Insertion bias") +
  theme(legend.position = "none",
        axis.text.x = element_text(size = 14, angle = 45, hjust = 1),
        axis.text.y = element_text(size = 14),
        axis.title.x = element_text(size = 14),
        axis.title.y = element_text(size = 14),
        strip.text = element_text(size = 14),
        plot.title = element_text(hjust = 0.5)) +
  scale_x_discrete(labels = c("b0" = "bias = 0",
                              "b10" = "bias = 10",
                              "b20" = "bias = 20",
                              "b30" = "bias = 30",
                              "b40" = "bias = 40",
                              "b50" = "bias = 50",
                              "b60" = "bias = 60",
                              "b70" = "bias = 70",
                              "b80" = "bias = 80",
                              "b90" = "bias = 90",
                              "bm10" = "bias = -10",
                              "bm20" = "bias = -20",
                              "bm30" = "bias = -30",
                              "bm40" = "bias = -40",
                              "bm50" = "bias = -50",
                              "bm60" = "bias = -60",
                              "bm70" = "bias = -70",
                              "bm80" = "bias = -80",
                              "bm90" = "bias = -90"))

plot(g_bar_av_TEs)


g_bar_av_cli <- ggplot(df2, aes(x = sampleid, y = avcli)) +
  geom_boxplot() +
  ggtitle("Cluster insertions at 5000 generations") +
  ylab("Cluster ins. per individual") +
  xlab("Insertion bias") +
  theme(legend.position = "none",
        axis.text.x = element_text(size = 14, angle = 45, hjust = 1),
        axis.text.y = element_text(size = 14),
        axis.title.x = element_text(size = 14),
        axis.title.y = element_text(size = 14),
        strip.text = element_text(size = 14),
        plot.title = element_text(hjust = 0.5)) +
  scale_x_discrete(labels = c("b0" = "bias = 0",
                              "b10" = "bias = 10",
                              "b20" = "bias = 20",
                              "b30" = "bias = 30",
                              "b40" = "bias = 40",
                              "b50" = "bias = 50",
                              "b60" = "bias = 60",
                              "b70" = "bias = 70",
                              "b80" = "bias = 80",
                              "b90" = "bias = 90",
                              "bm10" = "bias = -10",
                              "bm20" = "bias = -20",
                              "bm30" = "bias = -30",
                              "bm40" = "bias = -40",
                              "bm50" = "bias = -50",
                              "bm60" = "bias = -60",
                              "bm70" = "bias = -70",
                              "bm80" = "bias = -80",
                              "bm90" = "bias = -90"))

plot(g_bar_av_cli)
