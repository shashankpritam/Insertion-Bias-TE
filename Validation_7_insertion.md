Validation of insertion
================

## Shashank Pritam

# Introduction

In this validation we wanted to test if insertion was correctly
implemented.

version: invadego 0.1.3

### Materials & Methods

| Bias | SampleID | Seed                |
|------|----------|---------------------|
| -100 | mb100    | 1687536242971454096 |
| -90  | mb90     | 1687536243555042787 |
| -80  | mb80     | 1687536244165421696 |
| -70  | mb70     | 1687536244703461884 |
| -60  | mb60     | 1687536245276626319 |
| -50  | mb50     | 1687536245854820328 |
| -40  | mb40     | 1687536246430909783 |
| -30  | mb30     | 1687536246975725564 |
| -20  | mb20     | 1687536247567765218 |
| -10  | mb10     | 1687536248167192473 |
| 0    | b0       | 1687536248762704948 |
| 10   | b10      | 1687536249335629024 |
| 20   | b20      | 1687536249867473955 |
| 30   | b30      | 1687536250447057737 |
| 40   | b40      | 1687536251047595292 |
| 50   | b50      | 1687536251641891204 |
| 60   | b60      | 1687536252221658110 |
| 70   | b70      | 1687536252795926295 |
| 80   | b80      | 1687536253370826958 |
| 90   | b90      | 1687536253995850274 |
| 100  | b100     | 1687536254582479165 |

Commands for the simulation:

``` bash
tool="./main"
genome="mb:1,1,1,1,1"
cluster="kb:30,30,30,30,30"
rep=1
gen=1
steps=1
folder="Simulation-Results/Insertion-Bias/validation_7"
rr="0,0,0,0,0"

# Make sure the output folder exists
mkdir -p $folder

# Loop over values from -100 to 100 in steps of 10
for j in $(seq -100 10 100)
do
    # Set basepop directly to "1000;j"
    basepop="1000($j)"

    # Assign current counter value to sampleid with descriptive prefix
    if [ $j -ge 0 ]
    then
        sampleid="b${j}"
    else
        sampleid="mb${j#-}"  # Use parameter expansion to remove the negative sign
    fi

    # Run the command and write the output to a file named after the sampleid
    $tool --N 100000 --gen $gen --genome $genome --cluster $cluster --rr $rr --rep $rep --basepop "$basepop" --steps $steps --sampleid $sampleid > "$folder/result_${sampleid}.out"
done

cat result_*.out | grep -v "^Invade" | grep -v "^#" > combined_results.out
```

# Data Processing in R

This part includes loading and cleaning the data.

``` r
# Read the raw data
raw_data <- readLines("Simulation-Results_Files/validation_7/combined_results.out")

# Split the data by tabs ("\t")
data_split <- strsplit(raw_data, "\t")

# Convert the list into a data frame
df <- as.data.frame(do.call(rbind, data_split), stringsAsFactors = FALSE)

# Assign column names
column_names <- c("V1", "V2", "V3", "V4", "V5")

# Split columns by tabs and replace empty strings with NA
df[, -5] <- lapply(df[, -5], function(x) {
  strsplit(x, "\t")
})

# Define column names
column_names <- c("rep", "gen", "popstat", "spacer_1", "fwte", "avw", "min_w", "avtes", "avpopfreq",
                  "fixed", "spacer_2", "phase", "fwcli", "avcli", "fixcli", "spacer_3",
                  "avbias", "3tot", "3cluster", "spacer_4", "sampleid")

# Assign column names to df
colnames(df) <- column_names

# Replace values in the 'sampleid' column
df <- df %>%
  mutate(sampleid = str_replace_all(sampleid, c("mb100" = "-100","mb90" = "-90", "mb80" = "-80", "mb70" = "-70", "mb60" = "-60",
                                                "mb50" = "-50", "mb40" = "-40", "mb30" = "-30", "mb20" = "-20",
                                                "mb10" = "-10", "b100" = "100","b90" = "90", "b80" = "80", "b70" = "70",
                                                "b60" = "60", "b50" = "50", "b40" = "40", "b30" = "30",
                                                "b20" = "20", "b10" = "10", "b0" = "0")))


# Define numeric columns
numeric_columns <- c("rep", "gen", "fwte", "avw", "min_w", "avtes", "avpopfreq",
                     "fixed", "fwcli", "avcli", "fixcli",
                     "avbias", "sampleid")


# Define df2 with numeric columns and gen = 0 filter
df2 <- df %>%
  mutate(across(all_of(numeric_columns), as.numeric)) %>%
  filter(gen == 0) %>%
  select(all_of(numeric_columns))
```

# Data Visualiztion in R

This part includes plotting the data.

``` r
head(df2)
```

    ##   rep gen fwte avw min_w avtes avpopfreq fixed fwcli avcli fixcli avbias
    ## 1   1   0 0.01   1     1  0.01         0     0  0.00  0.00      0      0
    ## 2   1   0 0.01   1     1  0.01         0     0  0.00  0.00      0     10
    ## 3   1   0 0.01   1     1  0.01         0     0  0.01  0.01      0    100
    ## 4   1   0 0.01   1     1  0.01         0     0  0.00  0.00      0     20
    ## 5   1   0 0.01   1     1  0.01         0     0  0.00  0.00      0     30
    ## 6   1   0 0.01   1     1  0.01         0     0  0.00  0.00      0     40
    ##   sampleid
    ## 1        0
    ## 2       10
    ## 3      100
    ## 4       20
    ## 5       30
    ## 6       40

``` r
# Plotting
g_bar_av_TEs <- ggplot(df2, aes(x = sampleid, y = avtes)) +
  geom_boxplot() +
  ggtitle("Insertions at 0th generations") +
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

# Plot the graph
plot(g_bar_av_TEs)
```

![](Validation_7_insertion_files/figure-gfm/data-plotting-1.png)<!-- -->

# Conclusion

— The validation matches our expectations and the insertion is working
as expected.

# Session Info

    ## R version 4.2.1 (2022-06-23)
    ## Platform: aarch64-apple-darwin20 (64-bit)
    ## Running under: macOS Ventura 13.4.1
    ## 
    ## Matrix products: default
    ## BLAS:   /Library/Frameworks/R.framework/Versions/4.2-arm64/Resources/lib/libRblas.0.dylib
    ## LAPACK: /Library/Frameworks/R.framework/Versions/4.2-arm64/Resources/lib/libRlapack.dylib
    ## 
    ## locale:
    ## [1] en_US.UTF-8/en_US.UTF-8/en_US.UTF-8/C/en_US.UTF-8/en_US.UTF-8
    ## 
    ## attached base packages:
    ## [1] stats     graphics  grDevices utils     datasets  methods   base     
    ## 
    ## other attached packages:
    ##  [1] lubridate_1.9.2 forcats_1.0.0   dplyr_1.1.2     tidyr_1.3.0    
    ##  [5] tibble_3.2.1    ggplot2_3.4.2   tidyverse_2.0.0 purrr_1.0.1    
    ##  [9] stringr_1.5.0   readr_2.1.4    
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] highr_0.10       pillar_1.9.0     compiler_4.2.1   tools_4.2.1     
    ##  [5] digest_0.6.31    timechange_0.2.0 evaluate_0.21    lifecycle_1.0.3 
    ##  [9] gtable_0.3.3     pkgconfig_2.0.3  rlang_1.1.1      cli_3.6.1       
    ## [13] rstudioapi_0.14  yaml_2.3.7       xfun_0.39        fastmap_1.1.1   
    ## [17] withr_2.5.0      knitr_1.43       generics_0.1.3   vctrs_0.6.3     
    ## [21] hms_1.1.3        grid_4.2.1       tidyselect_1.2.0 glue_1.6.2      
    ## [25] R6_2.5.1         fansi_1.0.4      rmarkdown_2.22   farver_2.1.1    
    ## [29] tzdb_0.4.0       magrittr_2.0.3   scales_1.2.1     htmltools_0.5.5 
    ## [33] colorspace_2.1-0 labeling_0.4.2   utf8_1.2.3       stringi_1.7.12  
    ## [37] munsell_0.5.0
