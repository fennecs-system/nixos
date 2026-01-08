{
  description = "woof";
  inputs = {
    catppuccin = {
      url ="github:catppuccin/nix";
    };
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lix = {
      url = "https://git.lix.systems/lix-project/lix/archive/main.tar.gz";
      flake = false;
    };

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/main.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.lix.follows = "lix";
    };


  };
  outputs =
    inputs@{
      self,
      lix-module, 
      lix,
      nixpkgs,
      home-manager,
      catppuccin,
      ...
    }:
    let
      lib = nixpkgs.lib;

      hostDirs = builtins.attrNames (builtins.readDir ./hosts);

      mkHost = hostname:
        let
          hostSystem = import ./hosts/${hostname}/system.nix;
        in
        {
          platform = hostSystem.platform or "nixos";
          config = lib.nixosSystem {
            system = hostSystem.system;
            specialArgs = { 
              inherit inputs;
              version = hostSystem.version;
            };
            modules = [ 
              ./hosts/${hostname} 
              lix-module.nixosModules.default  
            ];
          };
        };

      hostConfigs = lib.genAttrs hostDirs mkHost;
      
      nixosHosts = lib.filterAttrs (_: v: v.platform == "nixos") hostConfigs;
  in
    {
      nixosConfigurations = lib.mapAttrs (_: v: v.config) nixosHosts;
    };
}

