#!/bin/bash
#SBATCH --job-name=A
#SBATCH --output=A_%A_%a.log
#SBATCH --time=10-00:00:00
#SBATCH --array=1-5
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=12
#SBATCH --mem-per-cpu=4G

# This script is used to run a simulation tool in parallel using SLURM job array.
# It reads pairs of values from a segment file and executes the simulation for each pair.
# The simulation parameters are set at the beginning of the script.


# Path to the simulation tool
tool="./main"

# Simulation parameters
N=1000
B=100
gen=500
genome="mb:10,10,10,10,10"
cluster="kb:300,300,300,300,300"
rr="4,4,4,4,4"
rep=100
u=0.1
x=0
steps=1
folder="new_sim/A"
segment_file="ij_pairs_50_part_$(printf "%d" $SLURM_ARRAY_TASK_ID).txt"

# Ensure the segment file exists
if [ ! -f "$segment_file" ]; then
    echo "Segment file $segment_file does not exist."
    exit 1
fi

# Ensure the output folder exists
mkdir -p "$folder"

# Counter to control the number of parallel processes
max_parallel=40
count=0

# Read each i, j pair from the segment file and execute the simulation
while read -r i j; do
    basepop="$B($i),$B($j)"
    sampleid="sample_${SLURM_ARRAY_TASK_ID}_${i}_${j}"
    (
        $tool --N $N --gen $gen --genome $genome --cluster $cluster --rr $rr --rep $rep --u $u --x $x --basepop "$basepop" --steps $steps --sampleid "$sampleid" > "$folder/output_${sampleid}.txt"
    ) &
    ((count++))
    if [[ $count -ge $max_parallel ]]; then
        wait
        count=0
    fi
done < "$segment_file"
wait
