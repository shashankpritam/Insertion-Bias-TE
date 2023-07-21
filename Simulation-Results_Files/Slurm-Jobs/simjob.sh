#!/bin/bash

#SBATCH --job-name=simulationstorm
#SBATCH --output=simulationstorm_%A_%a.out
#SBATCH --array=0-999
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=32000mb
#SBATCH --time=4-00:00:00

#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=shashank.pritam@ndus.edu


# Constants
TOOL="./main"
GENOME="mb:1,1,1,1,1"
CLUSTER="kb:30,30,30,30,30"
REP=100
GEN=100
STEPS=1
RR="0,0,0,0,0"
FOLDER="Simulation-Results/SimStorm"
i=$1  # This captures the argument passed when this script is submitted

# Create folder
mkdir -p $FOLDER

# For each subtask
for j in {0..999}
do
    # Generate unique seed based on date and task
    SEED=$(date +%N)$SLURM_ARRAY_TASK_ID$i$j

    # Generate random parameters
    N=$(shuf -i 50000-200000 -n 1 --random-source=<(echo $SEED))
    BIAS=$(shuf -i -100-100 -n 1 --random-source=<(echo $SEED))
    BASEPOP="$N($BIAS)"
    SAMPLEID="sample_${SLURM_ARRAY_TASK_ID}_$i$j"

    # Run tool with unique seed and output file
    $TOOL --N $N --gen $GEN --genome $GENOME --cluster $CLUSTER --rr $RR --rep $REP --basepop "$BASEPOP" --steps $STEPS --sampleid $SAMPLEID > "$FOLDER/output_${SAMPLEID}.txt"
done

# Combine all output files into a single file
cat $FOLDER/output_sample_${SLURM_ARRAY_TASK_ID}_*.txt > $FOLDER/combined_results_${SLURM_ARRAY_TASK_ID}_$i.out
