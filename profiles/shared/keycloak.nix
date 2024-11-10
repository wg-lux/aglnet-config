{config, pkgs, lib, network-config, ...}:

let 
    conf = network-config.services.keycloak;

    hostname = conf.hostname;
    domain = conf.domain;

in {

    services.postgresql.ensureUsers = [
      {
        name = conf.user;
        ensureDBOwnership = true; # allows system users
      }  
    ];

    services.postgresql.ensureDatabases = [ conf.user ];
    
    systemd.services.keycloak = {
        wants = [ "openvpn-aglNet.service" "network-online.target" ];
        after = [ "openvpn-aglNet.service" "network-online.target" ];
        serviceConfig = {
        # Add a pre-start script to check for database connectivity
        ExecStartPre = pkgs.writeScript "check-db-connectivity.sh" ''
            #!/bin/sh
            until ${pkgs.netcat}/bin/nc -z ${conf.database.host} ${toString conf.database.port}; do
            echo "Waiting for database connectivity..."
            sleep 1
            done
        '';
        };
    };

    services.keycloak = {
        enable = true;
        initialAdminPassword = conf.initialAdminPassword;
        database = conf.database;

        settings = {
            http-host = conf.http-host;
            http-port = conf.http-port;
            https-port = conf.https-port; 
            proxy = conf.proxy;# edge
            hostname = conf.domain; # currently "keycloak.endo-reg.net"
            hostname-admin = conf.domain-admin; # currently "keycloak-admin.endo-reg.net"
        };

    };
}