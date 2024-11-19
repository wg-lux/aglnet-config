{ lib ? import <nixpkgs/lib>, ...}:

let 
  databases = {
    base = import ./base-db.nix { inherit lib; };
    base-backup = import ./base-backup-db.nix { inherit lib; };
    base-api = import ./base-db-api.nix { inherit lib; };
  };

in databases