# NOT A SHELL SCRIPT

# Generate OpenVPN client certificates
# This script is not a shell script, but a series of commands to be run in a shell

# Create clients:
## agl-server-02 to agl-server-06
## agl-gpu-client-dev 6K~ï¿½FAP$v_ZGCIW<*_KP
## agl-gpu-client-01 to agl-gpu-client-06

easyrsa gen-req agl-server-02 nopass
easyrsa sign-req client agl-server-02

easyrsa gen-req agl-server-03 nopass
easyrsa sign-req client agl-server-03

easyrsa gen-req agl-server-04 nopass
easyrsa sign-req client agl-server-04

easyrsa gen-req agl-server-05 nopass
easyrsa sign-req client agl-server-05

easyrsa gen-req agl-server-06 nopass
easyrsa sign-req client agl-server-06

easyrsa gen-req agl-gpu-client-dev nopass
easyrsa sign-req client agl-gpu-client-dev

easyrsa gen-req agl-gpu-client-01 nopass
easyrsa sign-req client agl-gpu-client-01

easyrsa gen-req agl-gpu-client-02 nopass
easyrsa sign-req client agl-gpu-client-02

easyrsa gen-req agl-gpu-client-03 nopass
easyrsa sign-req client agl-gpu-client-03

easyrsa gen-req agl-gpu-client-04 nopass
easyrsa sign-req client agl-gpu-client-04

easyrsa gen-req agl-gpu-client-05 nopass
easyrsa sign-req client agl-gpu-client-05

easyrsa gen-req agl-gpu-client-06 nopass
easyrsa sign-req client agl-gpu-client-06



