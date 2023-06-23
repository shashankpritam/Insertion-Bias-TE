#!/bin/bash

counter=1

# Ask for the file name
read -p "Please enter the name of the file: " filename

# Read the file line by line
while IFS=';' read -ra lines; do
  for line in "${lines[@]}"; do
    # Split the line into number sections using comma as the delimiter
    IFS=',' read -ra numberSections <<< "$line"
  
    # Loop through the number sections
    for numberSection in "${numberSections[@]}"; do
      # Remove any leading or trailing whitespace and anything inside ()
      number=$(echo -e "${numberSection}" | sed -e 's/([^)]*)//g' -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
    
      # Check if the number is less than 30000
      if [[ $number =~ ^-?[0-9]+$ ]] && ((number < 30000)); then
        echo "$counter. $number"
        ((counter++))
      fi
    done
  done
done < "$filename"
