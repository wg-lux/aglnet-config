{ lib, ... }:
let
    groups = import ../groups/main.nix { inherit lib; };
    paths = import ../paths/main.nix { };
    
    maintenance-group = groups.maintenance.name;
    service-group = groups.service.name;
    logging-group = groups.logging.name;
    center-group = groups.center.name;

    base-groups = ["network-manager"];

    dev-access = base-groups ++ [
        "wheel"
        maintenance-group
        service-group
        logging-group
        center-group
    ];

    users = {
        root = {
            name = "root";
        };
        admin = {
            name = "agl-admin";
            config = {
                isNormalUser = true;
                extraGroups = ["networkManager" "wheel" "maintenance"];
            };
        };
        setup = {
            name = "setup-user";
            config = {
                isNormalUser = true;
                extraGroups = dev-access;
            };
        };
        service = {
            name = "service-user";
            config = {
                isNormalUser = true;
                extraGroups = [service-group];
            };
        };
        center = {
            name = "center-user";
            config = {
                isNormalUser = true;
                extraGroups = ["networkManager"];
            };
        };
        logging = {
            name = "logging-user";
            config = {
                isNormalUser = true;
                extraGroups = [logging-group];
            };
        };
        maintenance = {
            name = "maintenance-user";
            config = {
                isNormalUser = true;
                extraGroups = [maintenance-group];
            };
        };

    };
in users