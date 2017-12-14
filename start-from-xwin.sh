#!/bin/bash
gnome-terminal --geometry 80x20+60+40 -e "/bin/bash $HOME/fwa-quick-install/fwacmd.sh web"
sleep 60
gnome-terminal --geometry 80x20+60+440 -e "/bin/bash $HOME/fwa-quick-install/fwacmd.sh mqtt"
