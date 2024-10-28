{ config, pkgs, lib, network-config, ... }:

let 

    conf = network-config.services.dnsmasq;

    port = conf.port;

    extra-config = conf.extra-config;

in {

    networking.firewall.allowedUDPPorts = [ port ];


    services.dnsmasq = {
        enable = true;
        extraConfig = extra-config;
        alwaysKeepRunning = true;
    };


}