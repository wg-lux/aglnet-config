{ lib, ... }:
let 
    utils = {
        filesystem-readout = import ./filesystem-readout.nix { inherit lib; };
        base-directories = import ./base-directories.nix { inherit lib; };
    };

in utils