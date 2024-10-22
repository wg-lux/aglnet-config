{ config, pkgs, lib, network-config, ... }:
{
    specialisation = {
        maintenance-mode = {
            system.nixos.tags = [ "maintenance" ];
            # define some specialisation for maintenance mode, e.g. open firewall for ssh, ...
        };
    };

}