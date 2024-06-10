library(ggplot2)
library(gridExtra)

# Define your function
pc <- function(bias, clufrac) {
    genfrac = 1.0 - clufrac
    bias = bias / 100
    clufit = (bias + 1.0) / 2.0
    genfit = 1.0 - clufit
    totfit = clufrac * clufit + genfrac * genfit
    p = (clufrac * clufit) / totfit
    return(p * 100)
}

# Generate data
bias_values <- seq(-100, 100, by = 10)
clufrac <- 0.03  # 3 % Cluster Size
pc_values <- sapply(bias_values, pc, clufrac = clufrac)
df2 <- data.frame(bias = bias_values, pc = pc_values)

# Create the plot
a <- ggplot(df2, aes(x = bias, y = pc)) +
  geom_line(color = "darkgreen", size = 1.2) +
  geom_point(color = "#003f5c", size = 3) +
  labs(title = "Average Cluster Insertion and Insertion Bias",
       x = "Insertion Bias",
       y = "Average Cluster Insertion") +
  scale_x_continuous(breaks = seq(-100, 100, by = 10)) +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, size = 16),
        axis.title = element_text(size = 14),
        axis.text = element_text(size = 12),
        panel.grid.major = element_line(color = "grey70"),
        panel.grid.minor = element_blank(),
        axis.line = element_line(color = "black"),
        axis.ticks = element_line(color = "black"))

# Save the plot
ggsave(
  filename = "/Users/shashankpritam/github/Insertion-Bias-TE/images/Figure_1B.jpg",
  plot = a,
  width = 10,
  height = 10,
  units = "in"
)
ggsave(
  filename = "/Users/shashankpritam/github/Insertion-Bias-TE/images/fig_pdf/Figure_1B.pdf",
  plot = a,
  width = 10,
  height = 10,
  units = "in"
)

