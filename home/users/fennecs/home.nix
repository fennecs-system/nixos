{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
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
    nixfmt
    erlang
    easyeffects
    git
    haskellPackages.pointfree
    vesktop
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
