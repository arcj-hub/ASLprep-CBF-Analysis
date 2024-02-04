

# Author: Jessica Archibald, 2022-July
# This script is to run through each brain location from where you want to extract CBF.
# Run this script in each subject folder after you have run ASLprep.
#It has 3 main steps:
# Co-registration, Bin, and calculating CBF.
# Remember to replace path/to/sub-0**_space-T1w_cbf.nii* with the actual path to the subject's CBF image in T1w space
#and path/to/data with the actual path to your data directory when you use the script.

#!/bin/bash



echo "Co-registering the Mask"

# Co-registration step
# Loop through all files in the directory
for FILE in *;
do
    # If the file name matches the masks you want to co-register
    if [ "$FILE" == 'mask_ACC.nii.gz' ] || [ "$FILE" == 'mask_HCC.nii.gz' ] || [ "$FILE" == 'mask_MCC.nii.gz' ] || [ "$FILE" == 'mask_PCC.nii.gz' ];
    then
        # Use FLIRT to co-register the mask to the subject's CBF image in T1w space
        # Replace "path/to/sub-001_space-T1w_cbf.nii*" with the actual path to the subject's CBF image in T1w space
        flirt -in "$FILE" -ref sub-0**_space-T1w_cbf.nii* -out resample_"$FILE" -applyxfm -usesqform
    else
        :
    fi
done

# Print the names of the files created
ls resample_mask_*

# Create a new directory called "BIN" and move the co-registered masks into it
mkdir BIN
mv resample_mask_* BIN

echo "Binarizing the Mask"

# Binarization step
# Change directory to the "BIN" directory
cd BIN/

# Loop through all the masks in the directory
for REG_Mask in *;
do
	# Print the name of the mask being binarized
	echo $REG_Mask

	# Use FSLmaths to binarize the mask
	fslmaths $REG_Mask -thr 0.5 -bin BIN_$REG_Mask
done

# Change directory back to the original directory
cd ..

echo "Calculating CBF per Location"

# Calculate CBF per location and append to the "cbf.txt" file
# Replace "path/to/sub-0**_space-T1w_cbf.nii*" with the actual path to the subject's CBF image in T1w space
fslstats sub-0**_space-T1w_cbf.nii* -k ./BIN/BIN_resample_mask_ACC.nii.gz -M >> cbf.txt
fslstats sub-0**_space-T1w_cbf.nii* -k ./BIN/BIN_resample_mask_HCC.nii.gz -M >> cbf.txt
fslstats sub-0**_space-T1w_cbf.nii* -k ./BIN/BIN_resample_mask_MCC.nii.gz -M >> cbf.txt
fslstats sub-0**_space-T1w_cbf.nii* -k ./BIN/BIN_resample_mask_PCC.nii.gz -M >> cbf.txt
