#!/bin/bash

#SBATCH --job-name=year_simulation
#SBATCH --output=year_simulation.log
#SBATCH --ntasks=4
#SBATCH --cpus-per-task=8
#SBATCH --time=30-00:00:00
#SBATCH --mem=128G

# Initialize DATE variable before the loop
DATE=$(date +"%dth%b%Yat%I%M%S%p")
MONTHS=("January" "February" "March" "April" "May" "June" "July" "August" "September" "October" "November" "December")
POPULATIONS=("500" "1000" "2000" "5000" "7000" "8000" "10000" "9000" "7000" "4000" "2000" "1000")

# Iterate through the months and run the script with corresponding population sizes
for i in "${!MONTHS[@]}"
do
   MONTH="${MONTHS[$i]}"
   # Output directory for each month
   OUTPUT_DIR="${DATE}/${MONTH}"
   # Create the directory if it doesn't exist
   mkdir -p $OUTPUT_DIR

   # Run the script with the corresponding population size and output directory
   python3 sim_storm.py --steps 1 --N "${POPULATIONS[$i]}" --output $OUTPUT_DIR
done