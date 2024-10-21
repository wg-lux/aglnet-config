{...}:
let

    users = import ../../users/main.nix {};
    base-user-name = users.users.setup.name;

    identity = {
        sops = import ./sops.nix { };
    };

in identity