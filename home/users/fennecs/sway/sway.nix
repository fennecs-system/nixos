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

      keybindings = {
        "${modifier}+Shift+c" = "reload";
        "${modifier}+Shift+apostrophe" = "kill";
        "${modifier}+l" = "exec screenlock";
        "${modifier}+Shift+f" = "fullscreen";
        "${modifier}+s" = "layout stacking";
        "${modifier}+w" = "layout tabbed";
        "${modifier}+e" = "layout toggle split";
        "${modifier}+Shift+space" = "floating toggle";
        "${modifier}+Shift+q" =
          "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";
        "${modifier}+1" = "workspace number 1";
        "${modifier}+2" = "workspace number 2";
        "${modifier}+3" = "workspace number 3";
        "${modifier}+4" = "workspace number 4";
        "${modifier}+5" = "workspace number 5";
        "${modifier}+6" = "workspace number 6";
        "${modifier}+7" = "workspace number 7";
        "${modifier}+8" = "workspace number 8";
        "${modifier}+9" = "workspace number 9";
        "${modifier}+0" = "workspace number 10";
        "${modifier}+Shift+1" = "move container to workspace number 1";
        "${modifier}+Shift+2" = "move container to workspace number 2";
        "${modifier}+Shift+3" = "move container to workspace number 3";
        "${modifier}+Shift+4" = "move container to workspace number 4";
        "${modifier}+Shift+5" = "move container to workspace number 5";
        "${modifier}+Shift+6" = "move container to workspace number 6";
        "${modifier}+Shift+7" = "move container to workspace number 7";
        "${modifier}+Shift+8" = "move container to workspace number 8";
        "${modifier}+Shift+9" = "move container to workspace number 9";
        "${modifier}+Shift+0" = "move container to workspace number 10";
        "${modifier}+Left" = "focus left";
        "${modifier}+Down" = "focus down";
        "${modifier}+Up" = "focus up";
        "${modifier}+Right" = "focus right";
        "${modifier}+Shift+Left" = "move left";
        "${modifier}+Shift+Down" = "move down";
        "${modifier}+Shift+Up" = "move up";
        "${modifier}+Shift+Right" = "move right";
        "${modifier}+h" = "splith";
        "${modifier}+v" = "splitv";
        "${modifier}+r" = "mode resize";
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
