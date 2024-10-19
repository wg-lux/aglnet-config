{ config, ... }@args:

let
  hostname = config.networking.hostName;

in { 
    users.users.setup-user = {
        isNormalUser = true;
        extraGroups = ["networkManager" "wheel" ];
    };
}