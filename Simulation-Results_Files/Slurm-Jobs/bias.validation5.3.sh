#!/bin/bash

#SBATCH --cpus-per-task=4
#SBATCH --ntasks=1
#SBATCH --time=8-00:00:00
#SBATCH --mem=128000mb
#SBATCH --job-name=validation5.3
#SBATCH --error=job.%A.err
#SBATCH --output=job.%A.out

tool="./main"
N=1000
gen=5000
genome="mb:10,10,10,10,10"
cluster="kb:300,300,300,300,300"
rr="4,4,4,4,4"
rep=100
u=0.1
steps=20
folder="Simulation-Results/Insertion-Bias/validation_5.2"

i=-90
sampleid="bm90"
basepop="10(-90)"
output_file="$folder/$(date +%Y_%m_%d)_simulation_0_${sampleid}"
command="$tool --N $N --gen $gen --genome $genome --cluster $cluster --rr $rr --rep $rep --u $u --basepop \"$basepop\" --steps $steps --sampleid $sampleid > $output_file"
echo "Running command: $command"
eval "$command"

# concatenate output files with system date
cat $folder/*_simulation_0_* | grep -v "^Invade" | grep -v "^#" > $folder/$(date +%Y_%m_%d)_Simulation_0_exploration
