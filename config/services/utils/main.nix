{ lib, ... }:
let 
    utils = {
        filesystem-readout = import ./filesystem-readout.nix { inherit lib; };
    };

in utils