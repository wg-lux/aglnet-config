#!/usr/bin/env bash

# Define output file paths
json_output_file="$(pwd)/hardware-readout.json"
nix_config_output_file="$(pwd)/nix-config.txt"

# Function to add JSON formatting
json_add_entry() {
    local key=$1
    local value=$2
    # Escape any special characters and make sure line breaks are removed
    echo "\"$key\": \"$(echo $value | tr -d '\n')\"" >> "$json_output_file"
}

# Prompt user for input
get_user_input() {
    local prompt_text=$1
    local default_value=$2
    local user_input

    read -p "$prompt_text [$default_value]: " user_input
    if [ -z "$user_input" ]; then
        echo "$default_value"
    else
        echo "$user_input"
    fi
}

# Start the JSON structure
echo "{" > "$json_output_file"

# Get all block devices and their UUIDs with additional info
echo "Collecting UUIDs of all filesystems and partitions..."
filesystem_info=()
while read -r line; do
    device=$(echo $line | cut -d: -f1)
    uuid=$(echo $line | grep -oP 'UUID="\K[^"]+')
    fstype=$(echo $line | grep -oP 'TYPE="\K[^"]+')
    partuuid=$(echo $line | grep -oP 'PARTUUID="\K[^"]+' || echo "")
    mount_point=$(findmnt -n -o TARGET --source $device 2>/dev/null || echo "Not mounted")

    # Ensure no line breaks or extra spaces in UUIDs and PARTUUIDs
    uuid=$(echo $uuid | tr -d '\n' | tr -d '\r')
    partuuid=$(echo $partuuid | tr -d '\n' | tr -d '\r')

    # Store useful information for user selection
    if [ ! -z "$uuid" ]; then
        filesystem_info+=("$device (UUID: $uuid, Mount: $mount_point, Type: $fstype)")
    fi

    # Add information to the JSON output
    if [ ! -z "$uuid" ]; then
        json_add_entry "$device (UUID)" "$uuid"
    fi
    if [ ! -z "$fstype" ]; then
        json_add_entry "$device (FSTYPE)" "$fstype"
    fi
    if [ ! -z "$partuuid" ]; then
        json_add_entry "$device (PARTUUID)" "$partuuid"
    fi
done < <(sudo blkid)

# Collect LUKS UUIDs
echo -e "\nCollecting UUIDs of LUKS encrypted devices..."
for dev in $(lsblk -lno NAME,FSTYPE | grep crypto_LUKS | awk '{print "/dev/" $1}'); do
    luks_uuid=$(sudo cryptsetup luksUUID $dev)
    json_add_entry "$dev (LUKS UUID)" "$luks_uuid"
done

# Collect GPU interfaces with both Bus ID and Name
echo -e "\nCollecting GPU interfaces..."
gpu_info=$(lspci | grep -i --color 'vga\|3d\|2d')
gpu_count=1
gpu_devices=()
while read -r line; do
    json_add_entry "GPU $gpu_count" "$line"
    # Extract bus ID and device name
    bus_id=$(echo $line | awk '{print $1}')
    device_name=$(echo $line | cut -d' ' -f2-)
    gpu_devices+=("$bus_id ($device_name)")
    gpu_count=$((gpu_count + 1))
done <<< "$gpu_info"

# Collect all network interfaces, including inactive ones
echo -e "\nCollecting network interfaces..."
network_info=$(ip -o link show)  # List all interfaces
interface_count=1
network_interfaces=()
while read -r line; do
    interface_name=$(echo $line | awk -F': ' '{print $2}')
    interface_status=$(echo $line | grep -oP '(?<=state )\w+')
    
    # Add network interface details to JSON
    json_add_entry "Network Interface $interface_count (Name)" "$interface_name"
    json_add_entry "Network Interface $interface_count (Status)" "$interface_status"

    network_interfaces+=("$interface_name")
    interface_count=$((interface_count + 1))
done <<< "$network_info"

# End the JSON structure
echo "}" >> "$json_output_file"

# Ensure correct permissions are set for the JSON output file
sudo chmod 644 "$json_output_file"

# Collect user inputs for the Nix configuration file
echo -e "\nNow configuring the Nix configuration file..."

# Display available network interfaces and let the user select
echo "Available network interfaces: ${network_interfaces[*]}"
primary_network_interface=$(get_user_input "Enter primary network interface" "${network_interfaces[0]}")
secondary_network_interface=$(get_user_input "Enter secondary network interface (optional)" "")

# Display available GPUs (Bus ID and Name) and let the user select
echo "Available GPU Bus IDs and Names: ${gpu_devices[*]}"
nvidia_bus_id=$(get_user_input "Enter NVIDIA GPU Bus ID (optional)" "")
onboard_graphic_bus_id=$(get_user_input "Enter onboard graphic Bus ID (optional)" "")

# Display available filesystems for UUID input
echo "Available filesystems: ${filesystem_info[*]}"
file_system_base_uuid=$(get_user_input "Enter UUID for the base filesystem" "")
file_system_boot_uuid=$(get_user_input "Enter UUID for the boot filesystem" "")
swap_device_uuid=$(get_user_input "Enter UUID for the swap device" "")

# Prompt for LUKS device UUIDs
luks_hdd_intern_uuid=$(get_user_input "Enter UUID for internal LUKS-encrypted HDD" "")
luks_swap_uuid=$(get_user_input "Enter UUID for LUKS-encrypted swap device" "")

# Prompt for system state
system_state=$(get_user_input "Enter system state" "23.11")

# Create the Nix configuration file
echo "Creating Nix configuration file..."
cat <<EOL > "$nix_config_output_file"
{
    network-interface = "$primary_network_interface"; # select by user

    secondary-network-interface = "$secondary_network_interface"; # select by user
    
    nvidiaBusId = "$nvidia_bus_id"; # select by user
    onboardGraphicBusId = "$onboard_graphic_bus_id"; # select by user

    file-system-base-uuid = "$file_system_base_uuid"; 
    file-system-boot-uuid = "$file_system_boot_uuid"; 
    swap-device-uuid = "$swap_device_uuid";

    luks-hdd-intern-uuid = "$luks_hdd_intern_uuid";
    luks-swap-uuid = "$luks_swap_uuid";

    system-state = "$system_state"; # enter by user
}
EOL

# Ensure correct permissions are set for the Nix configuration file
sudo chmod 644 "$nix_config_output_file"

echo "Nix configuration written to $nix_config_output_file"

