{lib ? <nixpkgs/lib>, ...}:
let 
    base = import ./base.nix { };
    

    server = ''
        port ${toString base.port}
        proto ${base.proto}
        dev ${base.dev}

        push "dhcp-option DNS ${base.host-ip}"
        push "route ${base.subnet} ${base.intern-subnet}"
        push "route ${base.domain} 255.255.255.255"

        ca ${base.paths.shared.ca}
        tls-auth ${base.paths.shared.ta}

        cert ${base.paths.server.cert}
        key ${base.paths.server.key}
        dh ${base.paths.server.dh-pem}
        
        server ${base.subnet} ${base.intern-subnet}

        client-config-dir ${base.paths.server.ccd}

        cipher ${base.cipher}
        keepalive ${base.keepalive}
        topology ${base.topology}

        client-to-client
        persist-key
        persist-tun
        verb ${base.verb}
    '';

# remote ${base.host-ip} ${toString base.port}
        

    client = ''
        client
        proto ${base.proto}
        dev ${base.dev}
        remote 192.168.179.1 ${toString base.port}

        ca ${base.paths.shared.ca}
        tls-auth ${base.paths.shared.ta}

        cert ${base.paths.client.cert}
        key ${base.paths.client.key}

        cipher ${base.cipher}
        resolv-retry ${base.resolv-retry}
        nobind
        persist-key
        persist-tun
        remote-cert-tls server
        verb ${base.verb}
    '';

    configurations = {
        server = server;
        client = client;
    };

in configurations
