{ lib ? import <nixpkgs/lib>, ...}:
let 

    service-hosts = import ../../service-hosts.nix { inherit lib; };
    hostnames = import ../../hostnames.nix {};
    paths = import ../../paths/main.nix { inherit lib; };

    network = import ../../network/main.nix { inherit lib; };
    ips = network.ips.services.keycloak;
    host-ip = ips.host;

    host = hostnames."${service-hosts.keycloak}";

    keycloak = {
        host = host;
        host-ip = host-ip;
        http-port = network.ports.keycloak.http;
        https-port = network.ports.keycloak.https;
        domain = network.domains.keycloak;

        proxy = "edge";
        initialAdminPassword = "admin";
        
        sslCertificateKey = paths.nginx.ssl-certificate-key;
        sslCertificate = paths.nginx.ssl-certificate;

        # database


    };

in keycloak