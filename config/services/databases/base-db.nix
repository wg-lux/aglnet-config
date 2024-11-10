{ lib ? import <nixpkgs/lib>, ...}:
let 

    service-hosts = import ../../service-hosts.nix { inherit lib; };
    service-users = import ../../service-users.nix { inherit lib; };
    hostnames = import ../../hostnames.nix {};
    paths = import ../../paths/main.nix { inherit lib; };
    network = import ../../network/main.nix { inherit lib; };

    client-ips = network.ips.clients;

    host-raw = service-hosts.postgresql-base;
    host = hostnames."${host-raw}";
    ip = client-ips."${host-raw}";

    host-keycloak-hostname = hostnames."${service-hosts.keycloak}";
    host-keycloak-ip = client-ips."${service-hosts.keycloak}";
    keycloak-user = service-users.keycloak.user.name;

    base-db-conf = {
      settings = {
            port = network.ports.postgresql.base;
            listen_addresses = lib.mkForce "localhost,127.0.0.1,${ip}"; # defaults to "*" if enableTCPIP is true;
            # log_connections = true;
            # log_statement = "all";
            # logging_collector = true;
            # log_disconnections = true;
            # log_destination = "syslog";
        };

        data-dir = "/var/lib/postgresql/15"; # if changed we need to make sure the directory exists (e.g. using tmpfiles)

        ensure-users = [
            {
                name = "agl-admin";
                ensureDBOwnership = true;
            }
            {
                name = keycloak-user;
                ensureDBOwnership = true;
            }
        ];

        ensure-databases = [ "agl-admin" ];
        
        authentication = lib.mkOverride 10 ''
            #type database          DBuser             address                auth-method         optional_ident_map
            local sameuser          all                                       peer                map=superuser_map
            host  ${keycloak-user}  ${keycloak-user}   127.0.0.1/32           scram-sha-256 
            host  ${keycloak-user}  ${keycloak-user}   ${host-keycloak-ip}/32 scram-sha-256
        '';

        ident-map = lib.mkOverride 10 ''
            # ArbitraryMapName systemUser DBUser
            superuser_map      root      postgres
            superuser_map      postgres  postgres
            superuser_map      ${keycloak-user}  ${keycloak-user}
            superuser_map      keycloak   ${keycloak-user}
            # Let other names login as themselves
            superuser_map      /^(.*)$   \1
        '';
        
    };

in base-db-conf
  

  