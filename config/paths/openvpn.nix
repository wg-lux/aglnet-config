{...}: 
let

    certificate-root = "/etc/openvpn-cert";
    openvpn-root = "/etc/openvpn";

    openvpn = {
        certificate-root = certificate-root;
        openvpn-root = openvpn-root;
        
        server = {
            dh-pem = "${certificate-root}/dh.pem";
            cert = "${certificate-root}/server.crt";
            key = "${certificate-root}/server.key";
            ccd = "${openvpn-root}/ccd";
            conf = "${openvpn-root}/aglnet-server.conf";
        };

        client = {
            cert = "${certificate-root}/client.crt";
            key = "${certificate-root}/client.key";
            conf = "${openvpn-root}/aglnet-client.conf";
        };

        shared = {
            ca = "${certificate-root}/ca.crt";
            ta = "${certificate-root}/ta.key";
        };

    };

in openvpn