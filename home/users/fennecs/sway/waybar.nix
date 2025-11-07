{config, pkgs, ...}:
{
  home.packages = with pkgs; [
    helvum
  ];

  programs.waybar.enable = true; 

  programs.waybar.settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 32;

        modules-left = ["sway/workspaces" "sway/mode"];
        modules-right = ["tray" "wireplumber" "clock"];

        wireplumber = {
          format = "{icon} {volume}";
          format-muted = " ";
          on-click = "helvum";
        };
      
      };
  };
}