{ ... }:
let 
    hardware = {
        "agl-gpu-client-02" = {
            endoreg-sensitive = import ./agl-gpu-client-02-endoreg-sensitive.nix { };
        };
    };
in hardware