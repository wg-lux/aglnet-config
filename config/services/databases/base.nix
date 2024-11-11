{lib ? import <nixpkgs/lib>, ...}:

let

    service-hosts = import ../../service-hosts.nix { inherit lib; };
    service-users = import ../../service-users.nix { inherit lib; };
    hostnames = import ../../hostnames.nix {};
    paths = import ../../paths/main.nix { inherit lib; };
    network = import ../../network/main.nix { inherit lib; };

    client-ips = network.ips.clients;
    host-raw = service-hosts.postgresql-base;
    backup-host-raw = service-hosts.postgresql-base-backup;

  base = {
    base-db = {
      port = network.ports.postgresql.base;

      host-raw = host-raw;
      host = hostnames."${host-raw}";
      ip = client-ips."${host-raw}";

      backup-host-raw = backup-host-raw;
      host-backup = hostnames."${backup-host-raw}";
      ip-backup = client-ips."${backup-host-raw}";

      host-keycloak-hostname = hostnames."${service-hosts.keycloak}";
      host-keycloak-ip = client-ips."${service-hosts.keycloak}";
      keycloak-user = service-users.keycloak.user.name;
      replication-user = "replication_user"; 

      users = {
        aglnet-base = {
          name = "aglnet_base";
          ensureDBOwnership = true;
          ensureClauses = {};
        };
      };
    };
  };

in base