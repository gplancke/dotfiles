{
  description = "Homies profile (flake)";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

  outputs = { self, nixpkgs, ... }@inputs:
  let
    systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
    forAll = f: nixpkgs.lib.genAttrs systems (system:
      let
        pkgs = import nixpkgs { inherit system; };
        homies = [
          pkgs.cacert
          pkgs.nix-diff
          pkgs.bash
        ];
      in f pkgs homies);
  in {
    packages = forAll (pkgs: homies:
      {
        homies = pkgs.buildEnv { name = "homies"; paths = homies; };
      });

    devShells = forAll (pkgs: homies: {
      default = pkgs.mkShell { packages = homies; };
    });
  };
}
