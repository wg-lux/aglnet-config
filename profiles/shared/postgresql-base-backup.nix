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
    systemd.services.pg-replication-init = {
        description = "Initialize PostgreSQL Replication if pg_wal is missing";
        after = [ "network.target" ]; # Start after network is up
        wants = [ "network.target" ];

        # Use the default "oneshot" service type
        serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.bash}/bin/bash -c ${''
            #!/bin/bash

            # Check if replication is initialized by checking pg_wal existence
            if [ ! -d "${conf.data-dir}/pg_wal" ]; then
            echo "pg_wal directory not found. Initializing replication..."

            # Run pg_basebackup
            PGPASSFILE=${conf.target-db-pass-file} pg_basebackup -h ${conf.target-db-ip} -D ${conf.data-dir} -U ${conf.target-db-user} -P --wal-method=stream

            # Check if the backup succeeded
            if [ $? -ne 0 ]; then
                echo "pg_basebackup failed, exiting."
                exit 1
            fi

            # Create standby.signal file to indicate this is a standby server
            touch "${conf.data-dir}/standby.signal"

            # Append primary_conninfo to postgresql.auto.conf
            echo "primary_conninfo = 'host=${conf.target-db-ip} port=${toString conf.target-db-port} user=${conf.target-db-user} passfile=${conf.target-db-pass-file}'" >> ${conf.data-dir}/postgresql.auto.conf

            echo "Replication initialized successfully."
            else
            echo "pg_wal directory already exists. Replication is already initialized."
            fi
        ''}";
        };

        # Ensure it runs after PostgreSQL has been installed
        wantedBy = [ "multi-user.target" ];
    };




}

