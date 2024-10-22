{ config, pkgs, lib, network-config, ... }:
{
    specialisation = {
        maintenance.configuration = {
            system.nixos.tags = [ "maintenance" ];
            # define some specialisation for maintenance mode, e.g. open firewall for ssh, ...
        };
    };

}