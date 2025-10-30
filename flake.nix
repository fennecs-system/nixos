{ 
    description = "woof";
    inputs = { 
        nixpkgs = {
           url = "github:NixOS/nixpkgs/nixos-unstable";
        };
    };
    outputs = { self, nixpkgs, ...}: 
       let 
           eightPi = "8Pi";
           lib = nixpkgs.lib;
       in {
           nixosConfigurations = {
               ${eightPi} = lib.nixosSystem {
                   system = "x86_64-linux";
                   modules = [ ./configuration.nix ];
               };        
           };
       };
}
