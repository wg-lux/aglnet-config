{ lib, ... }:
let 
    base = import ./base.nix {inherit lib; };
    configurations = import ./configurations.nix {inherit lib; };
    ccd = import ./ccd.nix {inherit lib; };
    users = import ../../users/main.nix { inherit lib; };
    groups = import ../../groups/main.nix { inherit lib; };
    util-functions = import ../../util-functions.nix { inherit lib; };

    removeEtcPrefix = util-functions.removeEtcPrefix;

    paths = base.paths;

    etc-files = {
        client = {
            "${removeEtcPrefix paths.client.conf}" = {
                text = configurations.client;
                user = users.service.name;
                group = groups.service.name;
                mode = base.filemode-base;
            };
        };
        server ={
            "${removeEtcPrefix paths.server.conf}" = {
                text = configurations.server;
                user = users.service.name;
                group = groups.service.name;
                mode = base.filemode-base;
            };
        } // ccd;
    };

    openvpn = {
        etc-files = etc-files;

    } // base;


in openvpn