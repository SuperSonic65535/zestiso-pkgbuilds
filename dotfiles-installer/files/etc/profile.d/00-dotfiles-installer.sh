if [ ! -f "$HOME/.config/dotfiles-installer" ]; then
	case $USER in
		live) DOTFILES_DIR="/etc/dotfiles.d/live";;
		root) DOTFILES_DIR="/etc/dotfiles.d/root";;
		*) DOTFILES_DIR="/etc/dotfiles.d/user";;
	esac
	## Install dotfiles to user home directory, if the dotfiles directory exists
	CDIR="$PWD"; if [ -d "$DOTFILES_DIR" ]; then
		cd "$DOTFILES_DIR"
		cp -r "*" "$HOME/"; cp -r ".*" "$HOME/"
		mkdir -p "$HOME/.config"; touch "$HOME/.config/dotfiles-installer"
	fi
fi
