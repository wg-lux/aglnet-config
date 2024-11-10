{ config, pkgs, lib, network-config, ... }@args:

let
  hostname = config.networking.hostName;

  users = network-config.users;
  groups = network-config.groups;

in { 
    users.users."${users.setup.name}" = users.setup.config;
    users.users."${users.admin.name}" = users.admin.config;
    users.users."${users.service.name}" = users.service.config;
    users.users."${users.center.name}" = users.center.config;
    users.users."${users.logging.name}" = users.logging.config;
    users.users."${users.maintenance.name}" = users.maintenance.config;
    users.users."${users.openvpn.name}" = users.openvpn.config;
    users.users."${users.keycloak.name}" = users.keycloak.config;


    users.groups = {
        "${groups.maintenance.name}".gid = groups.maintenance.gid;
        "${groups.service.name}".gid = groups.service.gid;
        "${groups.logging.name}".gid = groups.logging.gid;
        "${groups.center.name}".gid = groups.center.gid;
        "${groups.endoreg-dropoff.name}".gid = groups.endoreg-dropoff.gid;
        "${groups.endoreg-processing.name}".gid = groups.endoreg-processing.gid;
        "${groups.endoreg-processed.name}".gid = groups.endoreg-processed.gid;
        "${groups.openvpn.name}".gid = groups.openvpn.gid;
        "${groups.keycloak.name}".gid = groups.keycloak.gid;
    };

    imports = [
        (import ./user-passwords.nix { inherit config pkgs lib network-config; })
    ];
}