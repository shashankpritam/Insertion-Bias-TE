# Simulation Storm
Shashank Pritam

- [<span class="toc-section-number">1</span>
  Introduction](#introduction)
  - [<span class="toc-section-number">1.1</span> Initial
    conditions:](#initial-conditions)
- [<span class="toc-section-number">2</span> Materials &
  Methods](#materials-methods)
  - [<span class="toc-section-number">2.1</span> Commands for the
    simulation:](#commands-for-the-simulation)
  - [<span class="toc-section-number">2.2</span> Visualization in
    R](#visualization-in-r)

## Introduction

With this simulation we wanted to understand the role of insertion bias
on minimum fitness during a TEs invasion.

### Initial conditions:

A population of 1000, 5 chromosomes of size 10 Mb

Every dot in the red to green gradient is a simulation at generation
5000, or less if it failed. If it failed due to the extinction of the
population the dot will be white, if it failed because all TEs were
removed from the population it will be grey.

## Materials & Methods

version: invadego0.1.3

### Commands for the simulation:

The simulations were generated using the code from:

- simstorm_para_vs_selection
- simstorm_para_vs_clusters

### Visualization in R

#### Setting the environment

<details>
<summary>Code</summary>

``` r
library(tidyverse)
```

</details>

    ── Attaching core tidyverse packages ──────────────────────── tidyverse 2.0.0 ──
    ✔ dplyr     1.1.2     ✔ readr     2.1.4
    ✔ forcats   1.0.0     ✔ stringr   1.5.0
    ✔ ggplot2   3.4.2     ✔ tibble    3.2.1
    ✔ lubridate 1.9.2     ✔ tidyr     1.3.0
    ✔ purrr     1.0.1     
    ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
    ✖ dplyr::filter() masks stats::filter()
    ✖ dplyr::lag()    masks stats::lag()
    ℹ Use the conflicted package (<http://conflicted.r-lib.org/>) to force all conflicts to become errors

<details>
<summary>Code</summary>

``` r
library(RColorBrewer)
library(ggplot2)
library(patchwork)
theme_set(theme_bw())
```

</details>

#### Data loading and parsing

<details>
<summary>Code</summary>

``` r
# Define column names
column_names <- c("rep", "gen", "popstat", "spacer_1", "fwte", "avw", "min_w", "avtes", "avpopfreq",
                "fixed", "spacer_2", "phase", "fwcli", "avcli", "fixcli", "spacer_3",
                "avbias", "3tot", "3cluster", "spacer_4", "sampleid")

# Load DataFrame with column names
df <- read_delim('/Users/shashankpritam/github/Insertion-Bias-TE/Simulation-Results_Files/simulation_storm/07thAug23at0626PM/combined.txt', delim='\t', col_names = column_names)
```

</details>

    Rows: 200 Columns: 26
    ── Column specification ────────────────────────────────────────────────────────
    Delimiter: "\t"
    chr  (8): popstat, spacer_1, spacer_2, phase, spacer_3, 3tot, 3cluster, spac...
    dbl (17): rep, gen, fwte, avw, min_w, avtes, avpopfreq, fixed, fwcli, avcli,...
    lgl  (1): X26

    ℹ Use `spec()` to retrieve the full column specification for this data.
    ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

<details>
<summary>Code</summary>

``` r
# Convert the columns to numeric
numeric_columns <- c("rep", "gen", "fwte", "avw", "min_w", "avtes", "avpopfreq",
                   "fixed", "fwcli", "avcli", "fixcli",
                   "avbias", "sampleid")

df[numeric_columns] <- lapply(df[numeric_columns], function(x) as.numeric(as.character(x)))
```

</details>

#### Visualization:

<details>
<summary>Code</summary>

``` r
print(df, n = Inf)
```

</details>

    # A tibble: 200 × 26
          rep   gen popstat spacer_1  fwte   avw min_w avtes avpopfreq fixed
        <dbl> <dbl> <chr>   <chr>    <dbl> <dbl> <dbl> <dbl>     <dbl> <dbl>
      1     0     0 ok      |         0.09  1     1     0.1       0        0
      2     0   394 fail-0  |         0     1     1     0       NaN        0
      3     1     0 ok      |         0.1   1     1     0.1       0        0
      4     1  3308 fail-0  |         0     1     1     0       NaN        0
      5     2     0 ok      |         0.09  1     1     0.1       0        0
      6     2  5000 ok      |         1     1     0.82  6         1        3
      7     3     0 ok      |         0.1   1     1     0.1       0        0
      8     3  5000 ok      |         1     1     0.97  2         1        1
      9     4     0 ok      |         0.1   1     1     0.1       0        0
     10     4  5000 ok      |         1     1     0.59  3.09      0.77     1
     11     5     0 ok      |         0.09  1     1     0.1       0        0
     12     5  5000 ok      |         0.99  1     0.99  1.8       0.9      0
     13     6     0 ok      |         0.1   1     1     0.1       0        0
     14     6  5000 ok      |         1     1     0.62  5.52      0.69     2
     15     7     0 ok      |         0.09  1     1     0.1       0        0
     16     7  5000 ok      |         1     1     0.98  4.8       0.8      2
     17     8     0 ok      |         0.09  1     1     0.1       0        0
     18     8  5000 ok      |         1     1     0.92  8.23      0.59     3
     19     9     0 ok      |         0.09  1     1     0.1       0        0
     20     9  5000 ok      |         1     1     1     2         1        1
     21    10     0 ok      |         0.09  1     1     0.1       0        0
     22    10   759 fail-0  |         0     1     1     0       NaN        0
     23    11     0 ok      |         0.1   1     1     0.1       0        0
     24    11  5000 ok      |         0.81  1     0.99  1.15      0.57     0
     25    12     0 ok      |         0.1   1     1     0.1       0        0
     26    12  5000 ok      |         1     1     0.99  8         1        4
     27    13     0 ok      |         0.09  1     1     0.1       0        0
     28    13  5000 ok      |         1     1     0.97  5         0.83     1
     29    14     0 ok      |         0.09  1     1     0.1       0        0
     30    14  5000 ok      |         1     1     1     2         1        1
     31    15     0 ok      |         0.1   1     1     0.1       0        0
     32    15  5000 ok      |         1     1     0.98  4         1        2
     33    16     0 ok      |         0.1   1     1     0.1       0        0
     34    16  5000 ok      |         1     1     0.99  1.96      0.98     0
     35    17     0 ok      |         0.09  1     1     0.1       0        0
     36    17   910 fail-0  |         0     1     1     0       NaN        0
     37    18     0 ok      |         0.09  1     1     0.1       0        0
     38    18  2646 fail-0  |         0     1     1     0       NaN        0
     39    19     0 ok      |         0.1   1     1     0.1       0        0
     40    19  5000 ok      |         1     1     0.98  5.79      0.58     2
     41    20     0 ok      |         0.1   1     1     0.1       0        0
     42    20  5000 ok      |         0.94  1     0.89  1.51      0.76     0
     43    21     0 ok      |         0.1   1     1     0.1       0        0
     44    21   557 fail-0  |         0     1     1     0       NaN        0
     45    22     0 ok      |         0.09  1     1     0.1       0        0
     46    22  5000 ok      |         1     1     0.99  7.76      0.78     2
     47    23     0 ok      |         0.1   1     1     0.1       0        0
     48    23   270 fail-0  |         0     1     1     0       NaN        0
     49    24     0 ok      |         0.09  1     1     0.1       0        0
     50    24  5000 ok      |         1     1     0.83  7.83      0.78     3
     51    25     0 ok      |         0.1   1     1     0.1       0        0
     52    25  5000 ok      |         1     1     0.88  5.38      0.67     2
     53    26     0 ok      |         0.1   1     1     0.1       0        0
     54    26  5000 ok      |         1     1     0.98  1.92      0.96     0
     55    27     0 ok      |         0.09  1     1     0.1       0        0
     56    27  5000 ok      |         1     1     1     4.68      0.78     1
     57    28     0 ok      |         0.1   1     1     0.1       0        0
     58    28  2527 fail-0  |         0     1     1     0       NaN        0
     59    29     0 ok      |         0.1   1     1     0.1       0        0
     60    29  1732 fail-0  |         0     1     1     0       NaN        0
     61    30     0 ok      |         0.1   1     1     0.1       0        0
     62    30  5000 ok      |         1     1     0.79  7.31      0.73     3
     63    31     0 ok      |         0.1   1     1     0.1       0        0
     64    31  5000 ok      |         1     1     0.9   4.31      0.72     1
     65    32     0 ok      |         0.1   1     1     0.1       0        0
     66    32  5000 ok      |         1     1     0.73  6         1        3
     67    33     0 ok      |         0.1   1     1     0.1       0        0
     68    33  5000 ok      |         1     1     1     2         1        1
     69    34     0 ok      |         0.09  1     1     0.1       0        0
     70    34  5000 ok      |         1     1     0.99  3.29      0.82     1
     71    35     0 ok      |         0.09  1     1     0.1       0        0
     72    35  1601 fail-0  |         0     1     1     0       NaN        0
     73    36     0 ok      |         0.1   1     1     0.1       0        0
     74    36  5000 ok      |         0.95  1     0.12  2.05      0.51     0
     75    37     0 ok      |         0.1   1     1     0.1       0        0
     76    37    85 fail-0  |         0     1     1     0       NaN        0
     77    38     0 ok      |         0.09  1     1     0.1       0        0
     78    38  5000 ok      |         1     1     0.98  2         1        1
     79    39     0 ok      |         0.09  1     1     0.1       0        0
     80    39  5000 ok      |         1     1     0.88  4         1        2
     81    40     0 ok      |         0.1   1     1     0.1       0        0
     82    40  5000 ok      |         0.88  1     1     1.3       0.65     0
     83    41     0 ok      |         0.1   1     1     0.1       0        0
     84    41  5000 ok      |         1     1     0.89  2.27      0.57     1
     85    42     0 ok      |         0.09  1     1     0.1       0        0
     86    42  5000 ok      |         1     1     0.33  5.84      0.73     1
     87    43     0 ok      |         0.1   1     1     0.1       0        0
     88    43  5000 ok      |         1     1     0.57  4         1        2
     89    44     0 ok      |         0.1   1     1     0.1       0        0
     90    44  5000 ok      |         1     1     0.92  4         1        2
     91    45     0 ok      |         0.09  1     1     0.1       0        0
     92    45  2506 fail-0  |         0     1     1     0       NaN        0
     93    46     0 ok      |         0.1   1     1     0.1       0        0
     94    46  5000 ok      |         1     1     0.72  2         1        1
     95    47     0 ok      |         0.09  1     1     0.1       0        0
     96    47  5000 ok      |         1     1     0.98  2.51      0.63     1
     97    48     0 ok      |         0.1   1     1     0.1       0        0
     98    48  5000 ok      |         1     1     0.99  3.52      0.88     1
     99    49     0 ok      |         0.09  1     1     0.1       0        0
    100    49  5000 ok      |         0.98  1     0.98  2.17      0.54     0
    101    50     0 ok      |         0.1   1     1     0.1       0        0
    102    50  5000 ok      |         0.93  1     0.99  1.48      0.74     0
    103    51     0 ok      |         0.1   1     1     0.1       0        0
    104    51  5000 ok      |         1     1     0.46  4         1        2
    105    52     0 ok      |         0.1   1     1     0.1       0        0
    106    52   149 fail-0  |         0     1     1     0       NaN        0
    107    53     0 ok      |         0.09  1     1     0.1       0        0
    108    53  2028 fail-0  |         0     1     1     0       NaN        0
    109    54     0 ok      |         0.09  1     1     0.1       0        0
    110    54  5000 ok      |         1     1     0.86  4         1        2
    111    55     0 ok      |         0.09  1     1     0.1       0        0
    112    55  1097 fail-0  |         0     1     1     0       NaN        0
    113    56     0 ok      |         0.1   1     1     0.1       0        0
    114    56   122 fail-0  |         0     1     1     0       NaN        0
    115    57     0 ok      |         0.1   1     1     0.1       0        0
    116    57  5000 ok      |         1     1     0.97  3.59      0.6      1
    117    58     0 ok      |         0.09  1     1     0.1       0        0
    118    58  5000 ok      |         1     1     0.99  4         1        2
    119    59     0 ok      |         0.1   1     1     0.1       0        0
    120    59   584 fail-0  |         0     1     1     0       NaN        0
    121    60     0 ok      |         0.1   1     1     0.1       0        0
    122    60  3777 fail-0  |         0     1     0.99  0       NaN        0
    123    61     0 ok      |         0.09  1     1     0.1       0        0
    124    61  5000 ok      |         1     1     0.9   9.93      0.99     4
    125    62     0 ok      |         0.1   1     1     0.1       0        0
    126    62  5000 ok      |         1     1     0.84  4.02      0.67     2
    127    63     0 ok      |         0.1   1     1     0.1       0        0
    128    63  1763 fail-0  |         0     1     1     0       NaN        0
    129    64     0 ok      |         0.1   1     1     0.1       0        0
    130    64  5000 ok      |         1     1     0.79  4         1        2
    131    65     0 ok      |         0.1   1     1     0.1       0        0
    132    65  5000 ok      |         1     1     0.91  3.49      0.58     0
    133    66     0 ok      |         0.1   1     1     0.1       0        0
    134    66    43 fail-w  |         1     0.05  0.05 98.2       0        0
    135    67     0 ok      |         0.1   1     1     0.1       0        0
    136    67   221 fail-0  |         0     1     1     0       NaN        0
    137    68     0 ok      |         0.1   1     1     0.1       0        0
    138    68   219 fail-0  |         0     1     1     0       NaN        0
    139    69     0 ok      |         0.1   1     1     0.1       0        0
    140    69  5000 ok      |         1     1     0.94  8         1        3
    141    70     0 ok      |         0.1   1     1     0.1       0        0
    142    70  4877 fail-0  |         0     1     0.98  0       NaN        0
    143    71     0 ok      |         0.1   1     1     0.1       0        0
    144    71    71 fail-0  |         0     1     1     0       NaN        0
    145    72     0 ok      |         0.09  1     1     0.1       0        0
    146    72  5000 ok      |         1     1     0.51  2.97      0.74     0
    147    73     0 ok      |         0.09  1     1     0.1       0        0
    148    73   111 fail-0  |         0     1     1     0       NaN        0
    149    74     0 ok      |         0.1   1     1     0.1       0        0
    150    74  5000 ok      |         1     1     0.41  8         1        4
    151    75     0 ok      |         0.1   1     1     0.1       0        0
    152    75  5000 ok      |         1     1     0.71  4.48      0.75     2
    153    76     0 ok      |         0.09  1     1     0.1       0        0
    154    76   125 fail-0  |         0     1     1     0       NaN        0
    155    77     0 ok      |         0.1   1     1     0.1       0        0
    156    77  5000 ok      |         1     1     0.97  4.45      0.74     2
    157    78     0 ok      |         0.09  1     1     0.1       0        0
    158    78  5000 ok      |         1     1     0.97  6         1        3
    159    79     0 ok      |         0.1   1     1     0.1       0        0
    160    79  1894 fail-0  |         0     1     1     0       NaN        0
    161    80     0 ok      |         0.09  1     1     0.1       0        0
    162    80  5000 ok      |         1     1     0.77 10         1        5
    163    81     0 ok      |         0.1   1     1     0.1       0        0
    164    81  5000 ok      |         1     1     0.89  2.85      0.71     1
    165    82     0 ok      |         0.1   1     1     0.1       0        0
    166    82   372 fail-0  |         0     1     1     0       NaN        0
    167    83     0 ok      |         0.1   1     1     0.1       0        0
    168    83  5000 ok      |         1     1     0.96  3.98      0.66     1
    169    84     0 ok      |         0.09  1     1     0.1       0        0
    170    84  5000 ok      |         0.12  1     1     0.12      0.06     0
    171    85     0 ok      |         0.1   1     1     0.1       0        0
    172    85  5000 ok      |         1     1     0.8   5.04      0.63     1
    173    86     0 ok      |         0.09  1     1     0.1       0        0
    174    86  5000 ok      |         1     1     0.99  4         1        2
    175    87     0 ok      |         0.1   1     1     0.1       0        0
    176    87  5000 ok      |         1     1     0.58  4.93      0.82     2
    177    88     0 ok      |         0.09  1     1     0.1       0        0
    178    88  5000 ok      |         1     1     0.96  5.94      0.99     2
    179    89     0 ok      |         0.09  1     1     0.1       0        0
    180    89  5000 ok      |         1     1     1     2.13      0.53     1
    181    90     0 ok      |         0.09  1     1     0.1       0        0
    182    90  5000 ok      |         0.45  1     1     0.55      0.14     0
    183    91     0 ok      |         0.1   1     1     0.1       0        0
    184    91  5000 ok      |         1     1     0.96  7.27      0.91     2
    185    92     0 ok      |         0.1   1     1     0.1       0        0
    186    92  5000 ok      |         1     1     0.92  4.02      0.67     1
    187    93     0 ok      |         0.1   1     1     0.1       0        0
    188    93  4191 fail-0  |         0     1     1     0       NaN        0
    189    94     0 ok      |         0.1   1     1     0.1       0        0
    190    94  5000 ok      |         1     1     0.96  2.78      0.46     1
    191    95     0 ok      |         0.1   1     1     0.1       0        0
    192    95  5000 ok      |         1     1     0.62 13.4       0.96     6
    193    96     0 ok      |         0.1   1     1     0.1       0        0
    194    96  1406 fail-0  |         0     1     1     0       NaN        0
    195    97     0 ok      |         0.1   1     1     0.1       0        0
    196    97    48 fail-0  |         0     1     1     0       NaN        0
    197    98     0 ok      |         0.1   1     1     0.1       0        0
    198    98  5000 ok      |         1     1     0.98  7.81      0.98     3
    199    99     0 ok      |         0.09  1     1     0.1       0        0
    200    99  5000 ok      |         1     1     0.73  4         1        2
    # ℹ 16 more variables: spacer_2 <chr>, phase <chr>, fwcli <dbl>, avcli <dbl>,
    #   fixcli <dbl>, spacer_3 <chr>, avbias <dbl>, `3tot` <chr>, `3cluster` <chr>,
    #   spacer_4 <chr>, sampleid <dbl>, X22 <dbl>, X23 <dbl>, X24 <dbl>, X25 <dbl>,
    #   X26 <lgl>
