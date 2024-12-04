{ config, lib, pkgs, network-config, ...}:
{
    imports = [
        ./get-filesystems.nix
        ./user-info.nix
        (import ./base-directories.nix {
            inherit config lib pkgs network-config;
        })
        ./deep-clean.nix
    ];
}