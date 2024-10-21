{ config, lib, pkgs, network-config, ... }:

let
    dirs = network-config.services.utils.base-directories;

    # Map over the list of directory attributes to generate tmpfiles rules
    tmpfilesRules = lib.concatMap (dir:
      let
        path = dir.path;
        owner = dir.owner;
        group = dir.group;
        permissions = dir.permissions;
      in [
        "d ${path} ${permissions} ${owner} ${group} -"
      ]) dirs;

in
{
  # Define the tmpfiles rules to manage directories
  systemd.tmpfiles.rules = tmpfilesRules;
}
