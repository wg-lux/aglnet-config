{pkgs, config, lib, ...}@inputs:
let

in {
  programs.nix-ld.dev = {
    enable = true;
    libraries = with pkgs; [
        stdenv.cc.cc
        zlib
        fuse3
        icu
        nss
        openssl
        curl
        expat
        libGLU
        libGL
        git
        gitRepo
        gnupg
        autoconf
        procps
        gnumake
        util-linux
        m4
        gperf
        unzip
        cudatoolkit
        linuxPackages.nvidia_x11
        xorg.libXi
        xorg.libXmu
        freeglut
        xorg.libXext
        xorg.libX11
        xorg.libXv
        xorg.libXrandr
        ncurses5
        stdenv.cc
        binutils
        pkgs.autoAddDriverRunpath
        cudaPackages.cuda_nvcc
        cudaPackages.nccl
        cudaPackages.cudnn
        cudaPackages.libnpp
        cudaPackages.cutensor
        cudaPackages.libcufft
        cudaPackages.libcurand
        cudaPackages.libcublas
    ];
  };
}