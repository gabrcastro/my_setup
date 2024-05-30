#!/bin/bash

# functions
menu() {
	clear
	echo "----------------------------------------------------------------------------"
	echo "      ___         ___           ___                  ___           ___      "
	echo "     /  /\       /  /\         /  /\                /  /\         /  /\     "
	echo "    /  /::\     /  /::\       /  /::\              /  /::\       /  /:/_    "
	echo "   /  /:/\:\   /  /:/\:\     /  /:/\:\            /  /:/\:\     /  /:/ /\   "
	echo "  /  /:/~/:/  /  /:/  \:\   /  /:/~/:/           /  /:/  \:\   /  /:/ /::\  "
	echo " /__/:/ /:/  /__/:/ \__\:\ /__/:/ /:/           /__/:/ \__\:\ /__/:/ /:/\:\ "
	echo " \  \:\/:/   \  \:\ /  /:/ \  \:\/:/            \  \:\ /  /:/ \  \:\/:/~/:/ "
	echo "  \  \::/     \  \:\  /:/   \  \::/              \  \:\  /:/   \  \::/ /:/  "
	echo "   \  \:\      \  \:\/:/     \  \:\               \  \:\/:/     \__\/ /:/   "
	echo "    \  \:\      \  \::/       \  \:\               \  \::/        /__/:/    "
	echo "     \__\/       \__\/         \__\/                \__\/         \__\/     "
	echo "----------------------------------------------------------------------------"
	echo "							  CREATED BY GABRCASTRO   "
	echo "----------------------------------------------------------------------------"
	echo "----------------------------------------------------------------------------"
	echo ""
	echo "1 ] UPDATE SYSTEM "
	echo "2 ] INSTALL START PACKAGES"
	echo "3 ] GET ASDF"
	echo "4 ] GET OHMYZSH"
	echo "5 ] GET OHMYZSH PLUGINS"
	echo "6 ] SET OHMYZSH PLUGINS ON .zshrc"
	echo "7 ] SET ASDF ON .zshrc"
	echo "8 ] GET NODEJS BY ASDF"
	echo "9 ] GET FLUTTER BY ASDF"
	echo "A ] INSTALL GITHUB CLI"
	echo "B ] SET POPOS DOCK TRANSPARENCY"
	echo "C ] INSTALL I3WM"
	echo "L ] LOGOUT"
	echo "R ] REBOOT"
	echo "0 ] EXIT"
	echo "----------------------------------------------------------------------------"

	read -p "Choose an option _> " choice
	
	case $choice in
		1) update_system ;;
		2) install_start_packages ;;
		3) get_asdf ;;
		4) get_ohmyzsh ;;
		5) get_ohmyzsh_plugins ;;
		6) set_ohmyzsh_plugins ;;
		7) set_asdf ;;
		8) get_nodejs ;;
		9) get_flutter ;;
		A) install_github_cli ;;
		B) dock_transparency ;;
		C) install_i3wm ;;
		L) logout ;;
		R) sudo reboot ;;
		0) exit ;;
	esac
	
}
continue_menu() {
	echo ""
	read -p "tap to continue"
	menu
}

dock_transparency() {
	read -p "% opacity (0.5 == 50%) _> " opacity

	gsettings set org.gnome.shell.extensions.dash-to-dock background-opacity "$opacity"

	continue_menu
}

install_i3wm() {
	# Installing required libraries
	sudo apt install libxcb-glx0 libxcb-glx0-dev libxcb1-dev libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev libxcb-icccm4-dev libyajl-dev libstartup-notification0-dev libxcb-randr0-dev libev-dev libxcb-cursor-dev libxcb-xinerama0-dev libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev autoconf xutils-dev libtool automake libxcb-shape0-dev xcb-proto cmake cmake-data pkg-config python3-sphinx libcairo2-dev libxcb-composite0-dev python3-xcbgen libxcb-image0-dev libxcb-ewmh-dev libxcb-xrm-dev libasound2-dev libpulse-dev libjsoncpp-dev libmpdclient-dev libcurl4-openssl-dev libnl-genl-3-dev meson libxext-dev libxcb-damage0-dev libxcb-xfixes0-dev libxcb-render-util0-dev libxcb-render0-dev libxcb-present-dev libpixman-1-dev libdbus-1-dev libconfig-dev libgl1-mesa-dev libpcre2-dev libevdev-dev uthash-dev libx11-xcb-dev -y

	
	# speed ricer repository i3-gaps
	sudo add-apt-repository ppa:kgilmer/speed-ricer -y
	sudo apt update -y
	sudo apt install i3-gaps -y
	
	# Polybar Install
	cd $HOME/Downloads
	git clone https://github.com/stark/siji && cd siji
	./install.sh
	cd $HOME/Downloads
	git clone --recursive https://github.com/polybar/polybar
	cd $HOME/Downloads/polybar
	mkdir build && cd build
	cmake ..
	make -j$(nproc)
	sudo make install

	# Picom install
	cd $HOME/Downloads
	git clone https://github.com/ibhagwan/picom.git
	cd picom
	git submodule update --init --recursive
	meson --buildtype=release . build
	ninja -C build
	sudo ninja -C build install

	# installing numlockx
	sudo apt install feh numlockx ttf-unifont -y

	# Replacing files
	mkdir $HOME/Pictures/Wallpapers
	cp $HOME/Downloads/i3wm-ez/Wallpapers/landscape1.jpg $HOME/Pictures/Wallpapers/landscape1.jpg
	mkdir $HOME/.config/i3
	cp $HOME/Downloads/i3wm-ez/config/i3/config $HOME/.config/i3/config
	mkdir $HOME/.config/polybar
	mkdir $HOME/.config/picom
	cp $HOME/Downloads/i3wm-ez/config/polybar/config $HOME/.config/polybar/config
	cp $HOME/Downloads/i3wm-ez/config/polybar/launch.sh $HOME/.config/polybar/launch.sh
	chmod +x $HOME/.config/polybar/launch.sh
	cp $HOME/Downloads/i3wm-ez/config/picom/picom.conf $HOME/.config/picom/picom.conf
	
	echo ""
	echo "restart and login with i3"
	echo ""
	
	continue_menu
}

update_system() {
	echo "$passwd" | sudo apt update -y && sudo apt upgrade -y
	continue_menu
}

install_start_packages() {
	echo "$passwd" | sudo apt install git curl zsh neovim neofetch openjdk-17-jdk gnome-tweaks alacritty -y
	continue_menu
}

get_asdf() {
	git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.0
	continue_menu
}

get_ohmyzsh() {
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
	continue_menu
}


get_ohmyzsh_plugins() {
	git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
	
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

	continue_menu
}

set_asdf() {
line_to_add='. "$HOME/.asdf/asdf.sh"'

if grep -q "^$line_to_add$" ~/.zshrc; then
    echo "A linha já existe no arquivo .zshrc"
else
    echo "$line_to_add" >> ~/.zshrc
    echo "Linha adicionada ao final do arquivo .zshrc"
fi

	echo ""
	echo "reboot or logout to apply yours settings"

	continue_menu
}

set_ohmyzsh_plugins() {

	# ohmyzsh
	if [ -f ~/.zshrc ]; then
	    if grep -q "^plugins=(git)$" ~/.zshrc; then
		sed -i 's/^plugins=(git)$/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc
		echo "Linha substituída no arquivo .zshrc"
	    else
	    	echo ""
		echo "A linha 'plugins=(git)' não foi encontrada no arquivo .zshrc"
	    fi
	else
		echo ""
	    echo "Arquivo .zshrc não encontrado"
	fi
	
	echo ""
	echo "reboot or logout to apply yours settings"
	
	continue_menu
}

get_nodejs() {
	asdf plugin add nodejs
	asdf install nodejs $nodejs_version
	asdf global nodejs $nodejs_version
	continue_menu
}

get_flutter() {
	asdf plugin add flutter
	asdf install flutter $flutter_version
	asdf global flutter $flutter_version
	continue_menu
}



install_github_cli() {
	(type -p wget >/dev/null || (sudo apt update && sudo apt-get install wget -y)) \
	&& sudo mkdir -p -m 755 /etc/apt/keyrings \
	&& wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
	&& sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
	&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
	&& sudo apt update \
	&& sudo apt install gh -y
	
	read -p "[y] login or [n] menu _> " choice
	
	case $choide in
		y) github_login ;;
		n) continue_menu ;;
	esac
}

github_login() {
	gh auth login
	
	continue_menu
}

# ---- START CODE HERE
passwd="g4br13l"
nodejs_version="latest"
flutter_version="3.22.0-stable"

menu
