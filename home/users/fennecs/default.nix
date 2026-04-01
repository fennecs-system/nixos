{
  config,
  pkgs,
  version,
  inputs,
  ...
}:

{

  imports = [
    ./sway
    ./telegram.nix
    ./theme.nix
    #./firefox.nix
  ];

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
            elixir-lsp.vscode-elixir-ls
            ms-python.python
            gleam.gleam
            ms-vscode-remote.remote-containers
            ms-vscode-remote.vscode-remote-extensionpack
            ms-vscode.hexeditor
            justusadam.language-haskell
            haskell.haskell
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

  home.stateVersion = version;
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    (symlinkJoin {
      name = "signal-desktop";
      paths = [ signal-desktop ];
      buildInputs = [ makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/signal-desktop \
          --add-flags "--password-store=gnome-libsecret"
      '';
    })
    claude-code
    unofficial-homestuck-collection
    zig
    flameshot
    maple-mono.variable
    maple-mono.truetype
    maple-mono.NF-unhinted
    maple-mono.NF-CN-unhinted
    r2modman
    element-desktop
    ghc
    vim
    vlc
    gcr
    qbittorrent
    perf-tools
    perf
    unzip
    prismlauncher
    jdk
    gleam
    nixfmt
    erlang
    # easyeffects
    git
    haskellPackages.pointfree
    # krita
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

  # gnome remote desktop
  # dconf.settings = {
  #   "org/gnome/desktop/remote-desktop/rdp" = {
  #     enable = true;
  #     view-only = false;
  #     screen-share-mode = "mirror-primary"; # or "extend"
  #     tls-cert = "/home/fennecs/.local/share/gnome-remote-desktop/rdp-tls.crt";
  #     tls-key = "/home/fennecs/.local/share/gnome-remote-desktop/rdp-tls.key";
  #   };
  # };
}
