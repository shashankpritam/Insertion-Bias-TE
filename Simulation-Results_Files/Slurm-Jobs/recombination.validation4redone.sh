#!/bin/bash

#SBATCH --cpus-per-task=4
#SBATCH --ntasks=1
#SBATCH --time=1-00:00:00
#SBATCH --mem=32000mb
#SBATCH --job-name=validation4redone
#SBATCH --error=job.%A.%a.err
#SBATCH --output=job.%A.%a.out


# Create Input Basepop File
input_file="input_LD"
echo "10000; 0(0) 999999(0);" > $input_file

# Parameters
tool="./main"
folder="Simulation-Results/Insertion-Bias/validation_4_redone"
N=10000
u=0
basepop="file:$input_file"
gen=150
genome="mb:1"
steps=1
rep=100

# Commands
for rr in 0 1 5 10
do
  debug_file="$folder/validation_4_redone_${rr}_debug"
  output_file="$folder/validation_4_redone_${rr}"
  
  $tool --N $N --u $u --basepop $basepop --file-debug $debug_file --gen $gen --genome $genome --steps $steps --rr $rr --rep $rep > $output_file
done
