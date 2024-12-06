{config, pkgs, lib, network-config,
is-endoreg-client?false,
dual-gpu?false,...
}:

let
  # if is-endoreg-client then we import this module as gpu moduel:

        # ( import ../shared/nvidia_base.nix {inherit config pkgs network-config; })

  # if dual gpu is true then we import this module as gpu module:
        # ( import ../shared/nvidia_dual_gpu.nix {inherit config pkgs network-config; })

  # else we dont import any gpu module

  dual-gpu-modules = if dual-gpu then [
    ( import ./nvidia-dual-gpu.nix {inherit config pkgs network-config; })
  ] else [];

  endoreg-client-gpu-modules = if is-endoreg-client then [
    ( import ./nvidia-base.nix {inherit config pkgs network-config; })
  ] else [];

  custom-modules = [] ++ dual-gpu-modules ++ endoreg-client-gpu-modules;


in {
  imports = custom-modules;
}