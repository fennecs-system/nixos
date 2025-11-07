{ config, pkgs, ... }:
{
  imports = [
    ./sway.nix
    ./waybar.nix
  ];

  home.packages = with pkgs; [
    wofi
    nautilus
    dconf
    dconf-editor
  ];

}
