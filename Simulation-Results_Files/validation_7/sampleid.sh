#!/bin/bash

folder="."

# Print table header
echo "| Bias  | SampleID | Seed              |"
echo "|-------|----------|-------------------|"

# Loop over values from -100 to 100 in steps of 10
for j in $(seq -100 10 100)
do
    # Set basepop directly to "1000;j"
    basepop="1000($j)"

    # Assign current counter value to sampleid with descriptive prefix
    if [ $j -ge 0 ]
    then
        sampleid="b${j}"
    else
        sampleid="mb${j#-}"  # Use parameter expansion to remove the negative sign
    fi

    # Extract seed from the corresponding result file
    seed=$(grep '# version' "$folder/result_${sampleid}.out" | awk -F', seed: ' '{print $2}')

    # Print table row with updated seed value
    echo "| $j  | $sampleid | $seed |"
done
