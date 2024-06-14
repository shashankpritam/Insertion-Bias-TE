library(extrafont)
library(ggplot2)
# Now you can use Helvetica in your ggplot
common_theme <- function() {
  theme(
    legend.position = "none",
    plot.title = element_text(hjust = 0.5, size = 16, family = "Helvetica"),
    axis.title = element_text(size = 24, family = "Helvetica"),
    axis.text.x = element_text(size = 18, family = "Helvetica"),
    axis.text.y = element_text(size = 18, family = "Helvetica"),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    strip.background = element_rect(fill = "white"),
    strip.text = element_text(face = "bold", size = 20, family = "Helvetica"),
    axis.line = element_line(color = "black"),
    #axis.ticks = element_line(color = "black"),
    panel.background = element_rect(fill = "white", colour = "white")
  )
}

pc <- function(bias, clufrac) {
    genfrac = 1.0 - clufrac
    bias = bias / 100
    clufit = (bias + 1.0) / 2.0
    genfit = 1.0 - clufit
    totfit = clufrac * clufit + genfrac * genfit
    p = (clufrac * clufit) / totfit
    return(p)
}

bias_values <- seq(-100, 100, by = 1)
clufrac <- 0.03
pc_values <- sapply(bias_values, pc, clufrac = clufrac)
df2 <- data.frame(bias = bias_values, pc = pc_values)

a <- ggplot(df2, aes(x = bias, y = pc)) +
  geom_line(color = "darkgreen", linewidth = 1.2) +
  labs(title = "",
       x = "Insertion Bias",
       y = "Average Cluster Insertion Probability") +
  scale_x_continuous(breaks = c(-100, -50, 0, 50, 100), labels = c("-100", "-50", "0", "50", "100")) +
  common_theme()


ggsave(filename = "Figure_1B.pdf", plot = a, width = 10, height = 10, units = "in", family = "Helvetica")
