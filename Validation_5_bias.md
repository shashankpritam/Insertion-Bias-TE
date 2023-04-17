Validation of Insertion Bias
================
Shashank Pritam

## Introduction


## Scenarios





## Materials & Methods

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


## Conclusions
