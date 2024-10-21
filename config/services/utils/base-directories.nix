{ lib, ... }:

let
    paths = import ../../paths/main.nix { };
    users = import ../../users/main.nix { inherit lib; };

    dirs = [
        {
            path = paths.users.nixos-password-directory;
            owner = users.root.name;
            group = users.root.name;
            permissions = "0700";
        }
    ];

in dirs
