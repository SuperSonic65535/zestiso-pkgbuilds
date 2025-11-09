#!/bin/sh
groups $(whoami) | grep wheel && \
sudo /usr/lib/pamac-plasma/update-repos.sh || \
pkexec /usr/lib/pamac-plasma/update-repos.sh
pamac-manager --updates $@ &> /dev/null
