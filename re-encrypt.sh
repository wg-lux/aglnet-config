#!/bin/bash

####################################
#### Run as user, not as sudo! #####
####################################

# Create a timestamp for the backup version
TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)

# Make a backup of the current secrets directory and .sops.yaml file
mkdir -p secrets-versions/${TIMESTAMP}-secrets
cp -r secrets secrets-versions/${TIMESTAMP}-secrets
cp .sops.yaml secrets-versions/${TIMESTAMP}-secrets

# Function to check if the file is already encrypted with SOPS
is_encrypted() {
    grep -q 'sops:' $1
}

IGNORE_PREFIX="_INFO_"

# Function to get filename and check if it begins with the ignore prefix


# Function to encrypt or re-encrypt the file
encrypt_file() {
    local file=$1
    local temp_file="$(dirname "$file")/tmp_$(basename "$file")"
    

    # Check if the filename contains "_INFO_"
    if [[ "$file" != *"$IGNORE_PREFIX"* ]]; then
        # Decrypt the file and store in a temporary file
        sops --config ~/aglnet-config/.sops.yaml -d "$file" > "$temp_file"
    else
        # Copy unencrypted content to a temporary file
        cp "$file" "$temp_file"
    fi

    # Encrypt the content of the temporary file and overwrite the original file
    sops --config ~/aglnet-config/.sops.yaml -e "$temp_file" > "$file"
    
    # Remove the temporary file
    rm "$temp_file"
}

# Find all secret files in the secrets directory with specific extensions
find secrets -type f \( -name "*.yaml" -o -name "*.json" -o -name "*.env" -o -name "*.ini" -o -name "*.bin" -o -name "*.crt" -o -name "*.key" -o -name "*.txt" -o -name "*.pem" \) | while read file; do
    echo "Processing $file"
    encrypt_file "$file"
done

echo "All files have been processed."
