{config, pkgs, lib, network-config, ...}:

let 

in {
    
services.keycloak = {
        enable = true;
        initialAdminPassword = "changeme";
        settings = {
            http-host = "127.0.0.1"; #
            http-port = 8080;
            https-port = 8443; 
            proxy = "edge"; # none (default), edge, reencrypt, passthrough;  The proxy address forwarding mode if the server is behind a reverse proxy. https://www.keycloak.org/server/reverseproxy for
        #     # hostname-strict-backchannel = false;
            hostname = "keycloak.endo-reg.net"; # The public host name of the Keycloak server, used for public URL generation
        };
        sslCertificateKey = "/home/agl-admin/endoreg-cert/endo-reg-net-lower-decrypted.key" ; # The path to a PEM formatted private key to use for TLS/SSL connections
        sslCertificate = "/home/agl-admin/endoreg-cert/__endo-reg_net_chain.pem" ; # The path to a PEM formatted certificate to use for TLS/SSL connections
        database = {
            type = "postgresql"; # one of "mysql", "mariadb", "postgresql"
            username = "keycloak";
            useSSL = false; 
            port = 5432; # default is default port for database.type
            passwordFile = "/home/agl-admin/.config/keycloak-pwd"; # path to pwd file
            name = "keycloak";
            host = "172.16.255.4"; # default is localhost
        #     # caCert = path; # path to ca cert file
        };
    };
}