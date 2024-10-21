{ lib, ... }:
let
    scripts = {
        user-info = import ./user-info.nix { };
        endoreg-sensitive-mounting = import ./endoreg-sensitive-mounting.nix { inherit lib; };
    };

in scripts