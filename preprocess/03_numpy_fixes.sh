#!/bin/bash

# Directories to process
DIRECTORIES=("mmpose" "ROMP" "BoostingMonocularDepth")

# Loop through each directory
for DIRECTORY in "${DIRECTORIES[@]}"; do
    # Find all files in the directory and its subdirectories
    find "$DIRECTORY" -type f -exec grep -Il '.' {} \; | while read -r FILE; do
        # Check if the file contains the deprecated np.int, np.float, or np.bool
        if grep -q -E '\bnp\.int\b|\bnp\.float\b|\bnp\.bool\b' "$FILE"; then
            # Use sed to replace np.int with np.int32, np.float with np.float32, and np.bool with bool
            sed -i 's/\bnp\.int\b(?!32|64)/np.int32/g' "$FILE"
            sed -i 's/\bnp\.float\b(?!16|32|64)/np.float32/g' "$FILE"
            sed -i 's/\bnp\.bool\b/bool/g' "$FILE"
            echo "Updated $FILE"
        fi
    done
done

echo "Replacement of np.int with np.int32, np.float with np.float32, and np.bool with bool completed in all specified directories."