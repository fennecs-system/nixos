{ pkgs, inputs, config, ... }:
let
  mkNixPak = inputs.nixpak.lib.nixpak {
    inherit (pkgs) lib;
    inherit pkgs;
  };

  telegram = mkNixPak {
    config = { sloth, ... }: {
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
        ];

        sockets.wayland = true;
        sockets.pipewire = true;
        sockets.pulse = true;
        sockets.bus = true;
      };
    };
  };
in
{
  home.packages = [ telegram.pkg ];
}