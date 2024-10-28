{...}:
let 
    hostnames = import ./hostnames.nix { };

    identities = {
        ed25519 = { # ed25519 keys
            backup = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC/gVfFAeG/9CwqiPOxu5JoY/vx705a77wvGgh687a5d";
            gpu-client-dev = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHwYnbv/tPCcTIPgFbOISXDOiGZGpyUtu6NmtJ+Pg9Dh agl-gpu-client-dev";
        };

    };

in identities