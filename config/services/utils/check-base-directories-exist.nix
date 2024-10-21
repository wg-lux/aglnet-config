{lib, ...}:
let

    paths = import ../../paths.main.nix { };
    users = import ../../users/main.nix { inherit lib; };

    service-user = users.root.name;
    service-group = users.root.name;
    
    dirlist = [
        paths.hardware.users.nixos-password-directory
    ];

    # List of owners, must have same len as dirlist
    owners = [
        users.root.name;
    ];

    # List of groups, must have same len as dirlist
    groups = [
        users.root.name;
    ];

    # List of permissions, must have same len as dirlist
    permissions = [
        "0700";
    ];

    check-base-directories-exist = {
        dirlist = dirlist;
        owners = owners;
        groups = groups;
        permissions = permissions;
        user = service-user;
        group = service-group;
        script-name = "check-base-directories-exist";
        service-name = "check-base-directories-exist.service";
        wantedBy = [ "multi-user.target" ];
        before = []; #;["openvpn-aglNet-custom-logger.service"];
        service-type = "oneshot";
    };

in check-base-directories-exist