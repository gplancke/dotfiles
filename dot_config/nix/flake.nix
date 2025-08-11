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
    # Your packages for all supported systems
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
          # mkcert might not be available on Darwin via default nixpkgs for some reasons,
          # or might require extra setup.
          # If it fails on macOS, you might need to conditionally add it or find an alternative.
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
    });

    # Home Manager standalone config (assuming "georgio" is a user on a specific system)
    # You'll likely need to define `homeConfigurations` for each system you intend to use it on.
    # For simplicity, if you only run this on one system at a time, you can get the current system
    # from nixpkgs.lib.system.buildPlatform.system as shown below.
    homeConfigurations."georgio" = let
      # Get the current system from nixpkgs
      # This is useful when you're sure you're only building for the current machine.
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
