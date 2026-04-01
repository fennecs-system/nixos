{ pkgs, inputs, config, lib, ... }:
let
  mkNixPak = inputs.nixpak.lib.nixpak {
    inherit (pkgs) lib;
    inherit pkgs;
  };

  firefox = mkNixPak {
    config = { sloth, ... }: {
      app.package = pkgs.firefox;

      bubblewrap = {
        network = true;

        bind.rw = [
          (sloth.concat' sloth.homeDir "/.mozilla")
          (sloth.concat' sloth.homeDir "/Downloads")
        ];

        bind.ro = [
          (sloth.concat' sloth.homeDir "/.config/fontconfig")
          (sloth.concat' sloth.homeDir "/.config/gtk-3.0")
          (sloth.concat' sloth.homeDir "/.config/gtk-4.0")
          "/etc/ssl/certs"
          "/etc/fonts"
          "/etc/localtime"
          "/dev/yubikey"
          "/dev/dri"
        ];

        sockets.wayland = true;
        sockets.pipewire = true;
        sockets.pulse = true;
      };

      dbus.enable = true;
      dbus.policies = {
        "org.freedesktop.portal.*" = "talk";
        "org.mozilla.firefox.*" = "own";
        "org.mpris.MediaPlayer2.firefox.*" = "own";
      };
    };
  };
in
{
  home.activation.protectMozilla = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    chmod 700 $HOME/.mozilla
  '';

  # Only use programs.firefox for the catppuccin theme injection
  programs.firefox = {
    enable = true;
    package = pkgs.firefox; # real package so HM can find profiles
  };

  catppuccin.firefox = {
    enable = true;
    flavor = "mocha";
    accent = "pink";
    force = true;
  };

  # Sandboxed binary in the path and as desktop entry
  home.packages = [ firefox.config.script ];

  xdg.desktopEntries.firefox = {
    name = "Firefox";
    exec = "firefox %u";
    icon = "firefox";
    terminal = false;
    categories = [ "Network" "WebBrowser" ];
    mimeType = [
      "text/html"
      "text/xml"
      "application/xhtml+xml"
      "application/vnd.mozilla.xul+xml"
      "x-scheme-handler/http"
      "x-scheme-handler/https"
    ];
  };
}