{...}:
let 
    hostnames = import ./hostnames.nix { };

    identities = {
        ed25519 = { # ed25519 keys
            backup = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC/gVfFAeG/9CwqiPOxu5JoY/vx705a77wvGgh687a5d";
            gpu-client-dev = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHwYnbv/tPCcTIPgFbOISXDOiGZGpyUtu6NmtJ+Pg9Dh agl-gpu-client-dev";
            "root_agl-gpu-client-02" = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKsXz4/2Li9jIaZ9EQvLt+34dj30/cf//h9HXEswaP5K root@agl-gpu-client-02";
        };

    };

in identities