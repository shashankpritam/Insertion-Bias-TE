#!/bin/bash

#SBATCH --cpus-per-task=4
#SBATCH --ntasks=1
#SBATCH --time=1-00:00:00
#SBATCH --mem=32000mb
#SBATCH --job-name=validation3
#SBATCH --error=job.%A.%a.err
#SBATCH --output=job.%A.%a.out


tool="./main"
folder="Simulation-Results/Insertion-Bias/validation_3"

$tool --N 1000 --gen 100 --genome mb:1 --cluster kb:0 --rr 4 --rep 100 --u 0.1 --basepop "10(0)" --steps 1 --sampleid pc0> $folder/validation_3_1 &
$tool --N 1000 --gen 100 --genome mb:1 --cluster kb:500 --rr 4 --rep 100 --u 0.1 --basepop "10(0)" --steps 1 --sampleid pc50> $folder/validation_3_2 & 
$tool --N 1000 --gen 100 --genome mb:1 --cluster kb:1000 --rr 4 --rep 100 --u 0.1 --basepop "10(0)" --steps 1 --sampleid pc100> $folder/validation_3_3

wait

cat "$folder/validation_3_1" "$folder/validation_3_2" "$folder/validation_3_3" | grep -v "^Invade" | grep -v "^#" > "$folder/$(date +%Y_%m_%d)_Validation_3_piRNA_clusters"
