{ network-config, config, pkgs, lib, ... }:
let
    hostname = config.networking.hostName;
    conf = network-config.services.utils.ssh;

    # port = conf.port; 
    port = conf.port;
    permit-root = conf.permit-root-login;
    password-auth = conf.password-authentication;

    user-configs = conf.user-configs; # List of Attribute sets with user and authorized keys

in
{
    networking.firewall.allowedTCPPorts = [ port ]; # TODO
    services.openssh.enable = true;
    programs.ssh = {
        startAgent = true;
        pubkeyAcceptedKeyTypes = conf.accepted-key-types;
        hostKeyAlgorithms = conf.accepted-key-types;
        # TODO knownHosts.<name> = { ... };
        #  https://search.nixos.org/options?channel=24.05&show=programs.ssh.knownHosts&from=0&size=50&sort=relevance&type=packages&query=programs.ssh

    };

    services.openssh.settings = {
        PermitRootLogin = permit-root;
        PasswordAuthentication = true;# password-auth;
        port = port;
    };

    # Iterate over user conf list and do the following
    # users.users.${user}.openssh.authorizedKeys.keys = authorized keys
    users.users = user-configs;


}


###############
# { config, pkgs, agl-network-config, ... }: 
# let 

#   hostname = config.networking.hostName;
#   ssh-id-ed25519-file-path = agl-network-config.services.ssh.id-ed25519-file-path;
#   ssh-agent-user = agl-network-config.services.ssh.user;
#   secret-path-id_ed25519 = ../secrets + ("/" + "${hostname}/id_ed25519.yaml");

# in
# {
#   #TODO change ssh port to deviate from default
#   environment.systemPackages = [
#     # (import ../scripts/base-ssh-add.nix {inherit config pkgs;})
#   ];

#   # Enable the OpenSSH daemon
#   services.openssh.enable = true;
#   programs.ssh.startAgent = true;

#   # Create identity secret file
#   sops.secrets."identity/id_ed25519" = {
#     sopsFile = secret-path-id_ed25519;
#     path = ssh-id-ed25519-file-path;
#     format = "yaml";
#     owner = config.users.users."${ssh-agent-user}".name;
#     group = config.users.users."${ssh-agent-user}".group;
#     mode = "0400";
#   };

#   # Optional: Configure additional settings
#   services.openssh.settings = {
#     PermitRootLogin = "no";
#     PasswordAuthentication = true;
#     # PasswordAuthentication = false;
#     port = 22;  # You can change the SSH port here
#     # Additional configurations can be added here
#   };

#   # open the firewall port for SSH
#   networking.firewall.allowedTCPPorts = [ 22 ];

# # User configuration,
#   users.users.agl-admin.openssh.authorizedKeys = {
#     keys = [
#       # lux-root
#       "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC/gVfFAeG/9CwqiPOxu5JoY/vx705a77wvGgh687a5d" 
#       # agl-gc-dev
#       "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHwYnbv/tPCcTIPgFbOISXDOiGZGpyUtu6NmtJ+Pg9Dh agl-gpu-client-dev"
#     ];
#   };
