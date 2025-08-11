{
  description = "Homies + Home Manager";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
  inputs.home-manager.url = "github:nix-community/home-manager";
  inputs.home-manager.inputs.nixpkgs.follows = "nixpkgs";

  outputs = { self, nixpkgs, home-manager, ... }:
  let
    # Define a set of supported systems
    supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];

    # Function to create a pkgs set for a given system
    forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f system (import nixpkgs { inherit system; }));
  in {
    packages = forAllSystems (system: pkgs: {
      homies = pkgs.buildEnv {
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

      home-manager = home-manager.packages.${system}.home-manager;
    });

    homeConfigurations."georgio" = let
      currentSystem = nixpkgs.lib.system.buildPlatform.system;
      pkgsForHomeManager = import nixpkgs { system = currentSystem; };
    in home-manager.lib.homeManagerConfiguration {
      pkgs = pkgsForHomeManager;
      modules = [
        {
          imports = [ ./home.nix ];
        }
      ];
    };
  };
}
