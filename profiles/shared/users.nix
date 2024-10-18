{ ... }@args:

let
  hostname = config.networking.hostName;

in { 
    users.user.setup-user = {
        isNormalUser = true;
        extraGroups = ["networkManager" "wheel" ]
    };
}