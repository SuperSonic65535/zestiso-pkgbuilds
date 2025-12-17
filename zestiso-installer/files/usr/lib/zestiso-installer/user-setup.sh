#!/bin/sh
AddUser() {
	while true; do
		## Username dialog entry
		UserName=""; while [ -z "$UserName" ]; do
			UserName="$(kdialog --inputbox "Please enter a username.\nLetters (upper and lower case), numbers, dashes (-) and underscores (_) are allowed.\nOther characters are NOT allowed.\nThe username may be up to 32 characters long.")"
		done
		## Validation
		sudo useradd -u 1000 -m $UserName &> /dev/null; case $? in
			19) kdialog --error "The username you entered was invalid.";;
			9) kdialog --error "User \"$UserName\" exists. Please try a different username.";;
			0)
				sudo passwd -d $UserName &> /dev/null
				sudo gpasswd -a $UserName wheel &> /dev/null
				echo $UserName; break;;
			*) kdialog --error "The user could not be added. Please try a different username.";;
		esac
	done
}
SetPassword() {
	UserName="$1"; while true; do
		NewPassword="$(kdialog --password "To set a password for $UserName, enter it here:")"
		if [ -z "$NewPassword" ]; then
			case $(basename $(readlink -f /etc/systemd/system/display-manager.service) | cut -d '.' -f 1) in
				sddm)
					sudo mkdir -p /etc/sddm.conf.d
					sudo sh -c "echo '[Autologin]' > /etc/sddm.conf.d/autologin.conf"
					sudo sh -c "echo 'Relogin=false' >> /etc/sddm.conf.d/autologin.conf"
					sudo sh -c "echo 'Session=plasma' >> /etc/sddm.conf.d/autologin.conf"
					sudo sh -c "echo 'User=$UserName' >> /etc/sddm.conf.d/autologin.conf"
			esac; break
		fi
		NewPasswordConfirm="$(kdialog --password "Please enter the same password again to confirm:")"
		if [ "$NewPassword" == "$NewPasswordConfirm" ]; then
			echo "$NewPassword" | sudo passwd --stdin "$UserName" && \
			sudo rm /etc/sddm.conf.d/autologin.conf && break || \
			kdialog --error "Could not set password. Please try a different one."
		else kdialog --error "Passwords did not match."; fi
	done
}
while true; do
	UserName="$(ls -I live /home | xargs | cut -d ' ' -f 1)"
	[ -z "$UserName" ] && AddUser || break
done; SetPassword "$UserName"
if [ ! -z "$UserName" ]; then
	sudo mv /config-first-boot.service /etc/systemd/system/config-first-boot.service
	sudo ln -sfr /etc/systemd/system/config-first-boot.service /etc/systemd/system/multi-user.target.wants/config-first-boot.service
	sync; sudo reboot
fi
