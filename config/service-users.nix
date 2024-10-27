{ lib ? <nixpkgs/lib>, ... }:
let 
    users = import ./users/main.nix { inherit lib; };
    groups = import ./groups/main.nix { inherit lib; };

    service-users = {
        openvpn = {
            user = users.openvpn;
            group = groups.openvpn;
        };
    };

in service-users