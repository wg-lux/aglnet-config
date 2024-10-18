{config, network-config, ...}@args:

{
    security.polkit.enable = true;
    security.sudo.wheelNeedsPassword = false;


    # import base policies
    # imports = [(
    #     import ../../config/policies/.nix {
    #         inherit network-config;
    #     }
    # )]
}