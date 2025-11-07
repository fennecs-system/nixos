{ pkgs, ...}:
let 
  colors = import ./colors.nix;
  accent_color = colors.accent_color;
  bg_color = colors.bg_color;
  text_color = colors.text_color;
  fg_color = colors.fg_color;
  urgent_color = colors.urgent_color;
  placeholder_color = colors.placeholder_color;
in
{
  home.packages = with pkgs; [
    wezterm
  ];

  wayland.windowManager.sway = {
    enable = true;
    
    # use the system sway 
    systemd.enable = true;    
    wrapperFeatures.gtk = true;

    extraOptions = [ "--unsupported-gpu" ];

    # use meta/windows key
    config = rec {
      modifier = "Mod4";
      
      fonts = {
        names = [ "Maple Mono NF" ];
        size = 12.0;
      };

      terminal = "wezterm"; 

      bars = [
        {
          command = "waybar";
        }
      ];

      gaps = {
        smartGaps = true;
        outer = 8;
        inner = 4;
      };

      window = {
        border = 1;
        hideEdgeBorders = "smart";
      };

      # credit to neo theta
      output = {
      "*" = {
        bg = "${./wallpapers/xenia.png} fill";
      };
      };

      colors = {
        background = bg_color; 
        focused = {
          border = accent_color;
          background = bg_color ;
          text = accent_color;
          indicator = accent_color;
          childBorder = accent_color;        
        };
        focusedInactive = {
          border = fg_color;
          background = bg_color;
          text = text_color;
          indicator = fg_color;
          childBorder = fg_color;
        };
        unfocused = {
          border = fg_color;
          background = bg_color;
          text = text_color;
          indicator = fg_color;
          childBorder = fg_color;
        };
        urgent = {                  
          border = urgent_color;
          background = bg_color;
          text = text_color;
          indicator = urgent_color;
          childBorder = urgent_color;
        };
        placeholder = {
          border = placeholder_color;
          background = bg_color;
          text = text_color;
          indicator = placeholder_color;
          childBorder = placeholder_color;
        };
      };
    };
  };
}
