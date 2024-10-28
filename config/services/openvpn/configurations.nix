{lib ? <nixpkgs/lib>, ...}:
let 
    base = import ./base.nix { };
    

    server = ''
        port ${toString base.port}
        proto ${base.proto}
        dev ${base.dev}
        server ${base.subnet} ${base.intern-subnet} # -> 172.16.255.0/24
        persist-key
        persist-tun
        keepalive ${base.keepalive}
        cipher ${base.cipher}
        push "route ${base.subnet} ${base.intern-subnet}" # makes subnet available
        verb ${base.verb}

        ca ${base.paths.shared.ca}
        tls-auth ${base.paths.shared.ta} 0
        cert ${base.paths.server.cert}
        key ${base.paths.server.key}
        dh ${base.paths.server.dh-pem}
        
        client-config-dir ${base.paths.server.ccd}
        topology ${base.topology}

        client-to-client
    '';

# remote ${base.host-ip} ${toString base.port}
        

    client = ''
        client
        proto ${base.proto}
        dev ${base.dev}
        remote ${base.domain} ${toString base.port}

        resolv-retry ${base.resolv-retry}
        nobind
        persist-key
        persist-tun

        ca ${base.paths.shared.ca}
        tls-auth ${base.paths.shared.ta} 1
        cert ${base.paths.client.cert}
        key ${base.paths.client.key}
        cipher ${base.cipher}

        route-nopull
        route 172.16.255.0 255.255.255.0

        remote-cert-tls server
        verb ${base.verb}
    '';

    configurations = {
        server = server;
        client = client;
    };

in configurations
