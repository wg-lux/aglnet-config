{ ... }:
let
    paths = {
        hardware = import ./hardware.nix { };
        users = import ./users.nix { };
        sops = import ./sops.nix { };
    };

in paths