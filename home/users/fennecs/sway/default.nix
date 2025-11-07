{ config, pkgs, ... }:

{
  wayland.windowManager.sway = {
    enable = true; 
    # system package
    package = null;
    systemd.enable = true;
    wrapperFeatures.gtk = true;
    
    # use meta/windows key
    config = rec {
    modifier = "Mod4";
   
    gaps = {
      smartGaps = true;
      outer = 8;
      inner = 4;
    };

    window = {
      border = 1;
      hideEdgeBorders = "smart";
    };
    };
  };

  home.packages = with pkgs; [
    waybar 
    wofi  
    nautilus 
    wezterm 
    dconf 
    dconf-editor
  ];

}