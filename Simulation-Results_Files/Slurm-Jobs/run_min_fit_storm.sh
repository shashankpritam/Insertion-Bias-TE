#!/bin/bash
#SBATCH --job-name=min_fitness
#SBATCH --output=min_fitness_%A_%a.log
#SBATCH --time=10-00:00:00
#SBATCH --ntasks=64
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=4G

python3 /storehouse/shashank/validinvadego/sim_storm.py --number 10000 --threads 64 --silent
