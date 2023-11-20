#!/bin/bash
#SBATCH --job-name=phase_simulation_job
#SBATCH --output=phase_simulation_output.log
#SBATCH --ntasks=4
#SBATCH --cpus-per-task=1
#SBATCH --time=10-00:00:00
#SBATCH --mem=64G


# Run your script
python3 sim_storm.py --steps 1
