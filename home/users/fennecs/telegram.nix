{
  pkgs,
  inputs,
  config,
  ...
}:
let
  mkNixPak = inputs.nixpak.lib.nixpak {
    inherit (pkgs) lib;
    inherit pkgs;
  };
  
  flatpak.appId = "org.telegram.desktop";

  telegram = mkNixPak {
    config =
      { sloth, ... }:
      {
        app.package = pkgs.telegram-desktop;

        bubblewrap = {
          network = true;

          bind.rw = [
            (sloth.concat' sloth.homeDir "/.local/share/TelegramDesktop")
            (sloth.concat' sloth.homeDir "/Downloads")
          ];

          bind.ro = [
            (sloth.concat' sloth.homeDir "/.config/fontconfig")
            (sloth.concat' sloth.homeDir "/.config/gtk-3.0")
            (sloth.concat' sloth.homeDir "/.config/gtk-4.0")
            "/etc/ssl/certs"
            "/etc/fonts"
            "/etc/localtime"
          ];

          sockets.wayland = true;
          sockets.pipewire = true;
          sockets.pulse = true;
        };

        dbus.enable = true;
        dbus.policies = {
          "org.freedesktop.Notifications" = "talk";
          "org.freedesktop.portal.*" = "talk";
        };
      };
  };
in
{
  home.packages = [ telegram.config.script ];

  xdg.desktopEntries.telegram = {
    name = "Telegram";
    exec = "Telegram %u";
    icon = "telegram";
    terminal = false;
    categories = [
      "Network"
      "InstantMessaging"
    ];
    mimeType = [ "x-scheme-handler/tg" ];
  };
}
