{ lib ? import <nixpkgs/lib>, ...}:
let 

    service-hosts = import ../../service-hosts.nix { inherit lib; };
    service-users = import ../../service-users.nix { inherit lib; };
    hostnames = import ../../hostnames.nix {};
    paths = import ../../paths/main.nix { inherit lib; };


    network = import ../../network/main.nix { inherit lib; };
    ips = network.ips.services.keycloak;

    host-ip = ips.host;

    host = hostnames."${service-hosts.keycloak}";
    domain = network.domains.keycloak;
    url = network.urls.keycloak;
    keycloak-user = service-users.keycloak.user.name;
    postgresql-base-port = network.ports.postgresql.base;
    postgresql-host-raw = service-hosts.postgresql-base;
    postgresql-host-ip = network.ips.clients."${postgresql-host-raw}";

    keycloak = {
        hostname = host;
        user = service-users.keycloak.user.name;
        group = service-users.keycloak.group;
        host-ip = host-ip;
        http-host = host-ip; # was localhost in last setup
        http-port = network.ports.keycloak.http;
        https-port = network.ports.keycloak.https;
        domain = network.domains.keycloak;
        domain-admin = network.domains.keycloak-admin;

        database = {
            createLocally = false;
            username = keycloak-user; # defaults to keycloak, currently keycloak-user
            useSSL = false;
            passwordFile = paths.keycloak.postgresql-keycloak_user-password-file;

            host = postgresql-host-ip;
            name = keycloak-user; # defaults to keycloak
            port = postgresql-base-port;
        };

        proxy = "edge"; #none (default), edge, reencrypt, passthrough;  The proxy address forwarding mode if the server is behind a reverse proxy. https://www.keycloak.org/server/reverseproxy for
        initialAdminPassword = "changeme";
        
        sslCertificateKey = paths.nginx.ssl-certificate-key;
        sslCertificate = paths.nginx.ssl-certificate;

    };

in keycloak