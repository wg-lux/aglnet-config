{ lib ? <nixpkgs/lib>, ... }:
let 
    users = import ./users/main.nix { inherit lib; };
    groups = import ./groups/main.nix { inherit lib; };

    service-users = {
        openvpn = {
            user = users.openvpn;
            group = groups.openvpn;
        };
        nginx = {
            user = users.nginx;
            group = groups.nginx;
        };
        keycloak = {
            user = users.service-user;
            group = groups.service-user;
        };
    };

in service-users