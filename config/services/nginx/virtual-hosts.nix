{ lib ? <nixpkgs/lib> , ... }:
let
    base = import ./base.nix { inherit lib; };

    virtual-hosts = {

    };

in virtual-hosts