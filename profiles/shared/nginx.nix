{ config, pkgs, lib, network-config, ... }:

let 



in {

    services.nginx = {
        enable = true;
        recommendedGzipSettings = true;
        recommendedOptimisation = true;
        recommendedProxySettings = true;
        recommendedTlsSettings = true; 

        appendHttpConfig = conf.appendHttpConfig;

        virtualHosts = conf.virtualHosts;

    };

};


##### FOR REFERENCE 
# "drive-intern.endo-reg.net" = {
    # forceSSL = true;
    # sslCertificate = sslCertificatePath;
    # sslCertificateKey = sslCertificateKeyPath;
    # locations."/" = {
    #     proxyPass = "https://${agl-network-config.services.synology-drive.ip}:${toString agl-network-config.services.synology-drive.port}";
    #     extraConfig = all-extraConfig +  intern-endoreg-net-extraConfig;
    #     proxyWebsockets = true;
    # };
    # extraConfig = ''
    #     client_max_body_size 100000M;
    # '';
# };