{...}: 
let

    certificate-root = "/etc/openvpn-cert";
    openvpn-root = "/etc/openvpn";

    filenames = {
        dh-pem = "dh.pem";
        cert-server = "cert.crt";
        key-server = "cert.key";
        cert-client = "cert.crt";
        key-client = "cert.key";
        ca = "ca.crt";
        ta = "ta.key";
        conf-server = "aglnet-server.conf";
        conf-client = "aglnet-client.conf";
    };

    # Create function to dynamically return sopsfile paths
    # expects hostname and returns sopsfile path, e.g. 
    # ../../secrets/"${hostname}"/"${filename}"
    # getSopsFile = 


    openvpn = {
        certificate-root = certificate-root;
        openvpn-root = openvpn-root;
        filenames = filenames;
        
        server = {
            dh-pem = "${certificate-root}/${filenames.dh-pem}";
            cert = "${certificate-root}/${filenames.cert-server}";
            key = "${certificate-root}/${filenames.key-server}";
            ccd = "${openvpn-root}/ccd";
            conf = "${openvpn-root}/${filenames.conf-server}";
        };

        client = {
            cert = "${certificate-root}/${filenames.cert-client}";
            key = "${certificate-root}/${filenames.key-client}";
            conf = "${openvpn-root}/${filenames.conf-client}";
        };

        shared = {
            ca = "${certificate-root}/${filenames.ca}";
            ta = "${certificate-root}/${filenames.ta}";
        };

        
    };

in openvpn