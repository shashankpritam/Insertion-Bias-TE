#!/bin/bash

tool="~/github/invadego-insertionbias/main"
N=1000
gen=5000
genome="mb:10,10,10,10,10"
cluster="kb:300,300,300,300,300"
rr="4,4,4,4,4"
rep=100
u=0.1
steps=1
folder="../simulation_storm/phase_len"
max_jobs=8  # Limit to 8 parallel jobs for an 8-core system

# Create the output folder if it doesn't exist
mkdir -p "$folder"

for i in -5 0 5; do
  while (( $(jobs -r | wc -l) >= max_jobs )); do
    sleep 1
  done

  multiplier=$(( i * 10 ))

  if [ $i -lt 0 ]; then
    sampleid="bm${multiplier#-}"
  else
    sampleid="b${multiplier}"
  fi

  basepop="10($multiplier)"
  output_file="$folder/$(date +%Y_%m_%d)_simulation_0_${sampleid}"

  command="$tool --N $N --gen $gen --genome $genome --cluster $cluster --rr $rr --rep $rep --u $u --basepop \"$basepop\" --steps $steps --sampleid $sampleid > $output_file"
  echo "Running command: $command"
  eval "$command" &
done

wait

cat "$folder"/$(date +%Y_%m_%d)_simulation_0_* | grep -v "^Invade" | grep -v "^#" > "$folder"/$(date +%Y_%m_%d)_Simulation_0_exploration
