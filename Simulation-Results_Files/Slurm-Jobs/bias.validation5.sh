#!/bin/bash

#SBATCH --cpus-per-task=4
#SBATCH --ntasks=1
#SBATCH --time=4-00:00:00
#SBATCH --mem=32000mb
#SBATCH --job-name=validation5
#SBATCH --error=job.%A.%a.err
#SBATCH --output=job.%A.%a.out
#SBATCH --array=1-19%1

tool="./main"
N=1000
gen=500
genome="mb:10,10,10,10,10"
cluster="kb:300,300,300,300,300"
rr="4,4,4,4,4"
rep=1000
u=0.1
steps=500
folder="Simulation-Results/Insertion-Bias/validation_5"

i=$(($SLURM_ARRAY_TASK_ID * -10)) # calculate the value of i based on the job array index

if (( $i < 0 )); then
  sampleid="mb$(($i * -1))" # add 'b' character and 'm' prefix for negative values of i
else
  sampleid="b$(($i))" # add 'b' character for positive values of i
fi

basepop="10($i)"
output_file="$folder/$(date +%Y_%m_%d)_simulation_0_m100_500gen_basepop_$i.log"
command="$tool --N $N --gen $gen --genome $genome --cluster $cluster --rr $rr --rep $rep --u $u --basepop \"$basepop\" --steps $steps --sampleid $sampleid > $output_file"
echo "Running command: $command"
eval "$command" &

# wait for all simulations to finish
wait

# concatenate output files with system date
cat "$folder"/"$(date +%Y_%m_%d)"_simulation_*"$i"* | grep -v "^Invade" | grep -v "^#" > "$folder"/"$(date +%Y_%m_%d)"_Simulation_"$i"_500_gen_exploration
