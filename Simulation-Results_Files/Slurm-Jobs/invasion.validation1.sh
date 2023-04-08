#!/bin/bash

#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1
#SBATCH --time=1:00:00
#SBATCH --mem=8000mb
#SBATCH --job-name=validation1
#SBATCH --error=job.%J.err
#SBATCH --output=job.%J.out

tool="./main"
N=1000
gen=100
genome="mb:1"
cluster="kb:0"
rr="4"
rep=500
u=0.1
steps=1
folder="Simulation-Results/Insertion-Bias/validation_1"

output_file="$folder/$(date +%Y_%m_%d)_Validation_1_invasion.txt"
command="$tool --N $N --gen $gen --genome $genome --cluster $cluster --rr $rr --rep $rep --u $u --basepop \"10(0)\" --silent --steps $steps > $output_file"
echo "Running command: $command"
eval "$command"
