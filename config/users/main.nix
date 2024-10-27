{ lib, ... }:
let
    groups = import ../groups/main.nix { inherit lib; };
    paths = import ../paths/main.nix { };
    
    maintenance-group = groups.maintenance.name;
    service-group = groups.service.name;
    logging-group = groups.logging.name;
    center-group = groups.center.name;
    
    # Endoreg Access Groups:
    endoreg-dropoff-group = groups.endoreg-dropoff.name;
    endoreg-processing-group = groups.endoreg-processing.name;
    endoreg-processed-group = groups.endoreg-processed.name;

    base-groups = ["network-manager"];

    dev-access = base-groups ++ [
        "wheel"
        maintenance-group
        service-group
        logging-group
        center-group
        endoreg-dropoff-group
        endoreg-processing-group
        endoreg-processed-group
    ];

    users = {
        root = {
            name = "root";
        };
        admin = {
            name = "agl-admin";
            config = {
                isNormalUser = true;
                extraGroups = [
                    "networkManager" 
                    "wheel" 
                    endoreg-dropoff-group
                    endoreg-processing-group
                    endoreg-processed-group
                ];
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
                extraGroups = [
                    service-group
                    endoreg-dropoff-group
                    endoreg-processing-group
                    endoreg-processed-group
                ];
            };
        };
        center = {
            name = "center-user";
            config = {
                isNormalUser = true;
                extraGroups = [
                    "networkManager"
                    endoreg-dropoff-group
                ];
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

        openvpn = {
            name = "openvpn-user";
            config = {
                isNormalUser = false;
                isSystemUser = true;
                group = groups.openvpn.name;
                extraGroups = ["network-manager" "wheel"]; #2 TODO reduce permissions after initial testing
            };
        };

    };
in users