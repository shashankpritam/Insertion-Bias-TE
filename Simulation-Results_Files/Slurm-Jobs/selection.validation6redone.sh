#!/bin/bash
#SBATCH --cpus-per-task=4
#SBATCH --ntasks=1
#SBATCH --time=8-00:00:00
#SBATCH --mem=128000mb
#SBATCH --job-name=validation6redone
#SBATCH --error=job.%A.err
#SBATCH --output=job.%A.out

tool="./main"
folder="Simulation-Results/Insertion-Bias/validation_6_redone"
genome="mb:1"
rep=100

# All commands updated
$tool --N 1000 --gen 100 --genome $genome --cluster kb:100 --rr 4 --rep $rep --u 0.1 --basepop "100(0)" --steps 25 -x 0.1 --file-mhp $folder/validation_6_redone_1_mhp > $folder/validation_6_redone_1 &

$tool --N 1000 --gen 100 --genome $genome --cluster kb:100 --rr 4 --rep $rep --u 0.1 --basepop "100(0)" --steps 25 -x 0.1 -no-x-cluins --file-mhp $folder/validation_6_redone_2_mhp > $folder/validation_6_redone_2 &

$tool --N 10000 --u 0 --basepop file:input_sel --gen 1000 --genome $genome --steps 10 --rr 0 --rep $rep --sampleid psel3 > $folder/validation_6_redone_3 &

$tool --N 10000 --u 0 -x 0.1 --basepop file:input_sel --gen 1000 --genome $genome --steps 10 --rr 0 --rep $rep --sampleid psel4 > $folder/validation_6_redone_4 &

$tool --N 10000 --u 0 -x 0.01 --basepop file:input_sel --gen 1000 --genome $genome --steps 10 --rr 0 --rep $rep --sampleid psel5 > $folder/validation_6_redone_5 &

$tool --N 10000 --u 0 -x 0.001 --basepop file:input_sel --gen 1000 --genome $genome --steps 10 --rr 0 --rep $rep --sampleid psel6 > $folder/validation_6_redone_6 &

$tool --N 10000 --u 0 -x 0.0001 --basepop file:input_sel --gen 1000 --genome $genome --steps 10 --rr 0 --rep $rep --sampleid psel7 > $folder/validation_6_redone_7 &

# Wait for all simulations to finish
wait

# Concatenate output files
cat "$folder/validation_6_redone_3" "$folder/validation_6_redone_4" "$folder/validation_6_redone_5" "$folder/validation_6_redone_6" "$folder/validation_6_redone_7" | grep -v "^Invade" | grep -v "^#" > "$folder/2023_05_23_Validation_6_Redone_Selection"
