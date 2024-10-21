{ config, pkgs, lib, network-config,... }:
let
    hostname = config.networking.hostName;
    endoreg-sensitive = network-config.hardware.${hostname}.endoreg-sensitive;
    
    dropoff-partition-config = network-config.
        hardware.${hostname}.endoreg-sensitive.dropoff;

    processing-partition-config = network-config.
        hardware.${hostname}.endoreg-sensitive.processing;

    processed-partition-config = network-config.
        hardware.${hostname}.endoreg-sensitive.processed;

in {

    imports = [
        ( import ./partition-mounting.nix {
            inherit config pkgs lib network-config;
            partition-config = dropoff-partition-config;
        })
        ( import ./partition-mounting.nix {
            inherit config pkgs lib network-config;
            partition-config = processing-partition-config;
        })
        ( import ./partition-mounting.nix {
            inherit config pkgs lib network-config;
            partition-config = processed-partition-config;
        })
    ];

}