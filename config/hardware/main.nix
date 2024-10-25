{ lib, ... }:
let 
    hostnames = import ../hostnames.nix {};

    hardware = lib.genAttrs (lib.attrValues hostnames) (hostname: {
        endoreg-sensitive = import ./${hostname}-endoreg-sensitive.nix { };
        system = import ./${hostname}.nix;
        usb-key = import ./${hostname}-usb-key.nix;
    });

in hardware


