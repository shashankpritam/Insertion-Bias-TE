#!/bin/bash

# Constants
FOLDER="Simulation-Results/SimStorm"

# Submit all jobs
for i in {1..10}
do
    sbatch simjob.sh $i
done

# Wait for all jobs to finish
while squeue -u $USER | grep -q "simulationstorm"
do
    sleep 60
done

# Combine all results
cat $FOLDER/combined_results_*.out > $FOLDER/final_combined_results.out
