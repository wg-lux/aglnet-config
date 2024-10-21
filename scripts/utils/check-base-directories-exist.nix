{ config, lib, pkgs, network-config, ... }:

let
    conf = network-config.services.utils.check-base-directories-exist;

    service-user = conf.user;
    service-group = conf.group;
    script-name = conf.script-name;
    service-name = conf.service-name;
    service-type = conf.service-type;
    service-wantedBy = conf.wantedBy;
    service-before = conf.before;

    dirlist = conf.dirlist; # ["dir1", "dir2", ...]
    owners = conf.owners; # ["owner1", "owner2", ...]
    groups = conf.groups; # ["group1", "group2", ...]
    permissions = conf.permissions; # ["perm1", "perm2", ...]

    # Create the script that checks the directories, creates them if they don't exist, and sets the correct permissions
    scriptPath = pkgs.writeShellScriptBin "${script-name}" ''#!/usr/bin/env bash
            
            # Check if the directories exist, create them if they don't, and set the correct permissions
            for i in ${!dirlist[@]}; do
                dir="${dirlist[$i]}"
                owner="${owners[$i]}"
                group="${groups[$i]}"
                perm="${permissions[$i]}"
    
                if [ ! -d "$dir" ]; then
                    echo "Creating directory $dir"
                    mkdir -p "$dir"
                fi
    
                # Set the owner and group
                chown -R "$owner:$group" "$dir"
    
                # Set the permissions
                chmod -R "$perm" "$dir"
            done
    '';
in
{
   # Define the new service that sets up the log directory
    systemd.services."${service-name}" = {
        description = "Ensure the custom log directory is available and has correct ownership and permissions";
        serviceConfig = {
            ExecStart = "${scriptPath}/bin/${script-name}";
            User = service-user;  
            Group = service-group;
            Type = service-type;  # Runs once at boot
        };
        wantedBy = service-wantedBy  # Ensure this runs during boot
        before = service-before;  # Ensure it runs before the logger service
    };

    # Ensure the scripts are available in system packages
    environment.systemPackages = with pkgs; [
        scriptPath
    ];
}
