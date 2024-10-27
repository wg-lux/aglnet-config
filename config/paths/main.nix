{ ... }:
let
    paths = {
        hardware = import ./hardware.nix { };
        users = import ./users.nix { };
        sops = import ./sops.nix { };
        logging = import ./logging.nix { };
        openvpn = import ./openvpn.nix { };
    };

in paths