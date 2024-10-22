{ lib, is-endoreg-client ? false, ... }:
let
    paths = import ../../paths/main.nix { };
    users = import ../../users/main.nix { inherit lib; };
    groups = import ../../groups/main.nix { inherit lib; };

    endoreg-client-dirs = if is-endoreg-client then [
        {
            path = paths.logging.sensitive-partition-log-dir;
            owner = users.logging.name;
            group = groups.logging.name;
            permissions = "0744";
        }
        
    ] else [];


    dirs = [
        {
            path = paths.users.nixos-password-directory;
            owner = users.root.name;
            group = users.root.name;
            permissions = "0700";
        }
    ] ++ endoreg-client-dirs;

in dirs
