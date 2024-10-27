{ lib, ... }:

let 
    base = import ./base.nix { inherit lib; };
    _ips = import ../../network/ips.nix { inherit lib; };
    ips = _ips.services.openvpn;
    clients = _ips.clients;
    hostnames = import ../../hostnames.nix { };
    util-functions = import ../../util-functions.nix { inherit lib; };
    removeEtcPrefix = util-functions.removeEtcPrefix;


    ccd = lib.attrsets.listToAttrs (lib.attrsets.mapAttrsToList (name: hostname: {
    name = "${removeEtcPrefix base.paths.server.ccd}/${hostname}";
    value = {
        text = "ifconfig-push ${clients.${name}} ${ips.intern-subnet}";
        user = base.user;
        group = base.group;
        mode = base.filemode-base;
    };
    }) hostnames);

in ccd
