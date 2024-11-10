{ lib ? import <nixpkgs/lib>, ...}:
let 

    base = import ./base.nix { inherit lib; };
    conf = base.base-db;
    data-dir = "/var/lib/postgresql/15";

    base-db-conf = {
      host = conf.host-backup;
      target-db-host = conf.host;

      target-db-ip = conf.ip;
      target-db-port = conf.port;
      target-db-user = conf.replication-user;
      target-db-pass-file = data-dir + "/.pgpass";

      settings = {
            port = conf.port;
            listen_addresses = lib.mkForce "localhost,${conf.ip-backup}"; # defaults to "*" if enableTCPIP is true;
            hot_standby = true;
            password_encryption = "scram-sha-256";


            # log_connections = true;
            # log_statement = "all";
            # logging_collector = true;
            # log_disconnections = true;
            # log_destination = "syslog";
        };

        data-dir = data-dir; # if changed we need to make sure the directory exists (e.g. using tmpfiles)

        ensure-users = [
            {
                name = conf.replication-user;
                ensureDBOwnership = true;
                ensureClauses = {
                    replication = true;
                };
            }
        ];

        ensure-databases = [ 
            conf.replication-user
        ];

        
        authentication = lib.mkOverride 10 ''
            #type database                  DBuser                      address                     auth-method         optional_ident_map
            local sameuser                  all                                                     peer                map=superuser_map
            host  ${conf.replication-user}  ${conf.replication-user}    ${conf.ip}/32         scram-sha-256
        '';

        ident-map = lib.mkOverride 10 ''
            # ArbitraryMapName systemUser DBUser
            superuser_map      root      postgres
            superuser_map      root     ${conf.replication-user}
            superuser_map      postgres  postgres
            # Let other names login as themselves
            superuser_map      /^(.*)$   \1
        '';
        
    };

in base-db-conf
  

  