Validation of Insertion Bias
================
Shashank Pritam


## Introduction

With this simulation we wanted to understand the impact of the insertion
bias on the transposable elements invasion dynamics.

### Initial conditions:

A population of 1000, 5 chromosomes of size 10 Mb, 5 piRNA clusters of
size 300 Kb and an initial number of TEs in the population equal to 10.

We used 1000 replicates for the establishment probability simulation.

We used 100 replicates for the other simulations.

## Materials & Methods

version: invadego-insertionbias

- seed bm90: 
- seed bm80: 
- seed bm70: 
- seed bm60: 
- seed bm50: 
- seed bm40: 
- seed bm30: 
- seed bm20: 
- seed bm10: 
- seed b0: 
- seed b10: 
- seed b20: 
- seed b30: 
- seed b40: 
- seed b50: 
- seed b60: 
- seed b70: 
- seed b80: 
- seed b90: 




version: invadego 0.1.3

### Commands for the simulation:

``` bash
tool="./main"
N=1000
gen=500
genome="mb:10,10,10,10,10"
cluster="kb:300,300,300,300,300"
rr="4,4,4,4,4"
rep=1000
u=0.1
steps=500
folder="Simulation-Results/Insertion-Bias/validation_5.1"

for i in {-9..9}; do
  i=$(($i * 10))

  if (( $i < 0 )); then
    sampleid="mb$(($i * -1))"
  else
    sampleid="b$(($i))"
  fi

  basepop="10($i)"
  output_file="$folder/$(date +%Y_%m_%d)_simulation_0_m100_500gen_basepop_$i"
  command="$tool --N $N --gen $gen --genome $genome --cluster $cluster --rr $rr --rep $rep --u $u --basepop \"$basepop\" --steps $steps --sampleid $sampleid > $output_file"
  echo "Running command: $command"
  eval "$command" &
done

# wait for all simulations to finish
wait

# concatenate output files with system date
for i in {-9..9}; do
  i=$(($i * 10))
  cat "$folder"/"$(date +%Y_%m_%d)"_simulation_*"$i"* | grep -v "^Invade" | grep -v "^#" > "$folder"/"$(date +%Y_%m_%d)"_Simulation_"$i"_500_gen_exploration
done

```

### Visualization in R

Setting the environment

``` r
library(tidyverse)
library(RColorBrewer)
library(ggpubr)
theme_set(theme_bw())
```

Visualization:

``` r


## Conclusions
