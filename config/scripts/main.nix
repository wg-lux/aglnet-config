{ ... }:
let
    scripts = {
        user-info = import ./user-info.nix { };
    };

in scripts