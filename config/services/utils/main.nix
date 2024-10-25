{ lib, ... }:
let 
    utils = {
        filesystem-readout = import ./filesystem-readout.nix { inherit lib; };
        base-directories = import ./base-directories.nix { inherit lib; };
        zsh = import ./zsh.nix { inherit lib; };
        ssh = import ./ssh.nix { inherit lib; };
    };

in utils