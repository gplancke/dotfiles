# The main homies file, where homies are defined. See the README.md for

# instructions.
let
  unpinned = import <nixpkgs> {};

  # Pinned nixpkgs version to make our env truely reproducible
  pinned = import (fetchTarball {
    url = https://github.com/NixOS/nixpkgs/archive/refs/tags/25.05.tar.gz;
  }) {};

  # The list of packages to be installed
  homies =
    [
			##### NIX STUFF
      # pinned.nix
      pinned.cacert
      pinned.nix-diff

			##### SHELLS
      pinned.bash
			## Apply a script upon entering a directory
      # pinned.direnv
      # pinned.nix-direnv
			## Awesome prompt
      # pinned.starship

			##### VCS
      # pinned.git
			## An alternative to git
      # pinned.fossil
			## A git client
			# pinned.lazygit
			# pinned.lazydocker

			##### CONTAINERS
			## Emulator
			# unpinned.qemu
			## Container runner
			#unpinned.colima
			## Docker cli
			#unpinned.docker
			## Share tty
			# unpinned.ttyd

			##### LANGUAGES
			# pinned.nodejs_20
			# pinned.nodejs_20.pkgs.pnpm
      # pinned.openjdk
			# pinned.python3Full
      # pinned.cargo
      # pinned.go
			# pinned.luajit
			# pinned.luajitPackages.luarocks
			# Sync local files to Gscripts directory
      # unpinned.google-clasp

			###### COMMONS
      # pinned.less
      # pinned.tree
      # pinned.unzip
			## Swiss army knife for TCP sockets
      # pinned.socat
			## easy encryption tool
			# pinned.age

			##### NEW COMMON TOOLS
			## Parse and decode json
      # pinned.jq
			## File search better than grep
      # pinned.ripgrep
			## Another file search better than grep
      # pinned.silver-searcher
			## List fuzzy finder
      # pinned.fzf
			## Change directory on steroid
      # unpinned.zoxide
			## Monitoring
      # pinned.htop
			## Better term diff
      # unpinned.diff-so-fancy
			# Nice network scan utils
      # unpinned.nmap
			## Better terminal cat
      # unpinned.bat
			## Like htop, but better ?
      # unpinned.gtop
			## Wrap commands to output json instead of text
      # unpinned.jc
			## Generate valid local self-signed certificates
			# unpinned.mkcert

			##### CODING
			## Best editor with vscode
      # pinned.neovim
			## Preconfigure tmux panes and windows
      # pinned.tmuxinator
			## Terminal based file browser
      # unpinned.nnn
			## Another terminal based file browser
			# unpinned.ranger
			## Terminal multiplexor. Zellij seems to be a good improvement though
      # unpinned.tmux
			## Git client which is github aware
      # unpinned.hub
			## A client for github
			# unpinned.gh
			## Git commit with style
      # unpinned.nodePackages.gitmoji-cli
			## Non-free local tunnel
      # unpinned.ngrok
			## Bitwarden cli
			# unpinned.bitwarden-cli

			##### CLOUD TOOLS
			/* unpinned.vagrant */
			/* unpinned.packer */
			/* unpinned.nomad */
			/* unpinned.consul */
			/* unpinned.terraform */
			/* unpinned.pulumi */
			# unpinned.nodePackages.vercel
			# unpinned.flyctl
			# unpinned.heroku
			# unpinned.google-cloud-sdk
			# unpinned.python310Packages.cloudflare

			##### GUI
			# unpinned.bruno
    ];
in
  # Check if we run this with nix-shell to test this
  if pinned.lib.inNixShell
  then pinned.mkShell
    {
      buildInputs = homies;
      shellHook = ''
        $(bashrc)
        '';
    }
  # Or if this is intended to be used with nix-env
  else homies
