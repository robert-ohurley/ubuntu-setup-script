#!/bin/sh

if [[ $EUID -ne 0 ]]; then
   	echo "This script must be run as root" 
   	exit 1
fi

echo "Updating and Upgrading"
	apt-get update && sudo apt-get upgrade -y

echo "Build some dircetories" 
	mkdir ~/Projects
	mkdir ~/Programming
	mkdir ~/Uni
	mkdir ~/.local/share/fonts 


echo "Installing Packages"
	sudo apt install git-all -y
	sudo apt install curl
	sudo snap install --classic code
	sudo apt install vlc -y 
	sudo apt install tmux
	sudo apt-get install unzip
	sudo apt install gnome-tweaks
	sudo snap install discord
	
echo "Installing fzf"
	git clone --depth 1 https://github.com/junegunn/fzf.git ~/.config/.fzf
	~/.config/.fzf/install

echo "Installing Node Version Manager and Node v20.12.1"
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
	mv ~/.nvm ~/.config/.nvm
	export NVM_DIR="$XDG_CONFIG_HOME/.nvm"
	[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
	[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
	nvm install 20

echo "Installing Mysql"
	apt install mysql-server -y
	sudo snap install mysql-workbench-community			
	 			
echo "Installing Golang"
curl -OL https://go.dev/dl/go1.22.2.linux-amd64.tar.gz
sudo tar -C /usr/local -xvf go1.22.2.linux-amd64.tar.gz
			

echo "Setting up Zsh"
	sudo apt install zsh -y
	chsh -s $(which zsh)
	echo "if [ \"${ZSH_VERSION:-unset}\" = \"unset\" ] ; then
	    export SHELL=/bin/zsh
	    exec /bin/zsh -l
	fi" >> ~/.bashrc

	sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
	
	
echo "Setting up Nvim"	
	curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
	sudo rm -rf /opt/nvim
	sudo tar -C /opt -xzf nvim-linux64.tar.gz
	
echo "Setting up GithubCLI and authorizing" 
	sudo mkdir -p -m 755 /etc/apt/keyrings && wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
&& sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
&& sudo apt update \
&& sudo apt install gh -y
	gh auth login
	
echo "Nerd Font"
	sudo curl -OL https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.0/JetBrainsMono.zip
	mkdir ~/.local/share/fonts
	unzip JetBrainsMono.zip -d ~/.local/share/fonts/
	fc-cache ~/.local/share/fonts
	rm JetBrainsMono.zip
	
echo "Setting up dotfiles" 	
	git clone git@github.com:robert-ohurley/dotfiles.git
	ln -s -f ~/dotfiles/git/.gitconfig ~/.gitconfig
	ln -s -f ~/dotfiles/vscode/settings.json ~/.config/Code/User/settings.json
	ln -s -f ~/dotfiles/zsh/.zshrc ~/.zshrc
	rm -rf ~/.config/.oh-my-zsh/custom 
	git clone https://github.com/zsh-users/zsh-autosuggestions ~/.config/.oh-my-zsh/custom/plugins/zsh-autosuggestions
	
echo "Setting up Docker"
	curl -fsSL https://get.docker.com -o get-docker.sh
	sudo sh ./get-docker.sh --dry-run
	sudo groupadd docker
	sudo usermod -aG docker ${USER}
	su -s ${USER}
	sudo chmod 666 /var/run/docker.sock

echo "Setting up Browser"
	sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
	echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
	sudo apt update
	sudo apt install brave-browser -y
	
echo "Cleaning up..."
	rm ~/nvim-linux64.tar.gz
	rm ~/go1.22.2.linux-amd64.tar.gz
	rm ~/gcm-linux_amd64.2.4.1.deb

