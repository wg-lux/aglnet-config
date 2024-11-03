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
General sops Intro: https://blog.gitguardian.com/a-comprehensive-guide-to-sops/

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
## Power Management
Using tlp to manage max. charge (set to 80) and reduce cpu frequency when not on charged

Defined in `profiles/shared/power-management.nix`

!! Check if this causes issues with non-laptops

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

## Garbage Collection
```shell
nix-channel --update
nix-env -u --always
rm /nix/var/nix/gcroots/auto/*
nix-collect-garbage -d
```

*Clean old Generations*
```shell
nix-env --list-generations
nix-collect-garbage  --delete-old
nix-collect-garbage  --delete-generations 1 2 3
# recommeneded to sometimes run as sudo to collect additional garbage
sudo nix-collect-garbage -d
# As a separation of concerns - you will need to run this command to clean out boot
sudo /run/current-system/bin/switch-to-configuration boot
```


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

### Sensitive Data HDD
*Requires endoreg-usb-encrypter installed*
run `sudo encrypt-usb`:
move file to `config/hardware`

## Users
### Passwords
- use the script `deployment/scripts/create-user-passwords.sh` to generate passwords and hashes
- move the resulting `nix-user.yaml` file to `secrets/${hostname}/ 
- encrypt it after moving the file (sops -e --in-place $FILEPATH)


## OpenVPN Certificate Authority (CA)
Initialize
```bash
mkdir ~/openvpn-ca
cd ~/openvpn-ca
easyrsa init-pki
```

Use example config
```bash
cd pki
cp vars.example vars
```


Set Variables, e.g.:
```bash
set_var EASYRSA_OPENSSL	"openssl"
set_var EASYRSA_DN	"cn_only"
set_var EASYRSA_KEY_SIZE	2048
set_var EASYRSA_CERT_EXPIRE	825
set_var EASYRSA_CRL_DAYS	360
set_var EASYRSA_PRE_EXPIRY_WINDOW	90
```

Build CA (for this, change back to the `openvpn-ca` directory):
```bash
easyrsa build-ca
```

Generate Secure passphrase (e.g., here https://untroubled.org/pwgen ).
Make Sure the passphrase is secure, e.g.:

Password Length:	20
Bits per character:	6.60
Effective password bits:	131
Total possible combinations:	5,437,943,429,267,472,574,499,737,549,036,572,950,401

### Generate the Diffie-Hellman Parameters
```bash
easyrsa gen-dh
```
-> openvpn-ca/pki/dh.pem

### Generate the TLS-Auth Key (Optional but Recommended)
```bash
openvpn --genkey secret ta.key
```

### Generate a Certificate and Key for the Server

Create the server key and certificate signing request (CSR):
```bash
easyrsa gen-req server nopass
```

Then, sign the CSR with the CA:
```bash
easyrsa sign-req server server
```
The files server.crt and server.key will be generated in the pki/issued and pki/private directories, respectively.


In our setup we use the hostname of 'server-01'.
```bash
easyrsa gen-req agl-server-01 nopass
easyrsa sign-req server server
```
Inline file created:
openvpn-ca/pki/inline/private/agl-server-01.inline

Certificate created at:
openvpn-ca/pki/issued/agl-server-01.crt



### Generate Certificates for Clients
To generate the CSR and sign it:

```bash
easyrsa gen-req client1 nopass
easyrsa sign-req client client1

```

You will need to transfer specific files to the OpenVPN server and clients:
For the OpenVPN Server:

    pki/ca.crt (CA Certificate)
    pki/issued/server.crt (Server Certificate)
    pki/private/server.key (Server Private Key)
    pki/dh.pem (Diffie-Hellman Parameters)
    ta.key (TLS-Auth Key)

For Each Client:

    pki/ca.crt (CA Certificate)
    pki/issued/client1.crt (Client Certificate)
    pki/private/client1.key (Client Private Key)
    ta.key (TLS-Auth Key, if using)



## OpenVPN Configuration files
Dynamically created in `config/services/openvpn`


### Server
See: `deployment/openvpn/aglnet-host.conf`

## SSH
Known hosts are added in the config.
If you want to use SSH to access another client, you have to deploy a suitable identity file

For this we deploy the corresponding identity to ~/.ssh/use ssh-add
(if we need another path we can use ssh-add $PATH)

verify with ssh-add -l

*Important:* When connecting via ssh we need use the correct user for the available key files (USER@HOST), if not specified we use the currently active user

# Testing
## Configuration
Run in ./config/
```bash
nix eval --expr 'import ./main.nix { lib = import <nixpkgs/lib>;}' --impure
```



# Nix Functions
(Chat GPT Content)
Let's break down the expression:

### Full Expression:

```nix
user-configs = lib.genAttrs (map (u: u.name) ssh-users) (name:
  let
    user = builtins.elemAt (filter (u: u.name == name) ssh-users) 0;
  in create-user-config user
);
```

### Explanation of Each Component:

1. **`lib.genAttrs`**:
    - **Purpose**: This is a function from the Nix library (`lib`) that generates an attribute set (similar to a dictionary in other programming languages) from a list of keys. For each key, it runs a function to determine the corresponding value.
    - **Syntax**: 
      ```nix
      lib.genAttrs keys function
      ```
    - **Parameters**:
      - `keys`: A list of strings that will be used as the keys in the resulting attribute set.
      - `function`: A function that takes each key (one at a time) and returns the corresponding value for that key.

2. **`map (u: u.name) ssh-users`**:
    - **Purpose**: This expression generates the `keys` list for `lib.genAttrs`. It uses `map` to extract the `name` attribute from each element in `ssh-users`.
    - **How `map` Works**:
        - The `map` function applies a transformation to each element of a list. Here, it takes each `u` (where `u` is an element of `ssh-users`) and retrieves `u.name`.
        - **Example**: If `ssh-users` is:
          ```nix
          [
            { name = "maintenance-user"; authorized-keys = [ ... ]; }
            { name = "admin-user"; authorized-keys = [ ... ]; }
          ]
          ```
          Then `map (u: u.name) ssh-users` results in:
          ```nix
          [ "maintenance-user" "admin-user" ]
          ```

3. **Function `(name: ...)`**:
    - **Purpose**: This is the function passed as the second argument to `lib.genAttrs`. It is called for each key (which is a username string, like `"maintenance-user"`) and generates the corresponding value that will be placed in the resulting attribute set.
    - **Input**: Each `name` (e.g., `"maintenance-user"`, `"admin-user"`) is processed individually.

4. **The `let` Expression**:
    - **Purpose**: The `let` expression is used to define local variables. In this case, it is defining `user`:
      ```nix
      let
        user = builtins.elemAt (filter (u: u.name == name) ssh-users) 0;
      in create-user-config user
      ```
    - **`builtins.elemAt`**:
        - **Purpose**: This function retrieves an element from a list based on its index. In this case, it is used to get the first element (`index 0`) of the list returned by `filter`.
        - **Example**: If `filter` returns `[ { name = "admin-user"; ... } ]`, then `builtins.elemAt ... 0` will give you `{ name = "admin-user"; ... }`.
    - **`filter (u: u.name == name) ssh-users`**:
        - **Purpose**: `filter` is a function that selects elements from a list based on a condition. Here, it picks the element(s) from `ssh-users` where `u.name` matches the `name` provided by `genAttrs`.
        - **Example**: If `name` is `"maintenance-user"`, then:
          ```nix
          filter (u: u.name == "maintenance-user") ssh-users
          ```
          will return a list containing only the object with `name = "maintenance-user"`.
    - **Why `builtins.elemAt` is Used**:
        - Since `filter` returns a list, and we know there should be only one match, `builtins.elemAt ... 0` retrieves the first (and expected only) element of the list, giving us a single user configuration.

5. **`create-user-config user`**:
    - **Purpose**: The result of the `let` expression is passed to `create-user-config`, which converts the `user` object into the desired configuration format.
    - **Output**: This generates the configuration for a single user, which `genAttrs` then uses to build the final attribute set.

### Putting It All Together:

- **Step-by-Step Process**:
    1. **`map (u: u.name) ssh-users`** creates a list of usernames from `ssh-users` to use as keys.
    2. **`lib.genAttrs`** iterates over this list of usernames, calling the function `(name: ...)` for each username.
    3. Inside the function, **`filter (u: u.name == name) ssh-users`** finds the user object with the matching name.
    4. **`builtins.elemAt`** retrieves this matching user object.
    5. **`create-user-config`** converts this object into a configuration, which `genAttrs` uses as the value associated with the username.

- **Example Output**:
  If `ssh-users` is:
  ```nix
  [
    { name = "maintenance-user"; authorized-keys = [ "key1" ]; }
    { name = "admin-user"; authorized-keys = [ "key2" ]; }
  ]
  ```
  The result of `user-configs` would be:
  ```nix
  {
    maintenance-user = {
      openssh.authorizedKeys.keys = [ "key1" ];
    };
    admin-user = {
      openssh.authorizedKeys.keys = [ "key2" ];
    };
  }
  ``` 

This final attribute set can be used directly in Nix configurations where each key corresponds to a username and each value provides the appropriate SSH configuration.
