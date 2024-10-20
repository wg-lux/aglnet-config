{ config, network-config, ... }@args:

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


    users.groups = {
        "${groups.maintenance.name}".gid = groups.maintenance.gid;
        "${groups.service.name}".gid = groups.service.gid;
        "${groups.logging.name}".gid = groups.logging.gid;
        "${groups.center.name}".gid = groups.center.gid;
    };
}