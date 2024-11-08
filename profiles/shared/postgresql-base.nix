{config, pkgs, lib, network-config, ...}:
let
    port = 5432;

    conf = {
        settings = {
            port = port;
            log_connections = true;
            log_statement = "all";
            logging_collector = true;
            log_disconnections = true;
            log_destination = "syslog";
        };

        ensure-users = [
            {
                name = "keycloak";
                ensureDBOwnership = true; #Grants the user ownership to a database with the same name. This database must be defined manually in services.postgresql.ensureDatabases.
            }
            {
                name = "agl-admin";
                ensureDBOwnership = true;
            }
        ];

        ensure-databases = [ "mydatabase" ];

        
    };

in {
    # services.postgresql = {
    #     enable = true;

    #     ensureDatabases = conf.ensure-databases;
    #     authentication = pkgs.lib.mkOverride 10 ''
    #     #type database  DBuser  auth-method
    #     local all       all     trust
    #     '';

    #     settings = conf.settings;
    # };



}