# This Nix file defines a script that prompts the user for confirmation 
# before running potentially risky commands that involve garbage collection
# and removing auto gcroots. Be cautious as these commands could result in 
# the loss of valuable references in the Nix store.

{ pkgs, ... }:

let
  script = pkgs.writeShellScriptBin "deep-clean" ''
    #!/usr/bin/env bash

    # Brief explanation of risks
    echo "WARNING: This script will perform the following actions:"
    echo "1. Update all nix packages using nix-env -u --always."
    echo "2. Remove all automatic garbage collection roots (/nix/var/nix/gcroots/auto/*)."
    echo "3. Run nix-collect-garbage -d to delete any unreferenced Nix store paths."
    echo "\nThese operations are potentially risky as they may lead to the loss of system packages or cached dependencies."
    echo "\nDo you really want to proceed? (yes/no)"

    # Read user input
    read -r confirmation

    if [ "$confirmation" != "yes" ]; then
      echo "Operation cancelled by the user."
      exit 0
    fi

    # Proceed with the commands
    echo "Proceeding with Nix environment update..."
    nix-env -u --always

    echo "Removing automatic GC roots..."
    sudo rm -rf /nix/var/nix/gcroots/auto/*

    echo "Running garbage collection..."
    nix-collect-garbage -d

    echo "Cleanup completed."
  '';
in
{
  environment.systemPackages = [ script ];
}
