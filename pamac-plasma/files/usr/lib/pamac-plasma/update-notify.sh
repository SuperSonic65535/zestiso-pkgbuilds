#!/bin/sh
SOUND_THEME="$(cat $HOME/.config/gtk-4.0/settings.ini | grep -m1 gtk-sound-theme-name | cut -d '=' -f 2)"
[ -z "$SOUND_THEME" ] && SOUND_THEME="ocean"
NUM_UPDATES="$(checkupdates | wc -l)"
NUM_AUR="$(yay -Qua | wc -l)"
TOTAL_UPDATES="$(expr $NUM_UPDATES + $NUM_AUR)"

if [ $TOTAL_UPDATES == 1 ]; then
    BUTTON_ACTION="$(notify-send --urgency=normal --expire-time=0 --app-name="Software update" --category=network --icon="update-low" --action=UPDATE="Update software" "Update available")"
elif [ $NUM_UPDATES -gt 1 ] && [ $NUM_UPDATES -lt 100 ]; then
    BUTTON_ACTION="$(notify-send --urgency=normal --expire-time=0 --app-name="Software update" --category=network --icon="update-low" --action=UPDATE="Update software" "$TOTAL_UPDATES updates available")"
elif [ $NUM_UPDATES -ge 100 ] && [ $NUM_UPDATES -lt 200 ]; then
    paplay /usr/share/sounds/"$SOUND_THEME"/stereo/dialog-information.oga &
    BUTTON_ACTION="$(notify-send --urgency=normal --expire-time=0 --app-name="Software update" --category=network --icon="update-medium" --action=UPDATE="Update software" "$TOTAL_UPDATES updates available" "Your software is out of date! Please update now for the latest features, optimisations and security fixes.")"
elif [ $NUM_UPDATES -ge 200 ]; then
    paplay /usr/share/sounds/"$SOUND_THEME"/stereo/dialog-warning.oga &
    BUTTON_ACTION="$(notify-send --urgency=normal --expire-time=0 --app-name="Software update" --category=network --icon="update-high" --action=UPDATE="Update software" "$TOTAL_UPDATES updates available" "Your software is extremely out of date and your system is at risk! Please update now for the latest features, optimisations and security fixes.")"
fi
if [ ! -z "$BUTTON_ACTION" ]; then
    if [ $BUTTON_ACTION == "UPDATE" ]; then /usr/lib/pamac-plasma/pamac-update.sh; fi
fi
