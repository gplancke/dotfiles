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
					pkgs.ttyd

					pkgs.hello
					pkgs.direnv
					pkgs.qemu
					pkgs.starship
					pkgs.diff-so-fancy
					pkgs.fzf

					pkgs.git
					pkgs.gh
					pkgs.hub
					pkgs.lazygit

					pkgs.neovim
					pkgs.tmux

					pkgs.lazydocker

					pkgs.nodejs_22
					pkgs.deno
					pkgs.pnpm

					pkgs.luarocks

					pkgs.ruby

					pkgs.python3
					pkgs.uv

					pkgs.cargo

					pkgs.openjdk17-bootstrap
        ];
      };

    });
  };
}
