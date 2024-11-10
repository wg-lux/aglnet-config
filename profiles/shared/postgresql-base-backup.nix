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

        ensureDatabases = conf.ensure-databases;
        ensureUsers = conf.ensure-users;
        authentication = conf.authentication;

        identMap = conf.ident-map;
#

        settings = conf.settings;
    };

    # Define a systemd service to handle the initial setup of the secondary server's data directory
    # using pg_basebackup from the primary server.
    systemd.services.pg_basebackup = {
        enable = true;
        description = "Initial PostgreSQL base backup for replication setup";
        after = [ "network.target" "openvpn-aglNet.target"];
        wantedBy = [ "multi-user.target" ];
        # Service configuration
        serviceConfig = {
            ExecStartPre = [ "! [ -d ${conf.data-dir}/pg_wal ]" ];

            ExecStart = ''
                pg_basebackup -h ${target-db-ip} -D ${conf.data-dir} -U ${conf.target-db-user} -W -P --wal-method=stream
            '';

            # Configure the replication settings after the backup completes
            ExecStartPost = ''
                # Create the standby signal file (required for PostgreSQL versions 12+)
                touch ${conf.data-dir}/standby.signal

                # Configure the primary server connection settings in `postgresql.auto.conf`
                echo "primary_conninfo = 'host="${conf.target-db-ip} port=${conf.target-db-port} user=${conf.target-db-user} passfile=${conf.target-db-pass-file}'" >> ${conf.data-dir}/postgresql.auto.conf
            
                chown -R postgres:postgres ${conf.data-dir}
                chmod 700 ${conf.data-dir}
            '';
        
        };
    };

    systemd.timers.pg_backup = {
        enable = true;
        description = "Daily backup of PostgreSQL data";
        timerConfig.OnCalendar = "*-*-* *:00/15:00";  # Run every 15 minutes
        wantedBy = [ "timers.target" ];
    };

    # Define the service that performs the backup operation
    systemd.services.pg_backup = {
        enable = true;
        description = "Backup PostgreSQL data";
        # Run after the pg_basebackup timer and database service
        after = [ "postgresql.service" ];
        serviceConfig = {
        User = "postgres";  # Run the backup as the postgres user
        ExecStart = ''
            pg_dumpall -h localhost -U postgres > /backup/pg_backup_$(date +\%Y\%m\%d).sql
        '';
        # Retain backups for 30 days and automatically delete old backups to manage storage
        ExecStartPost = "find /backup -name '*.sql' -mtime +30 -delete";
        };
    };



}