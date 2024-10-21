{config, pkgs, lib, network-config, ...}:
let 
    hostname = config.networking.hostName;
    endoreg-sensitive = network-config.hardware.${hostname}.endoreg-sensitive;
    
in {
    imports = [
        ( import ../../scripts/endoreg-client/main.nix {
            inherit config pkgs lib network-config ;
        })
    ];
}