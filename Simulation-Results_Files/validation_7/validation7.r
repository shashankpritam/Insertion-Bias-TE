# Load necessary libraries
library(readr)
library(dplyr)
library(ggplot2)

# Define column names
column_names <- c("rep", "gen", "popstat", "spacer_1", "fwte", "avw", "min_w", "avtes", "avpopfreq",
                "fixed", "spacer_2", "phase", "fwcli", "avcli", "fixcli", "spacer_3",
                "avbias", "3tot", "3cluster", "spacer_4", "sampleid")

# Load DataFrame with column names
df <- read_delim('Simulation-Results_Files/validation_7/combined_results.out', delim='\t', col_names = column_names)


# Define replacement dictionary
replace_dict <- c("mb100" = "-100","mb90" = "-90", "mb80" = "-80", "mb70" = "-70", "mb60" = "-60",
                "mb50" = "-50", "mb40" = "-40", "mb30" = "-30", "mb20" = "-20",
                "mb10" = "-10", "b100" = "100","b90" = "90", "b80" = "80", "b70" = "70",
                "b60" = "60", "b50" = "50", "b40" = "40", "b30" = "30",
                "b20" = "20", "b10" = "10", "b0" = "0")

# Apply replacements to 'sampleid' column
df$sampleid <- as.character(df$sampleid) %>% str_replace_all(replace_dict)

# Convert the columns to numeric
numeric_columns <- c("rep", "gen", "fwte", "avw", "min_w", "avtes", "avpopfreq",
                   "fixed", "fwcli", "avcli", "fixcli",
                   "avbias", "sampleid")

df[numeric_columns] <- lapply(df[numeric_columns], function(x) as.numeric(as.character(x)))

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

# Filter dataframe where 'gen' == 0 and sort it by 'sampleid'
df2 <- df[df$gen == 0, numeric_columns] %>% arrange(sampleid)

# Calculate the expected values (pc) for each 'sampleid'
df2$pc <- sapply(df2$sampleid, function(x) pc(x, 0.03))

# Load ggplot2 library
library(ggplot2)

# Load ggplot2 library
library(ggplot2)

# Create the plot with annotations for line and dot information
a <- ggplot(df2, aes(x = sampleid)) +
  geom_point(aes(y = avcli), color = "#0072B2") +  # Blue color for avcli points
  geom_line(aes(y = pc), color = "#D55E00") +  # Orange color for pc line
  labs(title = "Average Cluster Insertion Expected vs Observed value across Insertion Bias",
       x = "Insertion Bias",
       y = "Average Cluster Insertion") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5),
        panel.background = element_rect(fill = "white"), # Ensure white background
        plot.background = element_rect(fill = "white", color = NA)) + # Remove panel border
  annotate("text", x = -60, y = Inf, label = "Orange Line: Expected\nBlue Points: Observed", 
           hjust = 1.1, vjust = 1.1, fontface = "italic", color = "black", size = 3.5,
           position = position_nudge(y = -0.1)) # Annotation for line and dot information

# Save the plot with high resolution
ggsave(filename = "images/Validation_7_1A.png",
       plot = a,
       width = 8,
       height = 6,
       units = "in",
       dpi = 1200) # High resolution for publication

# Print the plot for viewing
print(a)



# Filter out the group with sampleid = 100 and -100
df_filtered <- df2 %>%
  filter(!(sampleid %in% c(-100, 100)))

# Subtract 'pc' from 'avcli' and force as numeric
df_filtered$TE_insertions <- as.numeric(as.character(df_filtered$avcli)) - as.numeric(as.character(df_filtered$pc))
df_filtered$TE_insertions <- 100 * df_filtered$TE_insertions

# Convert 'sampleid' to factor
df_filtered$insertion_bias <- as.factor(df_filtered$sampleid)

# Create a new plot file with larger dimensions and higher resolution
png(filename = "images/Validation_7_1B.png", width = 10, height = 10, units = "in", res = 600)

# Boxplot
boxplot(df_filtered$TE_insertions ~ df_filtered$insertion_bias, 
        border = rgb(0.1, 0.1, 0.7, 0.5),
        main="Variability in Cluster Insertion Across 100 Replications", 
        xlab="Insertion Bias", 
        ylab="TE Cluster Insertion Variability Across 100 Replications")

# Add data points
mylevels <- levels(df_filtered$insertion_bias)
levelProportions <- summary(df_filtered$insertion_bias)/nrow(df_filtered)
for(i in 1:length(mylevels)){
  thislevel <- mylevels[i]
  thisvalues <- df_filtered[df_filtered$insertion_bias==thislevel, "TE_insertions"]
   
  # Ensure thisvalues is a numeric vector
  thisvalues <- unlist(thisvalues)
  
  # Take the x-axis indices and add a jitter, proportional to the N in each level
  myjitter <- jitter(rep(i, length(thisvalues)), amount=levelProportions[i]/2)
  
  # Use smaller points
  points(myjitter, thisvalues, pch=20, cex=0.9, col=rgb(0,0.2,0.25,0.6)) 
}



# Close the plot file
invisible(dev.off())