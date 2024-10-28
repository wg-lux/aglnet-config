{ lib ? import <nixpkgs/lib>, ... }:

let
    users = import ../../users/main.nix { inherit lib; };
    identities = import ../../network/identities.nix { inherit lib; };
    ports = import ../../network/ports.nix { inherit lib; };

    # Define the SSH users and corresponding authorized keys
    ssh-users = [
        {
            name = users.maintenance.name;
            authorized-keys = [
                identities.ed25519.backup
                identities.ed25519.gpu-client-dev
            ];
        }
        {
            name = users.admin.name;
            authorized-keys = [
                identities.ed25519.gpu-client-dev
                identities.ed25519."root_agl-gpu-client-02"
            ];
        }
    ];

    # Function to generate user configuration
    create-user-config = user: {
        openssh.authorizedKeys.keys = user.authorized-keys;
    };

    # Generate the user configurations
    user-configs = lib.genAttrs (map (u: u.name) ssh-users) (name:
      let
        user = builtins.elemAt (lib.filter (u: u.name == name) ssh-users) 0;
      in create-user-config user
    );

    ssh = {
        port = ports.ssh.port;
        permit-root-login = "no";
        password-authentication = false; # TODO

        # Assign user configurations properly
        user-configs = user-configs;
        accepted-key-types = [ "ssh-ed25519" "ssh-rsa" ];
    };

    # Define known hosts! #TODO
    # https://search.nixos.org/options?channel=24.05&show=programs.ssh.knownHosts&from=0&size=50&sort=relevance&type=packages&query=programs.ssh

in ssh
