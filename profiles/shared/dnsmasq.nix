{ config, pkgs, lib, network-config, ... }:

let 

    dnsmasq-conf = network-config.services.dnsmasq;
    dnsmasq-port = dnsmasq-conf.port;
    dnsmasq-extra-config = dnsmasq-conf.extra-config;

in {

    # networking.firewall.allowedUDPPorts = [ dnsmasq-port ];
    # services.dnsmasq = {
    #     enable = true;
    #     # extraConfig = dnsmasq-extra-config; ## DEPRECEATED
    #     alwaysKeepRunning = true;
    #     settings = dnsmasq-conf.settings;
    # };

}