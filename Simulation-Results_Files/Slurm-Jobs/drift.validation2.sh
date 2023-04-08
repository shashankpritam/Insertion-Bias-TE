#!/bin/bash

#SBATCH --cpus-per-task=4
#SBATCH --ntasks=1
#SBATCH --time=1-00:00:00
#SBATCH --mem=32000mb
#SBATCH --job-name=validation2
#SBATCH --error=job.%A.%a.err
#SBATCH --output=job.%A.%a.out


tool="./main"
folder="Simulation-Results/Insertion-Bias/validation_2"

$tool --N 250 --gen 20000 --genome mb:10,10,10,10,10 --cluster mb:1,1,1,1,1 --rr 4,4,4,4,4 --rep 500 --u 0.0 --basepop "10000(0)" --steps 20000 --sampleid pd250> $folder/validation_2_1 &
$tool --N 500 --gen 20000 --genome mb:10,10,10,10,10 --cluster mb:1,1,1,1,1 --rr 4,4,4,4,4 --rep 500 --u 0.0 --basepop "10000(0)" --steps 20000 --sampleid pd500> $folder/validation_2_2 &
$tool --N 1000 --gen 20000 --genome mb:10,10,10,10,10 --cluster mb:1,1,1,1,1 --rr 4,4,4,4,4 --rep 500 --u 0.0 --basepop "10000(0)" --steps 20000 --sampleid pd1000> $folder/validation_2_3

cat validation_2_1 validation_2_2 validation_2_3|awk '$2==20000' > 2023_03_03_Validation_2_Drift

wait

cat "$folder/validation_2_1" "$folder/validation_2_2" "$folder/validation_2_3" | awk '$2==20000' > "$folder/$(date +%Y_%m_%d)_Validation_2_Drift"
