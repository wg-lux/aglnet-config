{ network-config, ... }:
let 
    conf = network-config.services.identity.sops;

in {
    sops.defaultSopsFormat = conf.default-format;
    sops.age.keyFile = conf.key-file; # Points to pre-provided (at deployment) key file
    sops.age.generateKey = false; # If true and no key file is present, will generate a new key file
}