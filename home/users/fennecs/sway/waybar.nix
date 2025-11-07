{config, pkgs, ...}:
{
  home.packages = with pkgs; [
    helvum
  ];

  programs.waybar.enable = true; 

  programs.waybar.style = ''
    ${builtins.readFile ./waybar.css}
  '';

  programs.waybar.settings = {
      mainBar = {
        layer = "top";
        position = "bottom";
        height = 28;

        tray = {
          spacing = 10;
        };

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