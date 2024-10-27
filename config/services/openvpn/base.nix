{lib ? <nixpkgs/lib>, ...}:
let 
    _ports = import ../../network/ports.nix { inherit lib; };
    ports = _ports.openvpn;
    paths = import ../../paths/openvpn.nix { };
    _ips = import ../../network/ips.nix { inherit lib; };
    ips = _ips.services.openvpn;
    domains = import ../../network/domains.nix { inherit lib; };
    service-users = import ../../service-users.nix { inherit lib; };
    user = service-users.openvpn.user.name;
    group = service-users.openvpn.group.name;

    base = {
        port = ports.udp;
        paths = paths;
        domain = domains.openvpn;
        host-ip = ips.host;
        hostname = ips.hostname;
        subnet = ips.subnet;
        filemode-base = "0600";
        filemode-secret = "0400";
        intern-subnet = ips.intern-subnet;
        subnet-suffix = ips.subnet-suffix;
        user = user;
        group = group;
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