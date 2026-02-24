# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  inputs,
  config,
  pkgs,
  version,
  ...
}:
let
  swayfx = pkgs.swayfx;
in
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.home-manager
    inputs.catppuccin.nixosModules.catppuccin
  ];

  system.stateVersion = version;

  users.users.fennecs = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "libvirtd"
      "docker"
    ];
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit version; };
    users.fennecs = {
      imports = [
        inputs.catppuccin.homeModules.catppuccin
        ../../home/users/fennecs
      ];
    };
    # this broke gdm
    # sharedModules = [{
    #   wayland.windowManager.sway.package = swayfx;
    # }];
  };

  nixpkgs.config.allowUnfree = true;
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

  # Enable the wayland windowing system.
  services.xserver.enable = true;

  security.polkit.enable = true;

  # ssd
  services.fstrim.enable = true;
  services.gnome.gnome-keyring.enable = true; 
  
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraOptions = [ "--unsupported-gpu" ];
    package = swayfx;
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
    jack.enable = true;
  };

  services.mullvad-vpn.enable = true;
  services.mullvad-vpn.package = pkgs.mullvad-vpn;

  # Define a user account. Don't forget to set a password with ‘passwd’.

  virtualisation = {
    libvirtd = {
      enable = true;
    };
    # spiceUSBRedirection.enable = true;
  };

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
    reaper
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
      orca
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
}
