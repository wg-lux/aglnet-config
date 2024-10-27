{lib,...}:
let
    network-config = {
        hostnames = import ./hostnames.nix { inherit lib; };
        network = import ./network/main.nix { inherit lib; };
        users = import ./users/main.nix { inherit lib;};
        groups = import ./groups/main.nix { inherit lib; };
        hardware = import ./hardware/main.nix { inherit lib; };
        paths = import ./paths/main.nix { inherit lib; };
        services = import ./services/main.nix { inherit lib; };
        scripts = import ./scripts/main.nix { inherit lib; };
        service-hosts = import ./service-hosts.nix {};
        # util-functions = import ./util-functions.nix { inherit lib; };
    };
in network-config