{ pkgs, lib, ... }:
let
  colors = import ./colors.nix;
  accent_color = colors.accent_color;
  bg_color = colors.bg_color;
  text_color = colors.text_color;
  fg_color = colors.fg_color;
  urgent_color = colors.urgent_color;
  placeholder_color = colors.placeholder_color;

  switcher = pkgs.writeShellScriptBin "switcher" ''
    #!/bin/bash
    regular_windows=$(swaymsg -t get_tree | jq -r '.nodes[1].nodes[].nodes[] | .. | (.id|tostring) + " " + .name?' | grep -e "[0-9]* ."  )
    floating_windows=$(swaymsg -t get_tree | jq '.nodes[1].nodes[].floating_nodes[] | (.id|tostring) + " " + .name?'| grep -e "[0-9]* ." | tr -d '"')
    enter=$'\n'
    if [[ $regular_windows && $floating_windows ]]; then
      all_windows="$regular_windows$enter$floating_windows"
    elif [[ $regular_windows ]]; then
      all_windows=$regular_windows
    else
      all_windows=$floating_windows
    fi
    selected=$(echo "$all_windows" | fuzzel --dmenu | awk '{print $1}')
    swaymsg [con_id="$selected"] focus
  '';
in
{
  home.packages = with pkgs; [
    wezterm
    jq
  ];

  wayland.windowManager.sway = {
    enable = true;

    # use the system sway
    systemd.enable = true;
    package = null;
    wrapperFeatures.gtk = true;
    extraOptions = [ "--unsupported-gpu" ];
    # use meta/windows key

    # swayfx config
    extraConfig = ''
      corner_radius 8

      layer_effects "waybar" corner_radius 8

      default_border pixel 1px
      default_floating_border pixel 1px    
    '';

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
        smartGaps = false;
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

      keybindings = lib.mkOptionDefault {
        "${modifier}+g" = "exec ${switcher}/bin/switcher";
      };

      colors = {
        background = bg_color;
        focused = {
          border = accent_color;
          background = bg_color;
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
