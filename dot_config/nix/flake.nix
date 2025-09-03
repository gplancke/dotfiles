{
  description = "Homies";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

  outputs = { nixpkgs, ... }:
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
          pkgs.gcc
          pkgs.bash
          pkgs.zsh
					pkgs.fzf
          pkgs.tree
          pkgs.age
          pkgs.unzip
          pkgs.bat
          pkgs.jq
          pkgs.jc
          pkgs.sq
          pkgs.zoxide
          pkgs.ripgrep
          pkgs.silver-searcher
					pkgs.diff-so-fancy
					pkgs.starship

          pkgs.mkcert
          pkgs.socat
          pkgs.nmap

					pkgs.direnv

					pkgs.git
					pkgs.gh
					pkgs.hub
					pkgs.fossil

					pkgs.ttyd
					pkgs.tmux
					pkgs.neovim

          pkgs.htop
          pkgs.gtop
					pkgs.lazydocker
					pkgs.lazygit
        ];
      };

    });
  };
}
