# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration-am5.nix
  ];

  nixpkgs.config.allowUnfree = true;

  #nixpkgs.config.cudaSupport = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Use the systemd-boot EFI boot loader.

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 6;
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
    };
    plymouth.enable = true;
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  networking.hostName = "8Pi"; # Define your hostname.

  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Australia/Melbourne";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # ssd
  services.fstrim.enable = true;

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraOptions = [ "--unsupported-gpu" ];
  };

  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  security.rtkit.enable = true;
  # Enable sound.
  services.pulseaudio.enable = false;

  services.flatpak.enable = true;

  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
  };

  services.mullvad-vpn.enable = true;
  services.mullvad-vpn.package = pkgs.mullvad-vpn;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.fennecs = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "libvirtd"
      "docker"
    ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      r2modman
      element-desktop
      firefox
      telegram-desktop
      ghc
      vim
      mpv
      perf-tools
      perf
      (symlinkJoin {
        name = "vscode-with-extensions";
        paths = [
          (vscode-with-extensions.override {
            vscodeExtensions = with vscode-extensions; [
              jnoortheen.nix-ide
              ms-python.python
              gleam.gleam
              ms-vscode-remote.remote-containers
              ms-vscode-remote.vscode-remote-extensionpack
              ms-vscode.hexeditor
              justusadam.language-haskell
              haskell.haskell
              github.copilot
            ];
          })
        ];
        buildInputs = [ makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/code --add-flags "--disable-gpu"
        '';
      })

      unzip
      prismlauncher
      jdk
      gleam
      erlang
      # docker
      easyeffects
      # nvtopPackages.full
      git
      haskellPackages.pointfree
      vesktop
      krita
    ];
  };

  virtualisation = {
    libvirtd = {
      enable = true;
    };
    docker = {
      enable = true;
    };
    spiceUSBRedirection.enable = true;
  };
  services.spice-vdagentd.enable = true;

  programs.gamemode.enable = true;
  programs.steam.enable = true;
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;
  programs.starship.enable = true;
  programs.nix-ld.enable = true;

  systemd.services.gpuPowerLimit = {
    enable = false;
    script = ''
      /run/current-system/sw/bin/nvidia-smi --power-limit=300
    '';
    wantedBy = [ "multi-user.target" ];
  };

  environment.systemPackages = with pkgs; [
    nano
    wget
    vim
    git
    gnomeExtensions.dash-to-panel
    gnomeExtensions.appindicator
    gnomeExtensions.maximize-to-empty-workspace
    # stuff for virtualisation
    virt-manager
    virt-viewer
    spice
    spice-gtk
    spice-protocol
  ];

  environment.gnome.excludePackages = (
    with pkgs;
    [
      gnome-tour
      gnome-music
      cheese
    ]
  );

  environment.sessionVariables = {
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    GTK_THEME = "Adwaita-dark";
    NIXOS_OZONE_WL = "1";
  };

  networking.firewall.enable = true;
  # networking.firewall = {
  #  allowedTCPPorts = [ 25565 ];
  # };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
