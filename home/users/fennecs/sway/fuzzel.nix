{ config, pkgs, lib, ...}: 
let 
  modifier = config.wayland.windowManager.sway.config.modifier;
  colors = import ./colors.nix;
  bg_color = colors.bg_color;
  text_color = colors.text_color;
  selection_color = colors.urgent_color;
in
{
  programs.fuzzel.enable = true; 

  programs.fuzzel.settings.config = {
    dpi-aware = true;
    font = "'size=36'";
    colors = "
      background=${bg_color};
      selection=${selection_color};
      text=${text_color};
    ";
  };

  wayland.windowManager.sway.config = {
    # override 
    keybindings = lib.mkOptionDefault {
      "${modifier}+d" = "exec fuzzel";
    };
  };
}