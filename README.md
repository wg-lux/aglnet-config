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
In clean state, no ports are opened (see 'profiles/shared/networking')

## Users & Permissions
- `users.mutableUsers = false;` resets groups / ... on boot


## Secret Management with sops-nix
The main sops config is located at `aglnet-config/.sops.yaml`

Here the public keys of different sops clients and their access are managed

## Initial user Passwords
- Initially, randomly generated passwords are used for users
- Passwords are provided as hashed values by sops-nix
    - `profiles/shared/users.nix` calls `profiles/shared/user-passwords.nix`
- create hashed passwords like this `mkpasswd -s`

# Supply Files / Directories
## Base Directories
- Base dirs are defined in `aglnet-config/config/services/utils/base-directories`
- Base dirs are managed using tmpfiles (is not only for temporary files), see: 



# Custom Scripts & Services
## Utils
- user-info [bash-only]
- filesystem-readout [service, requires maintenance-group]

*EndoReg Client:*
- `systemctl start mount-dropoff`
- `systemctl start umount-dropoff`
- `systemctl start mount-processing`
- `systemctl start umount-processing`
- `systemctl start mount-processed`
- `systemctl start umount-processed`
- `cat /var/log/mount-dropoff.log`
- `cat /var/log/mount-processing.log`
- `cat /var/log/mount-processed.log`

## Logging
- `scripts/endoreg-client/log-sensitive-partitions.nix`
    - Logs State of sensitive data hdd, writes jsons to custom dir
    - Custom dir currently is `/etc/sensitive-partitions-log`
    - Options defined in `config/scripts/endoreg-sensitive-mounting.nix`

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
Use script to help: 'sudo bash ./deployment/scripts/filesystem-readout.sh'

1. Identify LUKS UUID and corresponding mapping target:
e.g., 
```json
{
    "/dev/mapper/luks-428e63c6-f7bb-4e32-94af-cea7ad71bc51 (UUID)": "d7a0d12b-fb94-4795-996c-aac800517ab1",
    "/dev/mapper/luks-428e63c6-f7bb-4e32-94af-cea7ad71bc51 (FSTYPE)": "ext4",
}

```
This tells us the following attributes:
```json
{
    "/dev/mapper/luks-$UUID_OF_ENCRYPTED_PARTITION (UUID)": "MAPPING_TARGET",
    "/dev/mapper/luks-428e63c6-f7bb-4e32-94af-cea7ad71bc51 (FSTYPE)": "ext4",
}
```

Even though legacy variables are named strangely, this leads us to:
luks-hdd-intern-uuid = UUID_OF_ENCRYPTED_PARTITION
file-system-base-uuid = MAPPING_TARGET

Same applies for swap.
Lastly, "file-system-boot-uuid" refers to the boot partition.

### Manually deploy the sops age key
1. deploy `keys.txt` file to `~/.config/sops/age/keys.txt` ant `/etc/sops-age-keys.txt`
    1. Make sure dirs exist: ``
2. Set permissions
    1. sudo chown $USER ~/.config/sops/age/keys.txt
    2. sudo chmod 600 ~/.config/sops/age/keys.txt

### Decryption USB Stick
Run `deployment/scripts/create-boot-keyfile.sh`.
You need root privileges, the hostname, and the existing decryption passphrase

Copy the resulting $HOSTNAME-usb-key.nix file to `config/hardware`

Then, update the nix config and reboot the system. During boot, the system should look for the stick and decrypt the system if available. Else, we fallback to passphrase

### User Passwords
- use the script `deployment/scripts/create-user-passwords.sh` to generate passwords and hashes
- move the resulting `nix-user.yaml` file to `secrets/${hostname}/ 
- encrypt it after moving the file (sops -e --in-place $FILEPATH)

### Sensitive Data HDD
*Requires endoreg-usb-encrypter installed*
run `sudo encrypt-usb`:
- 

# Testing
## Configuration
Run in ./config/
```bash
nix eval --expr 'import ./main.nix { lib = import <nixpkgs/lib>;}' --impure
```