{ lib ? <nixpkgs/lib> , ... }:
let
    base = import ./base.nix { inherit lib; };
    network = import ../../network/main.nix { inherit lib; };
    domains = network.domains;
    ips = network.ips;
    service-hosts = import ../../service-hosts.nix { inherit lib; };

    ssl-certificate-path = base.paths.ssl-certificate;
    ssl-certificate-key-path = base.paths.ssl-certificate-key;

    virtual-hosts = {
        "${domains.keycloak}" = {
            # forceSSL = true;
            sslCertificate = ssl-certificate-path;
            sslCertificateKey = ssl-certificate-key-path;

            listen = [
                {
                    addr = ips.clients."${service-hosts.nginx}";
                    port = 443;
                    ssl = true;
                }
                {
                    addr = ips.clients."${service-hosts.nginx}";
                    port = 80;
                    ssl = false;
                }
            ];

            locations."/" = {
                proxyPass = "http://127.0.0.1:${toString network.ports.keycloak.http}"; # TODO FIXME
                extraConfig = base.all-extraConfig;
            };
        };
    };

in virtual-hosts