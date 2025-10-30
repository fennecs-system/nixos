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
	   system = "x86_64-linux";
       in {
           nixosConfigurations = {
               ${eightPi} = lib.nixosSystem {
                   inherit system;
                   modules = [ ./configuration.nix ];
               };        
           };
       };
}
