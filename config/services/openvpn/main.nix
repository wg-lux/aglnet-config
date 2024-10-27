{ lib, ... }:
let 
    base = import ./base.nix { };
    configurations = import ./configurations.nix { };
    ccd = import ./ccd.nix { };

    openvpn = {
        configurations = configurations;
    } // base;


in openvpn