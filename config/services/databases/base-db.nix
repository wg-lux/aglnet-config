{ lib ? import <nixpkgs/lib>, ...}:
let 

    base = import ./base.nix { inherit lib; };
    conf = base.base-db;

    base-db-conf = {
        host = conf.host;
        settings = {
            port = conf.port;
            listen_addresses = lib.mkForce "localhost,127.0.0.1,${conf.ip}"; # defaults to "*" if enableTCPIP is true;
            # Enable WAL archiving and set the level to logical or replica
            wal_level = "replica";
            # Set the number of maximum concurrent connections from standby servers
            max_wal_senders = 5;
            # Enable WAL logging
            wal_keep_size = "512MB";
            password_encryption = "scram-sha-256";
            hot_standby = true;


            # log_connections = true;
            # log_statement = "all";
            # logging_collector = true;
            # log_disconnections = true;
            # log_destination = "syslog";
        };

        data-dir = "/var/lib/postgresql/15"; # if changed we need to make sure the directory exists (e.g. using tmpfiles)

        ensure-users = [
            {
                name = conf.replication-user;
                ensureDBOwnership = true;
                ensureClauses = {
                    replication = true;
                };
            }
            {
                name = conf.keycloak-user;
                ensureDBOwnership = true;
            }
            {
                name = conf.users.aglnet-base.name;
                ensureDBOwnership = conf.users.aglnet-base.ensureDBOwnership;
                ensureClauses = conf.users.aglnet-base.ensureClauses;
            }
        ];

        ensure-databases = [ 
            conf.keycloak-user
            conf.replication-user
            conf.users.aglnet-base.name
        ];

        
        authentication = lib.mkOverride 10 ''
            #type database                  DBuser                      address                     auth-method         optional_ident_map
            local sameuser                  all                                                     peer                map=superuser_map
            host  ${conf.keycloak-user}     ${conf.keycloak-user}       127.0.0.1/32                scram-sha-256 
            host  ${conf.keycloak-user}     ${conf.keycloak-user}       ${conf.host-keycloak-ip}/32 scram-sha-256
            host  replication               ${conf.replication-user}    ${conf.ip-backup}/32        scram-sha-256
            host  ${conf.users.aglnet-base.name} ${conf.users.aglnet-base.name} 172.16.255.142/32 scram-sha-256
        '';

        ident-map = lib.mkOverride 10 ''
            # ArbitraryMapName systemUser DBUser
            superuser_map      root      postgres
            superuser_map      root      ${conf.replication-user}
            superuser_map      postgres  postgres
            superuser_map      ${conf.keycloak-user}  ${conf.keycloak-user}
            superuser_map      keycloak   ${conf.keycloak-user}
            # Let other names login as themselves
            superuser_map      /^(.*)$   \1
        '';
        
    };

in base-db-conf
  

  