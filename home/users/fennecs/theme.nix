{ config, ... }:

{
  catppuccin = {
    enable = true;
    flavor = "mocha";
    accent = "pink";

    vscode = {
      profiles."Default".enable = true;
      profiles."Default".flavor = "mocha";
      profiles."Default".accent = "pink";
    };

    waybar.enable = true;
    waybar.flavor = "mocha";

    sway.enable = true;
    sway.flavor = "mocha";

    wezterm.enable = true;
    wezterm.flavor = "mocha";
    wezterm.apply = true;

    fish.enable = true;
    fish.flavor = "mocha";

    vesktop.enable = true;
    vesktop.flavor = "mocha";
    vesktop.accent = "pink";

    # firefox.enable = true;
    # firefox.flavor = "mocha";
    # firefox.accent = "pink";
    # firefox.force = true;
  };

  gtk = {
    enable = true;
    gtk4.theme = null;

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
      gtk-decoration-layout = ":";
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
      gtk-decoration-layout = ":";
    };
  };
}
