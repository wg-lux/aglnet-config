{ lib ? <nixpkgs/lib> , ... }:
let
    base = import ./base.nix { inherit lib; };

    ssl-certificate-path = base.paths.ssl-certificate;
    ssl-certificate-key-path = base.paths.ssl-certificate-key;

    virtual-hosts = {
        "keycloak.endo-reg.net" = {
            # forceSSL = true;
            sslCertificate = ssl-certificate-path;
            sslCertificateKey = ssl-certificate-key-path;
            locations."/" = {
                proxyPass = "http://127.0.0.1:8080"; # TODO FIXME
                extraConfig = base.all-extraConfig;
            };
        };
    };

in virtual-hosts