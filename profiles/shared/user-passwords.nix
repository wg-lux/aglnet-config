{config, pkgs, lib, network-config, ...}:
let
    hostName = config.networking.hostName;
    users = network-config.users;
    paths = network-config.paths;

    pwd-dir = paths.users.nixos-password-directory;

    sops-file = ../../secrets + ("/" + "${hostName}/nix-user.yaml");

    sops-target-setup-user = "nixos/user/${users.setup.name}/pwd-hashed"; 
    sops-target-service-user = "nixos/user/${users.service.name}/pwd-hashed"; 
    sops-target-center-user = "nixos/user/${users.center.name}/pwd-hashed"; 
    sops-target-logging-user = "nixos/user/${users.logging.name}/pwd-hashed"; 
    sops-target-admin-user = "nixos/user/${users.admin.name}/pwd-hashed"; 
    sops-target-maintenance-user = "nixos/user/${users.maintenance.name}/pwd-hashed";

in {


    sops.secrets."${sops-target-setup-user}" = {
        sopsFile = sops-file;
        neededForUsers=true;
    };

    sops.secrets."${sops-target-service-user}" = {
        sopsFile = sops-file;
        neededForUsers=true;
    };

    sops.secrets."${sops-target-center-user}" = {
        sopsFile = sops-file;
        neededForUsers=true;
    };

    sops.secrets."${sops-target-logging-user}" = {
        sopsFile = sops-file;
        neededForUsers=true;
    };

    sops.secrets."${sops-target-admin-user}" = {
        sopsFile = sops-file;
        neededForUsers=true;
    };

    sops.secrets."${sops-target-maintenance-user}" = {
        sopsFile = sops-file;
        neededForUsers=true;
    };
    # sops -e nix-users.yaml > secrets/

    users.users = {
        "${users.service.name}".hashedPasswordFile = config.sops.secrets."${sops-target-service-user}".path;
        "${users.setup.name}".hashedPasswordFile = config.sops.secrets."${sops-target-setup-user}".path;
        "${users.admin.name}".hashedPasswordFile = config.sops.secrets."${sops-target-admin-user}".path;
        "${users.center.name}".hashedPasswordFile = config.sops.secrets."${sops-target-center-user}".path;
        "${users.logging.name}".hashedPasswordFile = config.sops.secrets."${sops-target-logging-user}".path;
        "${users.maintenance.name}".hashedPasswordFile = config.sops.secrets."${sops-target-maintenance-user}".path;
    };
}