{
  config,
  pkgs,
  lib,
  ...
}:
let
  strip = color: (builtins.replaceStrings [ "#" ] [ "" ] color) + "ff";
  modifier = config.wayland.windowManager.sway.config.modifier;
  colors = import ./colors.nix;
  bg_color = colors.bg_color;
  text_color = colors.text_color;
  selection_color = colors.urgent_color;
in
{
  programs.fuzzel.enable = true;

  programs.fuzzel.settings = {
    main = {
      dpi-aware = "yes";
      font = "MapleMono:style=mono:weight=normal:size=36";
      anchor = "top";
      y-margin = 48;
    };

    colors = {
      background = strip bg_color;
      selection = strip selection_color;
      text = strip text_color;
    };
  };

  wayland.windowManager.sway.config = {
    # override
    keybindings = lib.mkOptionDefault {
      "${modifier}+d" = "exec fuzzel";
    };
  };
}
