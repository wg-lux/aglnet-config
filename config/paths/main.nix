{ ... }:
let
    paths = {
        hardware = import ./hardware.nix { };
        users = import ./users.nix { };
        sops = import ./sops.nix { };
        logging = import ./logging.nix { };
    };

in paths