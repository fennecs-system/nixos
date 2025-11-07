{ config, pkgs, lib, ...}: 
let 
  modifier = config.wayland.windowManager.sway.config.modifier;
in
{
  programs.fuzzel.enable = true; 

  programs.fuzzel.settings.config = {
    dpi-aware = true;
  };

  wayland.windowManager.sway.config = {
    # override 
    keybindings = lib.mkOptionDefault {
      "${modifier}+d" = "exec fuzzel";
    };
  };
}