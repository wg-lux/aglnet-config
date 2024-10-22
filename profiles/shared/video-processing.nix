{ config, lib, pkgs, ... }:

{
    environment.systemPackages = with pkgs; [
        ffmpeg_7
    ];
}


