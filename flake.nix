{
  description = "My first flake!";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.05"; 
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-colors.url = "github:misterio77/nix-colors";
    stylix.url = "github:danth/stylix";
    swww.url = "github:LGFae/swww";
    musnix.url = "github:musnix/musnix";
    #nixpkgs.follows = "nixpkgs";
    xremap-flake.url = "github:xremap/nix-flake";
    nixvim = {
      url = "github:nix-community/nixvim/nixos-24.05";
      inputs.nixpkgs.follows = "nixpkgs";	
    };
    #spicetify-nix.url = "github:the-argus/spicetify-nix";
  };


  outputs = { self, nixpkgs, home-manager, nixvim, stylix, swww, musnix, ...}@inputs:
let
  # --- VARIABLES --- # 

  # Quick
  lib = nixpkgs.lib;
  system = "x86_64-linux";
  pkgs = nixpkgs.legacyPackages.${system}; # set in packages
  
in
{
  devShells.${system}.default = pkgs.mkShell {
    nativeBuildInputs = with pkgs; [
      hello
    ];
  };

  nixosConfigurations = {
    nixos = lib.nixosSystem {
      inherit system;
      modules = [ 
        ./configuration.nix 
        stylix.nixosModules.stylix
        musnix.nixosModules.musnix
	      #nixvim.nixosModules.nixvim
	    ];
      specialArgs = { 
        inherit inputs;
      };
    };
  };

 
  homeConfigurations = {  
    joachim = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [ 
        ./home.nix 
        stylix.homeManagerModules.stylix
	      nixvim.homeManagerModules.nixvim
	    ];
      extraSpecialArgs = { 
        inherit inputs; 
      };  
    };
  };
};
}
