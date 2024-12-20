{lib, ...}:
let

    # nix eval --expr 'import ./ips.nix { lib = import <nixpkgs/lib>;}'

    vpn-ip-prefix = "172.16.255";
    vpn-subnet = "${vpn-ip-prefix}.0/24";


    localhost = "localhost";
    localhost-ip = "127.0.0.1";

    hostnames = import ../hostnames.nix {};
    service-hosts = import ../service-hosts.nix {}; # {SERVICE_NAME = HOSTNAME} !! e.g. server-01 , NOT HOSTNAMES !!


    # Function to map hostnames to IPs
    pairHostnameToIp = name: value:
        { hostname = value; ip = lib.getAttr name clients; };

    # Map over the hostnames and pair each with its corresponding IP from the clients set
    ips-by-hostname = lib.mapAttrs pairHostnameToIp hostnames;

    clients = {
        server-01 = "${vpn-ip-prefix}.1";
        server-02 = "${vpn-ip-prefix}.2";
        server-03 = "${vpn-ip-prefix}.3";
        server-04 = "${vpn-ip-prefix}.4";
        gpu-client-dev = "${vpn-ip-prefix}.140";
        gpu-client-01 = "${vpn-ip-prefix}.141";
        gpu-client-02 = "${vpn-ip-prefix}.142";
        gpu-client-03 = "${vpn-ip-prefix}.143";
        gpu-client-04 = "${vpn-ip-prefix}.144";
        gpu-client-05 = "${vpn-ip-prefix}.145";
        gpu-client-06 = "${vpn-ip-prefix}.146";
        gpu-client-07 = "${vpn-ip-prefix}.147";
        gpu-client-08 = "${vpn-ip-prefix}.148";
        gpu-client-09 = "${vpn-ip-prefix}.149";
        gpu-server-01 = "${vpn-ip-prefix}.230";
    };

    ips = {
        vpn-ip-prefix = "172.16.255";
        vpn-subnet = "${vpn-ip-prefix}.0/24";
        clients = clients;
        # by-hostname = ips-by-hostname; # BROKEN
        services = {
            openvpn = {
                host = clients."${service-hosts.openvpn}";
                hostname = hostnames."${service-hosts.openvpn}";
                subnet = "${vpn-ip-prefix}.0";
                subnet-suffix = "32";
                intern-subnet = "255.255.255.0";
            };
            main-nginx = {
                host = clients."${service-hosts.nginx}";
            };

            keycloak = {
                host = clients."${service-hosts.keycloak}";
            };
        };
    };



in ips