{...}:
let

    cert-root = "/etc/endoreg-cert";
    nginx = {
        cert-root = cert-root;

        ssl-certificate = "${cert-root}/__endo-reg_net_chain.pem";
        ssl-certificate-key = "${cert-root}/endo-reg_net.key";
    };

in nginx

    