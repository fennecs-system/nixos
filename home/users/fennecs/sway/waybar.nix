{config, pkgs, ...}:
{
  programs.waybar.enable = true; 

  programs.waybar.settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 26;

        modules-left = ["sway/workspaces" "sway/mode"];
        modules-right = ["tray" "wireplumber" "clock"];
      };
  };
}