{...}:
let
    nginx = {
        ssl-certificate = "/etc/endoreg-cert/__endo-reg_net_chain.pem";
        ssl-certificate-key = "/etc/endoreg-cert/endo-reg-net-lower-decrypted.key";
    };

in nginx

    