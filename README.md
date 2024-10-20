# aglnet-config
Nix configuration for the agl-network

# Flake Inputs
The flake inputs provide almost all configurations. They are mainly located in 'config/*'

The basic structure is
network-config
- groups
- hardware
- paths
- scripts
- services
- users
- hostnames
- ips

*Dev Tip*
Attributes which may also be interesting for other parts of the system (e.g., paths, ips, binds, ...) should be defined in "low level" parts of the config (i.e., groups/*, paths/*, ...)

# System Security
## In clean state, no ports are opened (see 'profiles/shared/networking')

# Custom Scripts & Services
## Utils
- user-info [bash-only]
- filesystem-readout [service, requires maintenance-group]



# Misc
## Evaluate nix expressions for testing:
Example:
nix eval --expr 'import ./domains.nix { lib = import <nixpkgs/lib>;}'

*run from Working directory of file!*

## Strange decisions
- systemState is part of hardware

## Linux
Kernel Package is defined in profiles/shared/bootloade.nix

## Git User configuration
After system setup, configure your git user with: `git config [--global] user.name $USERNAME` and user.email

## Filesystem
### envfs
https://github.com/mic92/envfs

Declared in flake.nix

A fuse filesystem that dynamically populates contents of /bin and /usr/bin/ so that it contains all executables from the PATH of the requesting process. This allows executing FHS based programs on a non-FHS system. For example, this is useful to execute shebangs on NixOS that assume hard coded locations like /bin or /usr/bin etc.

## WiFi
### Captive portals
- programs.captive-browser.enable 
- defaults to systems wifi interface if available


# Setup Guide
## Getting System speciic Hardware Info
### File System

filesystem-base-uuid = "d7a0d12b-fb94-4795-996c-aac800517ab1";
filesystem-boot-uuid = "1B9C-2748"
swap-uuid = "6de14442-0c67-4342-94e2-e0b47dfb9fa2"

luks-base-uuid = "428e63c6-f7bb-4e32-94af-cea7ad71bc51"
luks-swap-uuid = "e701612f-d046-4505-8ea5-b7069222ae8c"

```nix
fileSystems."/" = { 
    device = "/dev/disk/by-uuid/${filesystem-base-uuid}";
    fsType = "ext4";
};

fileSystems."/boot" =
{ device = "/dev/disk/by-uuid/${filesystem-boot-uuid}"; 
    fsType = "vfat";
};

boot.initrd.luks.devices. = {
    "luks-${luks-base-uuid}".device = "/dev/disk/by-uuid/${luks-base-uuid}";
    "luks-"${luks-swap-uuid}.device = "/dev/disk/by-uuid/${luks-swap-uuid}";
};

  swapDevices =
    [ 
        { device = "/dev/disk/by-uuid/${swap-uuid}"; }
    ];
```
