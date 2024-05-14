#!/bin/bash

# functions
menu() {
	clear
	echo "1234    1234  123456789012  1234          1234          123456789012  1234"
	echo "1234    1234  123456789012  1234          1234          123456789012  1234"
	echo "1234    1234  1234          1234          1234          1234    9012  1234"
	echo "123456789012  1234567890    1234          1234          1234    9012  1234"
	echo "123456789012  1234567890    1234          1234          1234    9012  1234"
	echo "1234    1234  1234          1234          1234          1234    9012      "
	echo "1234    1234  123456789012  123456789012  123456789012  123456789012  1234"
	echo "1234    1234  123456789012  123456789012  123456789012  123456789012  1234"
	echo "=========================================================================="
	echo ""
	echo "> MENU"
	echo ""
	echo "1 -> Update system"
	echo "2 -> Install start packages"
	echo "3 -> Get asdf"
	echo "4 -> Get ohmyzsh"
	echo "5 -> Set dnf faster"
	echo "6 -> Add RPMFusion"
	echo "7 -> Get ohmyzsh plugins"
	echo "8 -> Set ohmyzsh plugins on .zshrc"
	echo "9 -> Set asdf on .zshrc"
	echo "10 -> Get nodejs by asdf"
	echo "11 -> Get Flutter by asdf"
	echo "12 -> Logout"
	echo "13 -> Reboot"
	echo "0 -> Exit"
	
	read -p "Choose an option _> " choice
	
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
		10) get_nodejs ;;
		11) get_flutter ;;
		12) logout ;;
		13) sudo reboot ;;
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
	if [ -f /etc/dnf/dnf.conf ]; then
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

# ---- START CODE HERE
passwd="g4br13l"
nodejs_version="latest"
flutter_version="3.19.6-stable"

menu
