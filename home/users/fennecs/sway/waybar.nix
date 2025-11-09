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
        position = "top";
        height = 0;

        margin-top = 12;
        margin-bottom = 0;
        margin-right = 12;
        margin-left = 12;

        tray = {
          spacing = 10;
        };

        modules-left = ["sway/workspaces" "sway/mode"];
        modules-right = ["tray" "wireplumber" "network"];
        modules-center = ["clock"];

        clock = {
          interval = 1;
          format = "{:%Y-%m-%d %H:%M:%S}";
          tooltip = false; 
        };

        wireplumber = {
          format = "{icon} {volume}%";
          format-muted = " ";
          on-click = "helvum";
        };
      
      };
  };
}