#!/bin/bash

# Function to select HDD
select_disk() {
    echo "Available Disks:"
    lsblk -d -n -o NAME,SIZE
    read -p "Enter the disk to clean and partition (e.g., /dev/sdX): " DISK
}

# Function to get partition sizes
get_partition_sizes() {
    read -p "Enter partition sizes in format (dropoff processing processed), or press Enter for default [0.2 0.59 0.2]: " SIZE_INPUT
    if [ -z "$SIZE_INPUT" ]; then
        SIZES=(0.2 0.59 0.2)
    else
        SIZES=($SIZE_INPUT)
    fi
}

# Function to securely wipe the drive
wipe_drive() {
    echo "Wiping all data from $DISK..."
    
    # Wipe the filesystem signatures
    wipefs --all --force "$DISK"
    
    echo "All data on $DISK has been wiped."
}

# Function to convert sizes to sectors
convert_to_sectors() {
    DISK_SIZE_SECTORS=$(lsblk -b -n -o SIZE "$DISK" | awk '{print $1 / 512}')
    for i in 0 1 2; do
        PART_SIZES_SECTORS[$i]=$(echo "${SIZES[$i]} * $DISK_SIZE_SECTORS" | bc | awk '{printf "%.0f", $0}')
    done
}

# Function to create partitions
create_partitions() {
    echo "Cleaning and partitioning $DISK"
    sgdisk --zap-all "$DISK"
    sgdisk -n 1:0:+${PART_SIZES_SECTORS[0]} -t 1:8300 -c 1:"dropoff" "$DISK"
    sgdisk -n 2:0:+${PART_SIZES_SECTORS[1]} -t 2:8300 -c 2:"processing" "$DISK"
    sgdisk -n 3:0:+${PART_SIZES_SECTORS[2]} -t 3:8300 -c 3:"processed" "$DISK"
    partprobe "$DISK" # Reload partition table
}

# Function to wipe partition headers with dd
wipe_partitions() {
    for i in 1 2 3; do
        PART="${DISK}${i}"
        echo "Wiping the first 1MB of ${PART}..."
        dd if=/dev/zero of="$PART" bs=1M count=1 status=progress
    done
}

# Function to encrypt partitions
encrypt_partitions() {
    for i in 1 2 3; do
        PART="${DISK}${i}"
        read -sp "Enter passphrase for partition $i (${LABELS[$((i-1))]}): " PASSPHRASE
        echo
        echo "$PASSPHRASE" | cryptsetup luksFormat --force-password "$PART" -
        echo "$PASSPHRASE" | cryptsetup open "$PART" ${LABELS[$((i-1))]}_crypt
    done
}

# Function to format partitions
format_partitions() {
    for i in 1 2 3; do
        mkfs.ext4 "/dev/mapper/${LABELS[$((i-1))]}_crypt"
    done
}

# Main script starts here
LABELS=("dropoff" "processing" "processed")
select_disk
get_partition_sizes
wipe_drive
convert_to_sectors
create_partitions
wipe_partitions   # New step to wipe partition headers
encrypt_partitions
format_partitions

echo "Partitions have been created, encrypted, and formatted."
