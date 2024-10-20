{ config, pkgs, network-config, ... }:

let
    conf = network-config.services.utils.filesystem-readout;
    
    # hardware-readout-filesystems-path = "/etc/hardware-readout-filesystems.json";
    hardware-readout-filesystems-path = conf.path;
    service-user = conf.service-user;
    service-group = conf.service-group;
    maintenance-group = conf.maintenance-group;
    service-name = conf.service-name;
    script-name = conf.script-name;


    scriptPath = pkgs.writeShellScriptBin "${script-name}" ''#!/usr/bin/env bash

        # Define output file path
        output_file="${hardware-readout-filesystems-path}"

        # Function to add JSON formatting
        json_add_entry() {
            local key=$1
            local value=$2
            # Escape any special characters and make sure line breaks are removed
            echo "\"$key\": \"$(echo $value | tr -d '\n')\"" >> "$output_file"
        }

        # Start the JSON structure
        echo "{" > "$output_file"

        # Get all block devices and their UUIDs
        echo "Collecting UUIDs of all filesystems and partitions..."
        while read -r line; do
            device=$(echo $line | cut -d: -f1)
            uuid=$(echo $line | grep -oP 'UUID="\K[^"]+')
            fstype=$(echo $line | grep -oP 'TYPE="\K[^"]+')
            partuuid=$(echo $line | grep -oP 'PARTUUID="\K[^"]+' || echo "")

            # Ensure no line breaks or extra spaces in UUIDs and PARTUUIDs
            uuid=$(echo $uuid | tr -d '\n' | tr -d '\r')
            partuuid=$(echo $partuuid | tr -d '\n' | tr -d '\r')

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

        # End the JSON structure
        echo "}" >> "$output_file"

        # Ensure correct permissions are set for the output file
        sudo chmod 644 "$output_file"

        echo "Hardware readout written to $output_file"

  '';

in
{
    systemd.services."${service-name}" = {
        description = "Read filesystem information and write to ${hardware-readout-filesystems-path}";
        serviceConfig = {
            Type = "oneshot";
            ExecStart = "${scriptPath}/bin/${script-name}";
            User=service-user;
            Group=service-group;
        };
        path = [ pkgs.sudo pkgs.utillinux pkgs.coreutils ];
    };

    environment.systemPackages = with pkgs; [
        scriptPath
    ];


  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (action.id == "org.freedesktop.systemd1.manage-units" &&
          subject.isInGroup("${maintenance-group}") &&
          action.lookup("unit") == "${service-name}.service" &&
          (action.lookup("verb") == "start" || action.lookup("verb") == "stop")) {
        return polkit.Result.YES;
      }
    });
  '';
}