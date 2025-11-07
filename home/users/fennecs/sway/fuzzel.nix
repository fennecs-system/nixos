{ config, pkgs, lib, ...}: 
let 
  modifier = config.wayland.windowManager.sway.config.modifier;
in
{
  programs.fuzzel.enable = true; 
  wayland.windowManager.sway.config = {
    keybindings = {
      "${modifier}+space" = "exec fuzzel";
    };
  };
}