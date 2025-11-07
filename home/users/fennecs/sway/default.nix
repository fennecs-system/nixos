{ config, pkgs, ... }:
{
  imports = [
    ./sway.nix
    ./waybar.nix
    ./fuzzel.nix # launcher
  ];

  home.packages = with pkgs; [
    nautilus
    dconf
    dconf-editor
  ];

}
