#!/bin/bash
#Jessica Archibald 2022
# This script is extract the quality measures of the html output files of ASLprep
# The first value is QEI-Quality Evaluation Index refer to: https://cds.ismrm.org/protected/17MProceedings/PDFfiles/0682.html
# and the second is the negative GM CBF voxel

# Make a empty txt file
touch quality.txt

# Initialize arrays to store quality metric values
qei=()
neg_vox=()

# Loop through all HTML files
for file in sub-*.html; do
    # Extract quality metric values
    values=$(grep -o 'cbf: [0-9.]*' "$file" | awk '{print $2}' | tr '\n' ' ')
    # Split quality metric values into two variables
    qei_val=$(echo "$values" | cut -d' ' -f1)
    neg_vox_val=$(echo "$values" | cut -d' ' -f2)
    # Add values to arrays
    qei+=("$qei_val")
    neg_vox+=("$neg_vox_val")
    # Append filename and quality metric values to output file
    echo "$file $values" >> quality.txt
done

# Calculate mean and standard deviation of quality metric values for each column
qei_mean=$(echo "${qei[@]}" | tr ' ' '\n' | awk '{sum+=$1} END {print sum/NR}')
qei_std=$(echo "${qei[@]}" | tr ' ' '\n' | awk -v mean="$qei_mean" '{sum+=($1-mean)**2} END {print sqrt(sum/NR)}')
neg_vox_mean=$(echo "${neg_vox[@]}" | tr ' ' '\n' | awk '{sum+=$1} END {print sum/NR}')
neg_vox_std=$(echo "${neg_vox[@]}" | tr ' ' '\n' | awk -v mean="$neg_vox_mean" '{sum+=($1-mean)**2} END {print sqrt(sum/NR)}')

# Append mean and standard deviation to last row of output file
echo "Mean +/- Stdev: $qei_mean +/- $qei_std $neg_vox_mean +/- $neg_vox_std" >> quality.txt
