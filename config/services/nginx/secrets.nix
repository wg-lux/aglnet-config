{ lib ? <nixpkgs/lib> , ... }:
let
    base = import ./base.nix { inherit lib; };

    secrets = {

    };

in secrets