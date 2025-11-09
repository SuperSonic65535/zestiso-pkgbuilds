if [ ! -f "$HOME/.config/dotfiles-installer" ]; then
	case $USER in
		live) DOTFILES_DIR="/etc/dotfiles.d/live";;
		root) DOTFILES_DIR="/etc/dotfiles.d/root";;
		*) DOTFILES_DIR="/etc/dotfiles.d/user";;
	esac
	## Create missing directories if root
	[ ! -d "$DOTFILES_DIR" ] && [ $USER == root ] && mkdir -p /etc/dotfiles.d/root /etc/dotfiles.d/user "$DOTFILES_DIR"
	## Install dotfiles to user home directory, if the dotfiles directory exists
	if [ -d "$DOTFILES_DIR" ]; then
		cp -r "$DOTFILES_DIR/*" "$HOME/"; cp -r "$DOTFILES_DIR/.*" "$HOME/"
		mkdir -p "$HOME/.config"; touch "$HOME/.config/dotfiles-installer"
	fi
fi
