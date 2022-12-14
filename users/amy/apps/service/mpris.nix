# Mpris settings

{ config, lib, pkgs, ... }:

{
  services.mpris-proxy = {
    enable = true;
  };
}
