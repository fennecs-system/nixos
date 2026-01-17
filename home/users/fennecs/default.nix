{
  config,
  pkgs,
  version,
  ...
}:

{

  imports = [
    ./sway
    #./firefox.nix
  ];

  catppuccin = {
    vscode = {
      profiles."Default".accent = "pink";
      profiles."Default".enable = true;
      profiles."Default".flavor = "mocha";
    };

    enable = true;
    flavor = "mocha";
    accent = "pink";

    waybar = {
      enable = true;
      flavor = "mocha";
    };

    sway = {
      enable = true;
      flavor = "mocha";
    };

    wezterm = {
      enable = true;
      flavor = "mocha";
      apply = true;
    };

    fish = {
      enable = true;
      flavor = "mocha";
    };

    vesktop = {
      enable = true;
      flavor = "mocha";
      accent = "pink";
    };

    firefox = {
      enable = true;
      flavor = "mocha";
      accent = "pink";
      force = true;
    };
  };

  programs.firefox.enable = true;
  programs.vesktop.enable = true;

  programs.vscode = {
    enable = true;
    package = pkgs.symlinkJoin {
      name = "vscodium-with-extensions";
      pname = "vscodium";
      version = pkgs.vscodium.version;
      paths = [
        (pkgs.vscode-with-extensions.override {
	  vscode = pkgs.vscodium;
          vscodeExtensions = with pkgs.vscode-extensions; [
            jnoortheen.nix-ide
            ms-python.python
            gleam.gleam
            ms-vscode-remote.remote-containers
            ms-vscode-remote.vscode-remote-extensionpack
            ms-vscode.hexeditor
            justusadam.language-haskell
            haskell.haskell
            github.copilot
            ziglang.vscode-zig
            catppuccin.catppuccin-vsc
            catppuccin.catppuccin-vsc-icons
          ];
        })
      ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/codium --add-flags "--disable-gpu"
      '';
    };
  };

  gtk = {
    enable = true;

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
      gtk-decoration-layout = ":";
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
      gtk-decoration-layout = ":";
    };
  };

  home.stateVersion = version;
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    signal-desktop
    unofficial-homestuck-collection
    zig
    flameshot
    maple-mono.variable
    maple-mono.truetype
    maple-mono.NF-unhinted
    maple-mono.NF-CN-unhinted
    r2modman
    element-desktop
    telegram-desktop
    ghc
    vim
    vlc 
    qbittorrent
    perf-tools
    perf
    unzip
    prismlauncher
    jdk
    gleam
    nixfmt
    erlang
    easyeffects
    git
    haskellPackages.pointfree
    krita
  ];

  # You can also set your shell in Home Manager
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      # Commands to run in interactive sessions can go here
    '';
    shellInit = ''
      fish_add_path $HOME/.cargo/bin
    '';
  };
}
