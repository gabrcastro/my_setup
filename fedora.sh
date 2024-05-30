#!/bin/bash

# functions
menu() {
	clear
	echo ""
	echo "-------------------------------------------------------------------------------------"
	echo "      ___         ___          _____          ___           ___           ___      "
	echo "     /  /\       /  /\        /  /::\        /  /\         /  /\         /  /\     "
	echo "    /  /:/_     /  /:/_      /  /:/\:\      /  /::\       /  /::\       /  /::\    "
	echo "   /  /:/ /\   /  /:/ /\    /  /:/  \:\    /  /:/\:\     /  /:/\:\     /  /:/\:\   "
	echo "  /  /:/ /:/  /  /:/ /:/_  /__/:/ \__\:|  /  /:/  \:\   /  /:/~/:/    /  /:/~/::\  "
	echo " /__/:/ /:/  /__/:/ /:/ /\ \  \:\ /  /:/ /__/:/ \__\:\ /__/:/ /:/___ /__/:/ /:/\:\ "
	echo " \  \:\/:/   \  \:\/:/ /:/  \  \:\  /:/  \  \:\ /  /:/ \  \:\/:::::/ \  \:\/:/__\/ "
	echo "  \  \::/     \  \::/ /:/    \  \:\/:/    \  \:\  /:/   \  \::/~~~~   \  \::/      "
	echo "   \  \:\      \  \:\/:/      \  \::/      \  \:\/:/     \  \:\        \  \:\      "
	echo "    \  \:\      \  \::/        \__\/        \  \::/       \  \:\        \  \:\     "
	echo "     \__\/       \__\/                       \__\/         \__\/         \__\/     "
        echo ""
	echo "-------------------------------------------------------------------------------------"
	echo "								   CREATED BY GABRCASTRO   "
	echo "-------------------------------------------------------------------------------------"
	echo ""
	echo "1 ] UPDATE SYSTEM "
	echo "2 ] INSTALL START PACKAGES"
	echo "3 ] GET ASDF"
	echo "4 ] GET OHMYZSH"
	echo "5 ] SET DNF FASTER"
	echo "6 ] ADD RPMFUSION"
	echo "7 ] GET OHMYZSH PLUGINS"
	echo "8 ] SET OHMYZSH PLUGINS ON .zshrc"
	echo "9 ] SET ASDF ON .zshrc"
	echo "A ] GET NODEJS BY ASDF"
	echo "B ] GET FLUTTER BY ASDF"
	echo "C ] INSTALL NVIDIA DRIVERS"
	echo "D ] INSTALL GITHUB CLI"
	echo "L ] LOGOUT"
	echo "R ] REBOOT"
	echo "0 ] EXIT"
	echo "-------------------------------------------------------------------------------------"
	
	read -p ">_ " choice
	
	case $choice in
		1) update_system ;;
		2) install_start_packages ;;
		3) get_asdf ;;
		4) get_ohmyzsh ;;
		5) set_dnf_faster ;;
		6) add_rpmfusion ;;
		7) get_ohmyzsh_plugins ;;
		8) set_ohmyzsh_plugins ;;
		9) set_asdf ;;
		A) get_nodejs ;;
		B) get_flutter ;;
		C) install_nvidia ;;
		D) install_github_cli ;;
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

update_system() {
	echo "$passwd" | sudo dnf update -y
	continue_menu
}

install_start_packages() {
	echo "$passwd" | sudo dnf install git curl zsh neovim neofetch java-17-openjdk gnome-tweaks -y
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

set_dnf_faster() {
	if [ -f /etc/dnf/dnf.conf]; then
	    if grep -q "^max_parallel_downloads=10$" /etc/dnf/dnf.conf &&
	       grep -q "^fastestmirror=true$" /etc/dnf/dnf.conf &&
	       grep -q "^deltarpm=true$" /etc/dnf/dnf.conf; then
		echo "As linhas já existem no arquivo dnf.conf"
	    else
		echo "max_parallel_downloads=10" | sudo tee -a /etc/dnf/dnf.conf > /dev/null
		echo "fastestmirror=true" | sudo tee -a /etc/dnf/dnf.conf > /dev/null
		echo "deltarpm=true" | sudo tee -a /etc/dnf/dnf.conf > /dev/null
		echo ""
		echo "Linhas adicionadas ao arquivo dnf.conf"
	    fi
		else
			echo ""
	    		echo "Arquivo /etc/dnf/dnf.conf não encontrado"
		fi
	continue_menu
}

add_rpmfusion() {
	sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

	sudo dnf config-manager --enable fedora-cisco-openh264

	continue_menu
}

get_ohmyzsh_plugins() {
	sudo git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
	
	sudo git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

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
	if [ -f ~/.zshrc]; then
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

install_nvidia() {
	sudo dnf install kernel-devel -y
	sudo dnf install akmod-nvidia xorg-x11-drv-nvidia-cuda -y
	sudo systemctl enable nvidia-hibernate.service nvidia-suspend.service nvidia-resume.service nvidia-powerd.service

	echo ""
	echo "reboot to apply yours settings"
	continue_menu
}

install_github_cli() {
	sudo dnf install 'dnf-command(config-manager)'
	sudo dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo
	sudo dnf install gh -y
	
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
flutter_version="3.19.6-stable"

menu
