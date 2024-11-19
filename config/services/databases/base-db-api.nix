{ lib ? import <nixpkgs/lib>, ...}:
let 

    base = import ./base.nix { inherit lib; };
    service-hosts = import ../../service-hosts.nix { inherit lib; };
    service-users = import ../../service-users.nix { inherit lib; };
    groups = import ../../groups/main.nix { inherit lib; };
    hostnames = import ../../hostnames.nix {};

    service-user = service-users.endoreg-base-db-api.user.name;

    data-dir = "data/";

    filepaths = rec {
      parent = "/home/${service-user}/services";
      repo-dir = "${parent}/endoreg-base-api";
      conf-dir = "/var/endoreg-db-api/data";
      db-user = "${conf-dir}/db-user";
      db-pwd = "${conf-dir}/db-pwd";
      db-host = "${conf-dir}/db-host";
      db-port = "${conf-dir}/db-port";
      db-name = "${conf-dir}/db-name";
    };

    db-conf = base.base-db;

    hostname-raw = service-hosts.postgresql-base-api;
    hostname = hostnames."${hostname-raw}";

    base-db-api = {
      repo-url = "https://github.com/wg-lux/endoreg-db-api";
      user = service-user;
      group = groups.service.name;
      db-user = db-conf.users.aglnet-base.name;
      db-ip = db-conf.ip;
      db-port = db-conf.port;
      db-name = db-conf.users.aglnet-base.name;

      secrets-file = ../../../secrets/${hostname}/endoreg-db-api.yaml;

      paths = filepaths;
    };

in base-db-api