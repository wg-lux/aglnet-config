{config, pkgs, lib, network-config, ...}:

let 
    conf = network-config.services.keycloak;

    hostname = conf.hostname;
    domain = conf.domain;

in {
    

    services.logrotate.checkConfig = false;

    services.keycloak = {
        enable = false;
        initialAdminPassword = conf.initialAdminPassword;
        settings = {
            http-host = conf.http-host;
            http-port = conf.http-port;
            https-port = conf.https-port; 
            proxy = conf.proxy;# none (default), edge, reencrypt, passthrough;  The proxy address forwarding mode if the server is behind a reverse proxy. https://www.keycloak.org/server/reverseproxy for
    #     #     # hostname-strict-backchannel = false;
            hostname = conf.domain; # The public host name of the Keycloak server, used for public URL generation
        };
        database.passwordFile = conf.database.passwordFile;
        sslCertificateKey = conf.sslCertificateKey;
        sslCertificate = conf.sslCertificate; 
    };
}