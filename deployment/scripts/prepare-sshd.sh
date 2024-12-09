#!/bin/bash

# Install OpenSSH server
sudo apt update && sudo apt install -y openssh-server

# Backup the original sshd_config file
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak

# Modify sshd_config to allow root login with password
sudo sed -i 's/^#PermitRootLogin .*/PermitRootLogin yes/' /etc/ssh/sshd_config

# Allow password authentication if it is disabled
sudo sed -i 's/^#PasswordAuthentication .*/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Enable SSH through UFW
sudo ufw allow ssh

