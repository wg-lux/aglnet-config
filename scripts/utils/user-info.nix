{ config, pkgs, network-config, ... }:

let
    script-name = network-config.scripts.user-info.name;


    scriptPath = pkgs.writeShellScriptBin "${script-name}" ''#!/usr/bin/env bash
        # List all users and their UIDs
        echo "Users and their UIDs:"
        cat /etc/passwd | awk -F: '{print "User: " $1 ", UID: " $3}'
        echo ""

        # List all groups and their GIDs
        echo "Groups and their GIDs:"
        cat /etc/group | awk -F: '{print "Group: " $1 ", GID: " $3}'
        echo ""

        # List each user and their group memberships
        echo "Users and their group memberships:"
        for user in $(cut -d: -f1 /etc/passwd); do
            echo "User: $user"
            id $user
            echo
        done
  '';

in
{

    environment.systemPackages = with pkgs; [
        scriptPath
    ];

}