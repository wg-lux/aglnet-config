{ lib ? <nixpkgs/lib> , ... }:
let
    base = import ./base.nix { inherit lib; };

    secret-root = ../../../secrets/${base.hostname}/nginx;

    secrets = {
        shared = {};
        server = {
            ## Deprecated in favour of manual deployment
            # ssl-certificate = {
            #     sopsFile = "${secret-root}/endo-reg-net-cert-fullchain.pem";
            #     path = base.paths.ssl-certificate;
            #     format = "binary";
            #     owner = base.user;
            #     group = base.group;
            #     mode = base.filemode-secret;
            # };
            # ssl-certificate-key = {
            #     sopsFile = "${secret-root}/endo-reg-net.key";
            #     path = base.paths.ssl-certificate-key;
            #     format = "binary";
            #     owner = base.user;
            #     group = base.group;
            #     mode = base.filemode-secret;
            # };
        };
        local = {};
    };

in secrets