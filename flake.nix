{ 
    description = "woof";
    inputs = { 
        nixpkgs = {
           url = "github:NixOS/nixpkgs/nixos-unstable";
        };
        home-manager = {
	    url ="github:nix-community/home-manager/master";
            inputs.nixpkgs.follows = "nixpkgs"; 
	};
    };
    outputs = inputs@{ self, nixpkgs, home-manager, ...}: 
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
