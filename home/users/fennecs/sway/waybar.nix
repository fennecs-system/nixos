{config, pkgs, ...}:
{
  programs.waybar.enable = true; 


  programs.waybar.settings = {
      mainBar = {
        layer = "top";
        position = "top";
      };
  };
}