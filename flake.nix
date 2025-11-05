{
  description = "woof";
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
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
            modules = [ ./hosts/${hostname} ];
          };
        };

      hostConfigs = lib.genAttrs hostDirs mkHost;
      
      nixosHosts = lib.filterAttrs (_: v: v.platform == "nixos") hostConfigs;
  in
    {
      nixosConfigurations = lib.mapAttrs (_: v: v.config) nixosHosts;
    };
}

