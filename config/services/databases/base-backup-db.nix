{ lib ? import <nixpkgs/lib>, ...}:
let 

    base = import ./base.nix { inherit lib; };
    conf = base.base-db;
    data-dir = "/var/lib/postgresql/data";

    base-db-conf = {
      host = conf.host-backup;
      target-db-host = conf.host;

      target-db-ip = conf.ip;
      target-db-port = conf.port;
      target-db-user = conf.replication-user;
      target-db-pass-file = data-dir + "/.pgpass";
      backup-dir = "/backup";

      settings = {
            hot_standby = true;
            port = conf.port;
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
            local sameuser                  all                                                scram-sha-256
        '';

        ident-map = lib.mkOverride 10 ''
            # ArbitraryMapName systemUser DBUser
            superuser_map      root      postgres
            superuser_map      postgres  postgres
            # Let other names login as themselves
            superuser_map      /^(.*)$   \1
        '';
        
    };

in base-db-conf
  

  