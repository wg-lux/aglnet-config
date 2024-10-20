let
    network-config = {
        ips = import ./ips.nix;
        hostnames = import ./hostnames.nix;
        users = import ./users/main.nix;
        groups = import ./groups/main.nix;
        hardware = import ./hardware/main;
        paths = import ./paths/main.nix;
        services = import ./services/main.nix;
        scripts = import ./scripts/main.nix;
    };

in network-config