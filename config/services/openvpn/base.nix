{lib, ...}:
let 
    ports = import ../../network/ports.nix { inherit lib; };
    paths = import ../../paths/openvpn.nix { };
    _ips = import ../../network/ips.nix { inherit lib; };
    ips = ips.services.openvpn;
    domains = import ../../network/domains.nix { inherit lib; };

    base = {
        port = ports.tcp;
        paths = paths;
        domain = domains.openvpn;
        host-ip = ips.host;
        subnet = ips.subnet;
        intern-subnet = ips.intern-subnet;
        subnet-suffix = ips.subnet-suffix;
        proto = "tcp";
        dev = "tun";
        cipher = "AES-256-GCM";
        keepalive = "10 1200";
        topology = "subnet";
        remote-cert-tls = "server";
        client_to_client = true;
        persist_key = true;
        persist_tun = true;
        verb = "3";
        nobind = false; # was true in the original file
        resolv-retry = "infinite";
    };

in base