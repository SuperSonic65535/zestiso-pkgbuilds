#!/bin/sh
SOUND_THEME="$(cat $HOME/.config/gtk-4.0/settings.ini | grep -m1 gtk-sound-theme-name | cut -d '=' -f 2)"
[ -z "$SOUND_THEME" ] && SOUND_THEME="ocean"
UPDATE_MESSAGE="You can also update by clicking the update status tray indicator, or by launching \"Add/Remove Software\" from the \"System\" section in the Application Launcher."
NUM_UPDATES="$(checkupdates | wc -l)"
if [ $NUM_UPDATES == 1 ]; then
    BUTTON_ACTION="$(notify-send --urgency=normal --expire-time=0 --app-name="Software update" --category=network --icon="update-low" --action=UPDATE="Update software" "Update available" "$UPDATE_MESSAGE")"
elif [ $NUM_UPDATES -gt 1 ] && [ $NUM_UPDATES -lt 100 ]; then
    BUTTON_ACTION="$(notify-send --urgency=normal --expire-time=0 --app-name="Software update" --category=network --icon="update-low" --action=UPDATE="Update software" "$NUM_UPDATES updates available" "$UPDATE_MESSAGE")"
elif [ $NUM_UPDATES -ge 100 ] && [ $NUM_UPDATES -lt 200 ]; then
    paplay /usr/share/sounds/"$SOUND_THEME"/stereo/dialog-information.oga &
    BUTTON_ACTION="$(notify-send --urgency=normal --expire-time=0 --app-name="Software update" --category=network --icon="update-medium" --action=UPDATE="Update software" "$NUM_UPDATES updates available" "Your software is out of date! Please update now for the latest features, optimisations and security fixes.\\n$UPDATE_MESSAGE")"
elif [ $NUM_UPDATES -ge 200 ]; then
    paplay /usr/share/sounds/"$SOUND_THEME"/stereo/dialog-warning.oga &
    BUTTON_ACTION="$(notify-send --urgency=normal --expire-time=0 --app-name="Software update" --category=network --icon="update-high" --action=UPDATE="Update software" "$NUM_UPDATES updates available" "Your software is extremely out of date and your system is at risk! Please update now for the latest features, optimisations and security fixes.\\n$UPDATE_MESSAGE")"
fi
if [ ! -z "$BUTTON_ACTION" ]; then
    if [ $BUTTON_ACTION == "UPDATE" ]; then /usr/lib/pamac-plasma/pamac-update.sh; fi
fi
