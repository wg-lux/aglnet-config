{ ... }:
{
    openvpn = "server-01";
    nginx = "server-01";
    dnsmasq = "server-01";
    keycloak = "server-01";
    postgresql-base = "server-01";
    postgresql-base-backup = "server-02";
    postgresql-base-api = "gpu-client-02";
}