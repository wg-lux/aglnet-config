{ ... }:
let

    paths = import ../../paths/main.nix { };

    sops = {
        default-format = "yaml";
        key-file = paths.sops.key-file;
        generateKey = false;
    };

in sops