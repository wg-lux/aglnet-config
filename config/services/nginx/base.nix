{ lib ? <nixpkgs/lib> , ... }:
let

    service-users = import ../../service-users.nix { inherit lib; };
    service-hosts = import ../../service-hosts.nix { inherit lib; };
    paths = import ../../paths/nginx.nix { }; 

    network = import ../../network/main.nix { inherit lib; };
    ips = network.ips;

    hostnames = import ../../hostnames.nix { inherit lib; };
    raw-host = service-hosts.nginx;
    hostname = hostnames."${raw-host}";

    proxy_headers_hash_bucket_size = 128;

    base = {
        hostname = hostname;
        raw-host = raw-host;
        recommendedGzipSettings = true;
        recommendedOptimisation = true;
        recommendedProxySettings = true;
        recommendedTlsSettings = true;
        
        host-ip = network.ips.clients."${raw-host}";
        port = network.ports.nginx.aglnet;
        user = service-users.nginx.user.name;
        group = service-users.nginx.user.config.group;
        filemode-secret = "0400";
        paths = paths;


        all-extraConfig = ''
            proxy_headers_hash_bucket_size ${toString proxy_headers_hash_bucket_size};
        '';
        
        intern-endoreg-net-extraConfig = ''
            allow ${ips.vpn-subnet};
            deny all;
        '';

        appendHttpConfig = ''
            proxy_set_header Host $host;
            proxy_set_header X-Forwarded-Host $host;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_ssl_server_name on;
            proxy_pass_header Authorization;
        '';
        
    };


in base

##############4



    

    # conf = {  
    #     virtualHosts = {
    #         "keycloak.endo-reg.net" = {
    #             forceSSL = true;
    #             sslCertificate = sslCertificatePath;
    #             sslCertificateKey = sslCertificateKeyPath;
    #             locations."/" = {
    #                 proxyPass = "http://127.0.0.1:8080"; # TODO FIXME
    #                 extraConfig = all-extraConfig;
    #             };
    #         };

    #         "home.endo-reg.net" = {
    #             forceSSL = true;
    #             sslCertificate = sslCertificatePath;
    #             sslCertificateKey = sslCertificateKeyPath;
    #             locations."/" = {
    #                 proxyPass = "http://${agl-network-config.services.agl-home-django.ip}:${toString agl-network-config.services.agl-home-django.port}";
    #                 extraConfig = all-extraConfig;
    #             };
    #         };
        
    #     };
    # };