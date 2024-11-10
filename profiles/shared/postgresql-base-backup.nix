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
                echo "primary_conninfo = 'host=${conf.target-db-ip} port=${conf.target-db-port} user=${conf.target-db-user} passfile=${conf.target-db-pass-file}'" >> ${conf.data-dir}/postgresql.auto.conf
            
                chown -R postgres:postgres ${conf.data-dir}
                chmod 700 ${conf.data-dir}
            '';
        };
    };

    # Define Nix tmpfiles rules to create the backup directory with correct permissions
    systemd.tmpfiles.rules = [
        "d ${conf.backup-dir} 0700 postgres postgres -"
    ];

    # Define a systemd timer to perform more granular backups of individual databases.
    # This will help reduce peak loads and minimize locking issues.
    systemd.timers.pg_database_backup = {
        enable = true;
        description = "Granular backup of PostgreSQL databases every hour";
        timerConfig.OnCalendar = "hourly";
        wantedBy = [ "timers.target" ];
    };

    # Define the systemd service that performs the granular database backup operation
    systemd.services.pg_database_backup = {
        enable = true;
        description = "Granular Backup of PostgreSQL databases";
        # Run after the PostgreSQL service to ensure the database is running
        after = [ "postgresql.service" ];
        serviceConfig = {
            User = "postgres";  # Run the backup as the postgres user
            ExecStart = ''
                # Backup each database individually to reduce locking and load
                for db in $(psql -U postgres -t -c "SELECT datname FROM pg_database WHERE datistemplate = false;"); do
                    pg_dump -h localhost -U postgres "$db" > ${conf.backup-dir}/pg_backup_${db}_$(date +\%Y\%m\%d_%H%M).sql
                done
            '';
            # Retain backups for 30 days and automatically delete old backups to manage storage
            ExecStartPost = "find ${conf.backup-dir} -name '*.sql' -mtime +30 -delete";
        };
    };
}

# Documentation for Backup Configuration

# 1. **Granular Backup Strategy**:
#    - Instead of using `pg_dumpall` to back up all databases at once, which can lead to high resource utilization and potential database locks,
#      the new configuration uses `pg_dump` to back up each individual database separately.
#    - The `pg_database_backup` systemd service iterates over each non-template database and runs `pg_dump`, creating separate SQL dump files for each database.
#    - This helps in reducing peak loads and minimizes the risk of locks affecting the entire server.

# 2. **Backup Frequency**:
#    - The backup timer (`pg_database_backup`) runs hourly, ensuring that recent changes are regularly saved without putting too much strain on the server.
#    - The more frequent, smaller backups are less likely to cause disruptions compared to a single large daily backup.

# 3. **Backup Retention Policy**:
#    - The backup retention policy is implemented with a `find` command that automatically deletes backups older than 30 days.
#    - This ensures that the `${conf.backup-dir}` directory does not run out of space due to old backups piling up.

# 4. **Ensuring Backup Directory Availability**:
#    - The Nix `tmpfiles` rule (`systemd.tmpfiles.rules`) ensures that the `${conf.backup-dir}` directory is always available with the correct permissions.
#    - The directory is created with permissions `0700` and owned by the `postgres` user to ensure that only the PostgreSQL user has access to the backups.
#    - This improves security by limiting access to sensitive database backups.
