{config, pkgs, lib, network-config, ...}:
let
    conf = network-config.services.databases.base-backup;

in {

    environment.systemPackages = with pkgs; [
        postgresql
    ];

    networking.firewall.allowedTCPPorts = [ conf.settings.port ];

    services.postgresql = {
        enable = true;
        enableTCPIP = true;
        dataDir = conf.data-dir;

        authentication = conf.authentication;

        identMap = conf.ident-map;
        settings = conf.settings;
    };

    systemd.services.postgresql-standby-setup = {
        description = "Setup PostgreSQL Standby Configuration";
        wantedBy = [ "multi-user.target" ];
        before = [ "postgresql.service" ];  # Ensure this runs before the main PostgreSQL service starts
        path = with pkgs; [ postgresql ];
        script = ''
            if [ ! -f /var/lib/postgresql/data/standby.signal ]; then
                # Perform base backup from primary server
                echo "Starting base backup from primary..."
                PGPASSFILE=/etc/replication.pgpass pg_basebackup -h 172.16.255.1 -D /var/lib/postgresql/data -U replication_user -Fp -Xs -P
                
                # Mark the server as a standby by creating standby.signal
                touch /var/lib/postgresql/data/standby.signal
                
                # Set up replication parameters using ALTER SYSTEM
                echo "Configuring primary_conninfo for streaming replication..."
                psql -d postgres -c "ALTER SYSTEM SET primary_conninfo TO 'host=172.16.255.1 port=5432 user=replication_user';"

                # Reload PostgreSQL to apply the changes from postgresql.auto.conf
                echo "Reloading PostgreSQL configuration..."
                systemctl reload postgresql.service
            fi
        '';
    };






}

