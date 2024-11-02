{ lib ? import <nixpkgs/lib>, ...}:
let 

    service-hosts = import ../../service-hosts.nix { inherit lib; };
    hostnames = import ../../hostnames.nix {};
    paths = import ../../paths/main.nix { inherit lib; };

    network = import ../../network/main.nix { inherit lib; };
    ips = network.ips.services.keycloak;
    host-ip = ips.host;

    host = hostnames."${service-hosts.keycloak}";
    domain = network.domains.keycloak;
    url = network.urls.keycloak;

    keycloak = {
        hostname = host;
        host-ip = host-ip;
        http-host = host-ip; # was localhost in last setup
        http-port = network.ports.keycloak.http;
        https-port = network.ports.keycloak.https;
        domain = network.domains.keycloak;
        # database = {
        #     type = "postgresql"; # one of "mysql", "mariadb", "postgresql"
        #     username = "keycloak";
        #     useSSL = false; 
        #     port = 5432; # default is default port for database.type
        #     passwordFile = "/home/agl-admin/.config/keycloak-pwd"; # path to pwd file
        #     name = "keycloak";
        #     host = "172.16.255.4"; # default is localhost
        # #     # caCert = path; # path to ca cert file
        # };

        proxy = "edge";
        initialAdminPassword = "admin";
        
        sslCertificateKey = paths.nginx.ssl-certificate-key;
        sslCertificate = paths.nginx.ssl-certificate;

        # database


    };

in keycloak