#!/bin/bash
#SBATCH --cpus-per-task=4
#SBATCH --ntasks=1
#SBATCH --time=10-00:00:00
#SBATCH --mem=128000mb
#SBATCH --job-name=validation7.1
#SBATCH --error=job.%A.err
#SBATCH --output=job.%A.out

# Base name for the output files
outfile_base="input_bias"

tool="./main"
genome="mb:1"
cluster="kb:30"
rep=100
gen=1
steps=1
folder="Simulation-Results/Insertion-Bias/validation_7.1"
rr=0

# Make sure the output folder exists
mkdir -p $folder

# Initialize a counter
counter=1

# Function to generate a random number between 0 and 1 million
generate_random_number() {
    echo $(( $(od -An -N3 -i /dev/urandom) % 1000001 ))
}

# Generate 1000 random numbers and store them in an array
declare -a random_numbers
for i in {1..1000}
do
    random_numbers[i]=$(generate_random_number)
done

# Loop over values from -100 to 100 in steps of 10
for j in $(seq -100 10 100)
do
    # Formulate the outfile name for this iteration
    outfile="$folder/${outfile_base}${counter}"  # Added $folder to the path

    # Remove the outfile if it already exists
    if [ -e "$outfile" ]
    then
        rm "$outfile"
    fi

    # Start the line with "10000;" and the first random number
    line="10000; ${random_numbers[1]}(${j})"

    # Add 999 more random numbers and the bias value to the line
    for i in {2..1000}
    do
        line="$line, ${random_numbers[i]}(${j})"
    done

    # Finish the line with "; 0(0)" and write it to the file
    echo "$line; 0(0)" >> $outfile

    # Specify basepop with the current outfile
    basepop="file:$outfile"  # Now correctly pointing to the outfile in $folder


    # Assign current counter value to sampleid with descriptive prefix
    if [ $j -ge 0 ]
    then
        sampleid="b${j}"
    else
        sampleid="mb${j#-}"  # Use parameter expansion to remove the negative sign
    fi

    # Run the command
    $tool --N 10000 --gen $gen --genome $genome --cluster $cluster --rr $rr --rep $rep --u 0.1 --basepop $basepop --steps $steps --sampleid $sampleid >> "$folder/result_${counter}.out"

    # Increment the counter
    counter=$((counter+1))
done
