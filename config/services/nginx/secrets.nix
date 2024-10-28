{ lib ? <nixpkgs/lib> , ... }:
let
    base = import ./base.nix { inherit lib; };

    secrets = {
        shared = {};
        server = {
            ssl-certificate = {
                sopsFile = "${secret-root}/endo-reg-net-cert-fullchain.pem";
                path = base.paths.ssl-certificate;
                format = "binary";
                owner = base.user;
                group = base.group;
                mode = base.filemode-secret;
            };
            ssl-certificate-key = {
                sopsFile = "${secret-root}/endo-reg-net.key";
                path = base.paths.ssl-certificate-key;
                format = "binary";
                owner = base.user;
                group = base.group;
                mode = base.filemode-secret;
            };
        };
        local = {};
    };

in secrets