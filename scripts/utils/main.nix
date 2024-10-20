{ config, pkgs, network-config, ...}:
{
    imports = [
        ./get-filesystems.nix
        ./user-info.nix
    ];
}