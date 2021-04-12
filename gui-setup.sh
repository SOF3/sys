set -e
set -x

sudo apt install \
	autocutsel $(: I do not use this anymore) \
	gnome-tweaks \
	gnustep-gui-runtime \
	libcanberra-gtk-module \
	parcellite $(: ubuntu backup wanted me to use this, but I do not remember actually use it for something useful) \
	xclip  \


# Forgive me for my uncommon keyboard setup.
# I don't like lifting my wrist to reach for the arrow keys.
if command -v gsettings >/dev/null; then
	gsettings set org.gnome.shell.extensions.dash-to-dock isolate-workspaces true
	gsettings set org.gnome.shell.app-switcher current-workspace-only true
	gsettings set org.gnome.desktop.interface clock-show-seconds true
	gsettings set org.gnome.desktop.interface clock-show-date true
	gsettings set org.gnome.desktop.interface show-battery-percentage true
	gsettings set org.gnome.desktop.peripherals.touchpad disable-while-typing false
	gsettings set org.gnome.desktop.session idle-delay 18000

	gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-1 "['<Alt><Super>1']"
	gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-2 "['<Alt><Super>2']"
	gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-3 "['<Alt><Super>3']"
	gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-4 "['<Alt><Super>4']"
	gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-5 "['<Alt><Super>5']"
	gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-6 "['<Alt><Super>6']"

	gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-1 "['<Shift><Alt><Super>exclam']"
	gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-2 "['<Shift><Alt><Super>at']"
	gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-3 "['<Shift><Alt><Super>numbersign']"
	gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-4 "['<Shift><Alt><Super>dollar']"

	gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-up "['<Alt><Super>k']"
	gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-down "['<Alt><Super>j']"
	gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-up "['<Shift><Alt><Super>k']"
	gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-down "['<Shift><Alt><Super>j']"
	gsettings set org.gnome.desktop.wm.keybindings move-to-monitor-left "['<Shift><Alt><Super>h']"
	gsettings set org.gnome.desktop.wm.keybindings move-to-monitor-right "['<Shift><Alt><Super>l']"

	gsettings set org.gnome.desktop.wm.keybindings switch-applications "['<Alt>Tab']"
	gsettings set org.gnome.desktop.wm.keybindings switch-windows "['<Super>Tab']"

	gsettings set org.gnome.desktop.wm.keybindings maximize "['<Super>k']"
	gsettings set org.gnome.desktop.wm.keybindings minimize "['<Super>j']"
	gsettings set org.gnome.desktop.wm.keybindings unmaximize "['<Super>r']"
	gsettings set org.gnome.mutter.keybindings toggle-tiled-left "['<Super>h']"
	gsettings set org.gnome.mutter.keybindings toggle-tiled-right "['<Super>l']"

	# I have never found a real good use for caps lock other than keyboard mashing.
	# In fact, even if I want to spam with caps, I just hold down the left shift.
	setxkbmap -option caps:none
fi

# I don't really use dropbox anymore, just leaving it here.
wget 'https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_2019.02.14_amd64.deb' -O dropbox.deb
sudo apt install ./dropbox.deb
rm dropbox.deb
