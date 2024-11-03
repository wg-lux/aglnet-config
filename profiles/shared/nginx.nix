{ config, pkgs, lib, network-config, ... }:

let 
    conf = network-config.services.nginx;



in {

    # open ports:
    networking.firewall.allowedTCPPorts = [ 
        80 443 conf.port
     ];

    services.nginx = {
        enable = true;
        user = conf.user;
        group = conf.group;
        recommendedGzipSettings = conf.recommendedGzipSettings;
        recommendedOptimisation = conf.recommendedOptimisation;
        recommendedProxySettings = conf.recommendedProxySettings;
        recommendedTlsSettings = conf.recommendedTlsSettings;

        appendHttpConfig = conf.appendHttpConfig;
        # virtualHosts = conf.virtualHosts;
    };

}


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