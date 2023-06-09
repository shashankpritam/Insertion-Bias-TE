#!/bin/bash
#SBATCH --cpus-per-task=4
#SBATCH --ntasks=1
#SBATCH --time=8-00:00:00
#SBATCH --mem=128000mb
#SBATCH --job-name=validation7
#SBATCH --error=job.%A.err
#SBATCH --output=job.%A.out




tool="./main"
folder="Simulation-Results/Insertion-Bias/validation_7"