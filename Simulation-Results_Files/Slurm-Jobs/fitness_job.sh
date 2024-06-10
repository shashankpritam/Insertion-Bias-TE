#!/bin/bash
#SBATCH --job-name=fitness
#SBATCH --output=fitness.log
#SBATCH --ntasks=32
#SBATCH --cpus-per-task=2
#SBATCH --time=10-00:00:00
#SBATCH --mem=32G

# Configuration parameters
tool="./main"
N=1000
gen=5000
genome="mb:10,10,10,10,10"
cluster="kb:300,300,300,300,300"
rr="4,4,4,4,4"
rep=100
u=0.1
steps=1
folder="./fitness_ncs"
x=0.01
max_jobs=64

# Ensure the output folder exists
mkdir -p "$folder"

# Running simulations for base population multipliers
for i in -5 0 5; do
  # Limit the number of concurrent jobs
  while (( $(jobs -r | wc -l) >= max_jobs )); do
    sleep 1
  done

  # Calculate multiplier and define sample ID
  multiplier=$(( i * 10 ))
  sampleid=$(printf "b%d" $multiplier)
  sampleid=${sampleid/#b-/bm}  # Proper formatting for negative numbers

  # Set base population
  basepop="10($multiplier)"
  output_file="$folder/fitness_${sampleid}.log"

  # Construct the command
  command="$tool --N $N --gen $gen --genome $genome --cluster $cluster --no-x-cluins --rr $rr --rep $rep --u $u --basepop \"$basepop\" --steps $steps --sampleid $sampleid --x $x"

  # Run the simulation
  echo "Running command: $command"
  eval "$command > $output_file" &
done

# Wait for all background jobs to finish
wait

# Aggregate results
cat "$folder"/fitness_*.log | grep -v "^Invade" | grep -v "^#" > "$folder/fitness_Simulation_exploration.txt"
