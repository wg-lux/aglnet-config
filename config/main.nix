let
    network-config = {
        ips = import ./ips.nix;
        hostnames = import ./hostnames.nix;
        users = import ./users.nix;
    };

in network-config