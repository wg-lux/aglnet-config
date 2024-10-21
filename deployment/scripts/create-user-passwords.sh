#!/bin/bash

# Prompt for hostname
read -p "Enter hostname: " hostname

# Declare an array for the users
declare -A users=(
    ["setup-user"]="dev-setup"
    ["agl-admin"]="admin"
    ["service-user"]="service"
    ["center-user"]="center"
    ["logging-user"]="logging"
    ["maintenance-user"]="maintenance"
)

# Initialize the output file
output_file="nix-users.yaml"
echo "nixos:" > $output_file
echo "    user:" >> $output_file

# Function to hash password using mkpasswd
hash_password() {
    local raw_password=$1
    mkpasswd --method=sha-512 $raw_password
}

# Loop over each user and prompt for their password (add -s to read for visible input)
for user in "${!users[@]}"; do
    read -p "Enter password for $user: " password
    # Hash the password
    hashed_password=$(hash_password "$password")
    
    # Write the user data to the YAML file
    echo "        $user:" >> $output_file
    echo "            pwd-raw: $password" >> $output_file
    echo "            pwd-hashed: $hashed_password" >> $output_file
done

# Confirmation message
echo "YAML file '$output_file' created successfully."
