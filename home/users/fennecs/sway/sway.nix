{ pkgs, lib, ... }:
let
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

  programs.wezterm = {
    enable = true;
  };
  
  home.packages = with pkgs; [
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
      background = "$base";
      focused = {
        border = "$mauve";
        background = "$base";
        text = "$text";
        indicator = "$mauve";
        childBorder = "$mauve";
      };
      focusedInactive = {
        border = "$surface0";
        background = "$base";
        text = "$text";
        indicator = "$surface0";
        childBorder = "$surface0";
      };
      unfocused = {
        border = "$surface0";
        background = "$base";
        text = "$subtext0";
        indicator = "$surface0";
        childBorder = "$surface0";
      };
      urgent = {
        border = "$peach";
        background = "$base";
        text = "$text";
        indicator = "$peach";
        childBorder = "$peach";
      };
      placeholder = {
        border = "$overlay0";
        background = "$base";
        text = "$subtext0";
        indicator = "$overlay0";
        childBorder = "$overlay0";
      };
      };
    };
  };
}
