if [ ! -f "$HOME/.config/dotfiles-installer" ]; then
	case $USER in
		live) DOTFILES_DIR="/etc/dotfiles.d/live";;
		root) DOTFILES_DIR="/etc/dotfiles.d/root";;
		*) DOTFILES_DIR="/etc/dotfiles.d/user";;
	esac
	## Install dotfiles to user home directory, if the dotfiles directory exists
	if [ -d "$DOTFILES_DIR" ]; then
		for FOUND_FILE in $(ls -Aw 1 "$DOTFILES_DIR"); do
			cp -r "$DOTFILES_DIR/$FOUND_FILE" "$HOME/"
		done; mkdir -p "$HOME/.config"; touch "$HOME/.config/dotfiles-installer"
	fi
fi
