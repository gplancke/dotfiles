#!/bin/bash

#############################################
# This function is used across the setup.sh
# It used to detect the current distro/os
# and return it as a string
#############################################

function detect_distro {
  if [[ $OSTYPE == darwin* ]]; then
    echo "darwin"
  elif [[ $OSTYPE == linux-gnu* ]]; then
    echo "ubuntu"
  else
    echo "ubuntu"
  fi
}

#############################################
# Installs homebrew on darwin and linux
# On linux it installs linuxbrew
# We tend to use nix instead
#############################################

function install_brew {
  local osType=$1

  if [ "$osType" = "darwin" ]; then
    [ -d "/opt/homebrew" ] || curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bash
    [ -d "/opt/homebrew" ] && eval "$(/opt/homebrew/bin/brew shellenv)"
  else
    [ -d "/home/linuxbrew/.linuxbrew" ] || [ -d "~/.linuxbrew" ] || \
      curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bash
    [ -d "/home/linuxbrew/.linuxbrew/bin" ] && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    [ ! -d "/home/linuxbrew/.linuxbrew/bin" ] && [ -d "~/.linuxbrew/bin" ] && eval "$(~/.linuxbrew/bin/brew shellenv)"
  fi
}

#############################################
# Install ni on darwin and linux
# On darwin, we add the nix-darwin util
#############################################

function install_nix {
  local osType=$1

  if [ ! -d "$HOME/.nix-profile" ]; then
		echo "Installing Nix"
		curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
	  source $HOME/.nix-profile/etc/profile.d/nix.sh

		mkdir -p $HOME/.local/bin
		cat > $HOME/.local/bin/nix-uninstall << _EOF
#!/bin/bash

/nix/nix-installer uninstall
_EOF
		chmod +x $HOME/.local/bin/nix-uninstall

	  if [ "$osType" = "darwin" ]; then
	    source $HOME/.nix-profile/etc/profile.d/nix.sh
			nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
			./result/bin/darwin-installer
			cp ./result/bin/darwin-uninstaller $HOME/.local/bin
			rm -rf ./result/bin
	  fi
  fi
}

#############################################
# Install zsh plugin manager
# We want to replace this with a nix flake
#############################################

function install_zsh_manager {
  # Installing Antigen for zsh
  if [ ! -f "$HOME/.config/antigen/antigen.zsh" ]; then
    mkdir -p "$HOME/.config/antigen"
    curl -L git.io/antigen > $HOME/.config/antigen/antigen.zsh
  fi
}

#############################################
# Install tmux plugin manager (tpm)
# We want to replace this with a nix flake
# We also want to get rid of tmux
#############################################

function install_tmux_manager {
  [ ! -d "${HOME}/.tmux/plugins/tpm" ] && \
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
}

#############################################
# Install them all
#############################################
install_brew $(detect_distro)
install_nix $(detect_distro)
install_zsh_manager
install_tmux_manager