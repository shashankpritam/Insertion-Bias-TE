#!/bin/bash

#SBATCH --cpus-per-task=4
#SBATCH --ntasks=1
#SBATCH --time=1-00:00:00
#SBATCH --mem=32000mb
#SBATCH --job-name=validation4
#SBATCH --error=job.%A.%a.err
#SBATCH --output=job.%A.%a.out


tool="./main"
folder="Simulation-Results/Insertion-Bias/validation_4"

$tool --N 10000 --u 0 --basepop "100(0)" --file-debug $folder/validation_4_1_debug --gen 150 --genome mb:1 --steps 1 --rr 0 --rep 100 > $folder/validation_4_1
$tool --N 10000 --u 0 --basepop "100(0)" --file-debug $folder/validation_4_2_debug --gen 150 --genome mb:1 --steps 1 --rr 1 --rep 100 > $folder/validation_4_2
$tool --N 10000 --u 0 --basepop "100(0)" --file-debug $folder/validation_4_3_debug --gen 150 --genome mb:1 --steps 1 --rr 5 --rep 100 > $folder/validation_4_3
$tool --N 10000 --u 0 --basepop "100(0)" --file-debug $folder/validation_4_4_debug --gen 150 --genome mb:1 --steps 1 --rr 10 --rep 100 > $folder/validation_4_4
