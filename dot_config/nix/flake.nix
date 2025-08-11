{
  description = "Homies + Home Manager";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
  inputs.home-manager.url = "github:nix-community/home-manager";
  inputs.home-manager.inputs.nixpkgs.follows = "nixpkgs";

  outputs = { self, nixpkgs, home-manager, ... }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
  in {
    # your existing package
    packages.${system}.homies = pkgs.buildEnv {
      name = "homies";
      paths = [ 
				pkgs.cacert
				pkgs.nix-diff
				pkgs.bash
				pkgs.gcc

				pkgs.tree
				pkgs.age
				pkgs.unzip
				pkgs.mkcert
				pkgs.bat
				pkgs.jq
				pkgs.jc
				pkgs.sq
				pkgs.zoxide
				pkgs.ripgrep
				pkgs.silver-searcher
				pkgs.socat
				pkgs.nmap
				pkgs.htop
				pkgs.gtop
			];
    };

    # Home Manager standalone config
    homeConfigurations."georgio" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        {
          imports = [ ./home.nix ];
        }
      ];
    };
  };
}
