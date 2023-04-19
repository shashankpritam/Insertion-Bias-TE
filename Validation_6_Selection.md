Validation of selection
================
Shashank Pritam

## Introduction

In this validation we wanted to test if selection was correctly
implemented.

To do so we tested different scenarios:

### Selection on all TEs vs selection on non-cluster TEs

-   selection on all TEs, seed: 1681861465699864962

-   selection only on non-cluster TEs, seed: 1681861465699845626

### Different selection coefficients on the same population:

x is the selection coefficient.

-   x = 0, seed: 1681861465699884772

-   x = 0.1, seed: 1681861465699187921

-   x = 0.01, seed: 1681861465700839399

-   x = 0.001, seed: 1681861465700022715

-   x = 0.0001, seed: 1681861465700131683

## Materials & Methods

version: invadego 0.1.3

### Commands for the simulation:

``` bash

tool="./main"
folder="Simulation-Results/Insertion-Bias/validation_6"
genome="mb:1"
rep=100

$tool --N 1000 --gen 100 --genome $genome --cluster kb:100 --rr 4 --rep $rep --u 0.1 --basepop "100(0)" --steps 25 -x 0.1 --file-mhp $folder/validation_6_1_mhp > $folder/validation_6_1 &

$tool --N 1000 --gen 100 --genome $genome --cluster kb:100 --rr 4 --rep $rep --u 0.1 --basepop "100(0)" --steps 25 -x 0.1 -no-x-cluins --file-mhp $folder/validation_6_2_mhp > $folder/validation_6_2 &

$tool --N 10000 --u 0 --basepop "10000(0)" --gen 1000 --genome $genome --steps 10 --rr 0 --rep $rep --sampleid psel3 > $folder/validation_6_3 &

$tool --N 10000 --u 0 -x 0.1 --basepop "10000(0)" --gen 1000 --genome $genome --steps 10 --rr 0 --rep $rep --sampleid psel4 > $folder/validation_6_4 &

$tool --N 10000 --u 0 -x 0.01 --basepop "10000(0)" --gen 1000 --genome $genome --steps 10 --rr 0 --rep $rep --sampleid psel5 > $folder/validation_6_5 &

$tool --N 10000 --u 0 -x 0.001 --basepop "10000(0)" --gen 1000 --genome $genome --steps 10 --rr 0 --rep $rep --sampleid psel6 > $folder/validation_6_6 &

$tool --N 10000 --u 0 -x 0.0001 --basepop "10000(0)" --gen 1000 --genome $genome --steps 10 --rr 0 --rep $rep --sampleid psel7 > $folder/validation_6_7 &

# Wait for all simulations to finish
wait

# Concatenate output files
cat "$folder/validation_6_3" "$folder/validation_6_4" "$folder/validation_6_5" "$folder/validation_6_6" "$folder/validation_6_7" | grep -v "^Invade" | grep -v "^#" > "$folder/2023_04_19_Validation_6_Selection"


```

### Visualization in R

Setting the environment

``` r
library(ggplot2)
```

# Selection vs selection on non-cluster insertions

``` r
```

<img src="images/2023_04_19_Validation_6a_selection.png" alt="6A.">

``` r
t_1_2<-read.table("validation_6_1_mhp", fill = TRUE, sep = "\t")
```

<img src="images/2023_04_19_Validation_6b_selection.png" alt="6B.">

``` r
t_2<-read.table("validation_6_2_mhp", fill = TRUE, sep = "\t")
```

<img src="images/2023_04_19_Validation_6c_selection.png" alt="6C.">

``` r
t_2_2<-read.table("validation_6_2_mhp", fill = TRUE, sep = "\t")
```

<img src="images/2023_04_19_Validation_6d_selection.png" alt="6D.">

Selection can act on all TEs insertion, as in the first case or only in
non-cluster TEs insertions in the latter. The reason being is that
cluster insertions generate piRNAs. Therefore make sense to not consider
selection upon cluster insertion in some models. From the two pairs of
histograms is easy to see the difference: in the first case all TEs tend
to be lost, while in the second only non cluster TEs are lost, while
cluster insertions are maintained.

``` r
df_sel<-read.table("2023_04_19_Validation_6_Selection", fill = TRUE, sep = "\t")
```

<img src="images/2023_04_19_Validation_6e_selection.png" alt="6E.">


``` r
df3_s<-subset(df_sel, sampleid=="psel3")
```

<img src="images/2023_04_19_Validation_6f_selection.png" alt="6F.">

``` r
df4_s<-subset(df_sel, sampleid=="psel4")
```

<img src="images/2023_04_19_Validation_6g_selection.png" alt="6G.">

``` r
df5_s<-subset(df_sel, sampleid=="psel5")
```

<img src="images/2023_04_19_Validation_6h_selection.png" alt="6H.">

``` r
df6_s<-subset(df_sel, sampleid=="psel6")
```

<img src="images/2023_04_19_Validation_6i_selection.png" alt="6I.">

``` r
df7_s<-subset(df_sel, sampleid=="psel7")
```

<img src="images/2023_04_19_Validation_6j_selection.png" alt="6J.">

``` r
ggarrange(g_s_3, g_s_7, g_s_6, g_s_5, g_s_4,
          ncol = 3, nrow = 2, align = ("v"),
          labels = c("A", "B", "C", "D", "E"), heights = c(2,2), widths = c(2,2)
)
```

<img src="images/2023_04_19_Validation_6k_selection.png" alt="6K.">

The simulations match the expected values (blue line).

As we expected in the first set of graphs we can see how an higher
selection coefficient decrease the number of generations needed to lose
all the TEs in the population. But if the selection coefficient is too
small (A and B) drift will prevail.

Selection is linked to population size and to be effective it has to
meet the requirements from the following equation:
> N*x > 1

Thus in small populations the predominant force is not selection but
drift.

## Conclusions

<del>The simulation matched our expectations.
Selection in the simulations follows the theoretical expectations.