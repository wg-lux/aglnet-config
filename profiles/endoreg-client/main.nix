{config, pkgs, lib, network-config, is-endoreg-client, ...}:

let 
    custom-imports = if is-endoreg-client then [
        (import ./utils.nix { inherit config pkgs lib network-config; })
        ../shared/video-processing.nix
        ( import ./maintenance-mode.nix { inherit config pkgs lib network-config; })
    ] else [];

in {
    imports = custom-imports;
}
