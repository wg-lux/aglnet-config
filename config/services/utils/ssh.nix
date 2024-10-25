{ lib, ...}:
let
    users = import ../../users/main.nix { inherit lib; };
    identities = import ../../network/identities.nix { inherit lib; };
    ports = import ../../network/ports.nix { inherit lib; };

    ssh-users = [
        users.maintenance.name
        users.admin.name
    ];

    authorized-keys = [
        identities.ssh.backup
        identities.ssh.gpu-client-dev
    ];

    # Add function create user configs from user ssh-users list
    create-user-config = user: {
        user = user;
        authorized-keys = authorized-keys;
    };

    # Iterate over list of ssh-users and create list of user-configs
    _user-configs = map create-user-config ssh-users;

    user-configs = lib.listToAttrs (map (userConfig: {
      name = userConfig.user;
      value = {
        openssh.authorizedKeys.keys = userConfig."authorized-keys";
      };
    }) _user-configs);

    ssh = {
        port = ports.ssh.port;
        permit-root-login = "no";
        password-authentication = true; # TODO

        user-configs = user-configs;
        accepted-key-types = [ "ssh-ed25519" "ssh-rsa" ];
    };

    # define known hosts! #TODO
    # https://search.nixos.org/options?channel=24.05&show=programs.ssh.knownHosts&from=0&size=50&sort=relevance&type=packages&query=programs.ssh


in ssh