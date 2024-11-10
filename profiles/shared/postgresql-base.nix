{config, pkgs, lib, network-config, ...}:
let
    conf = network-config.services.databases.base;

in {
    networking.firewall.allowedTCPPorts = [ conf.settings.port ];

    services.postgresql = {
        enable = true;
        enableTCPIP = true;
        dataDir = conf.data-dir;

        ensureDatabases = conf.ensure-databases;
        authentication = conf.authentication;

        identMap = conf.ident-map;
#

        settings = conf.settings;
    };



}