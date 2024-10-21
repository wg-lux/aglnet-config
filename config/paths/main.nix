{ ... }:
let
    paths = {
        hardware = import ./hardware.nix { };
        users = import ./users.nix { };
    };

in paths