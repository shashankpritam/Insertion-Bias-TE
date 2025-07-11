#!/bin/bash
# Simple task-spooler batch for positive‐cluster / negative‐all scenario
#   deleterious effect outside clusters  x = 0
#   positive benefit inside clusters     b-cluins = 0.01
# Uses task-spooler (ts) with a maximum of 64 concurrent jobs.

# Parameters
N=1000
B=100
gen=500
genome="mb:10,10,10,10,10"
cluster="kb:300,300,300,300,300"
rr="4,4,4,4,4"
rep=100
u=0.1
x=0
bcluins=0.01
steps=1
folder="sim_x0_b0.01"
tool="./main"

# prepare output dir
mkdir -p "$folder"

# ensure task-spooler slot limit (ignore error if already set)
ts -S 64 2>/dev/null || true

segment_file="ij_pairs_50.txt"

while read -r i j; do
    basepop="$B($i),$B($j)"
    sampleid="x0b001_${i}_${j}"

    ts -L "$sampleid" bash -c "$tool --N $N --gen $gen --genome \"$genome\" --cluster \"$cluster\" --rr \"$rr\" --rep $rep --u $u --x $x --b-cluins $bcluins --basepop \"$basepop\" --steps $steps --sampleid \"$sampleid\" > \"$folder/output_${sampleid}.txt\""
done < "$segment_file"

echo "Jobs submitted. Monitor with: ts -l"
