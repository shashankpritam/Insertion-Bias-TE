#!/bin/bash
#SBATCH --job-name=reStorm2
#SBATCH --output=reStorm2_%A_%a.log
#SBATCH --time=10-00:00:00
#SBATCH --array=1-6
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=10
#SBATCH --mem-per-cpu=4G

# Path to the simulation tool
tool="./main"

# Simulation parameters
N=1000
B=100
gen=5000
genome="mb:10"
cluster="kb:300"
rr="0"
rep=1
u=0.1
steps=1
folder="reStorm2"
segment_file="ij_combinations_$(printf "%03d" $SLURM_ARRAY_TASK_ID).txt"

# Ensure the segment file exists
if [ ! -f "$segment_file" ]; then
    echo "Segment file $segment_file does not exist."
    exit 1
fi

# Ensure the output folder exists
mkdir -p "$folder"

# Counter to control the number of parallel processes
max_parallel=10
count=0

# Read each i, j pair from the segment file and execute the simulation
while read -r i j; do
    basepop="$B($i),$B($j)"
    sampleid="sample_${SLURM_ARRAY_TASK_ID}_${i}_${j}"
    (
        $tool --N $N --gen $gen --genome $genome --cluster $cluster --rr $rr --rep $rep --u $u --basepop "$basepop" --steps $steps --sampleid "$sampleid" > "$folder/output_${sampleid}.txt"
    ) &
    ((count++))
    if [[ $count -ge $max_parallel ]]; then
        wait
        count=0
    fi
done < "$segment_file"
wait
