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

    ssl-cert-root = {
        path = paths.ssl-cert-root;
        owner = users.nginx.name;
        group = groups.nginx.name;
        permissions = "0600";
    };

    openvpn-dirs = [
        {
            path = paths.openvpn.certificate-root;
            owner = users.service.name;
            group = groups.service.name;
            permissions = "0700";
        }
        {
            path = paths.openvpn.openvpn-root;
            owner = users.service.name;
            group = groups.service.name;
            permissions = "0700";
        }
        {
            path = paths.openvpn.server.ccd;
            owner = users.service.name;
            group = groups.service.name;
            permissions = "0700";
        }
    ];


    dirs = [
        {
            path = paths.users.nixos-password-directory;
            owner = users.root.name;
            group = users.root.name;
            permissions = "0700";
        }
    ] ++ endoreg-client-dirs ++ openvpn-dirs;

in dirs
