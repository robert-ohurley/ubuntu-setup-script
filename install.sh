#!/bin/sh

setUser() {
	echo "Enter user: "
	read name
	export HOME=/home/$name
}
setUser


makeDirIfNotExist() {
	 if [ ! -d $1 ]; then
	 	sudo -u $name mkdir $1
	 fi
 }

export XDG_DATA_HOME=$HOME/.local/share
export XDG_CACHE_HOME=$HOME/.cache
export XDG_CONFIG_HOME=$HOME/.config
export XDG_PICTURES_DIR=$HOME/picures
export XDG_STATE_HOME=$HOME/.local/state
export NVM_DIR="$XDG_DATA_HOME/nvm"	
export HISTFILE="$XDG_STATE_HOME"/zsh/history 
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME"/npm/npmrc

echo "Build some directories" 
	makeDirIfNotExist $HOME/Projects
	makeDirIfNotExist $HOME/Programming
	makeDirIfNotExist $HOME/Uni
	makeDirIfNotExist $XDG_DATA_HOME/fonts 
	makeDirIfNotExist $HOME/.config/wget
	makeDirIfNotExist $XDG_DATA_HOME/nvm
	makeDirIfNotExist $XDG_STATE_HOME
	makeDirIfNotExist $XDG_CACHE_HOME/zsh

echo "Updating and Upgrading"
	sudo apt-get update && sudo apt-get upgrade -y

#Git supports XDG out of the box.
echo "Setup git and clone Dotfiles"
	makeDirIfNotExist "$XDG_CONFIG_HOME/git"
	git clone https://github.com/robert-ohurley/dotfiles.git $HOME/dotfiles
	ln -s -f $HOME/dotfiles/git/config $XDG_CONFIG_HOME/git
	
echo "Installing Packages"
	sudo apt install curl -y
	sudo snap install --classic code
	sudo apt install vlc -y 
	sudo apt install tmux -y
	sudo apt-get install unzip -y
	sudo apt install gnome-tweaks -y
	sudo snap install discord
	sudo apt-get install ripgrep make gcc unzip
	
echo "Installing fzf"
	git clone --depth 1 https://github.com/junegunn/fzf.git $XDG_DATA_HOME/.fzf
	$XDG_DATA_HOME/.fzf/install

echo "Setting up Zsh"
	sudo apt install zsh -y
	chsh -s $(which zsh)
	
	echo "if [ \"${ZSH_VERSION:-unset}\" = \"unset\" ] ; then
	    export SHELL=/bin/zsh
	    exec /bin/zsh -l
	fi" >> $HOME/.bashrc
	source $HOME/.bashrc

	sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
	sudo chmod 666 /etc/zsh/zshenv
	echo "export ZDOTDIR="$XDG_CONFIG_HOME"/zsh" >> /etc/zsh/zshenv
	makeDirIfNotExist $XDG_CONFIG_HOME/zsh
	
	#move files / symlink
	mv $HOME/.oh-my-zsh $XDG_CONFIG_HOME/.oh-my-zsh
	rm -rf $XDG_CONFIG_HOME/.oh-my-zsh/custom 

	#hardcoded for some reason
	ln -s -f /home/rojetsavage/dotfiles/zsh/zshrc /home/rojetsavage/.config/zsh/.zshrc
	ln -s -f ~/dotfiles/zsh/custom $XDG_CONFIG_HOME/.oh-my-zsh/custom
	
	#plugins
	makeDirIfNotExist $XDG_CONFIG_HOME/.oh-my-zsh/custom/plugins
	git clone https://github.com/zsh-users/zsh-autosuggestions $XDG_CONFIG_HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions


echo "Installing Node Version Manager and Node v20.12.1"
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
	export NVM_DIR="$HOME/.local/share/nvm"
	[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  #This loads nvm
	[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  #nvm bash_completion
	nvm install 20
	makeDirIfNotExist $XDG_CONFIG_HOME/npm
	ln -s -f $HOME/dotfiles/npm/npmrc $XDG_CONFIG_HOME/npm/npmrc

echo "Setting up Nvim"
	curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
	sudo rm -rf /opt/nvim
	sudo tar -C /opt -xzf nvim-linux64.tar.gz
	#symlinking config
	ln -s -f $HOME/dotfiles/nvim $XDG_CONFIG_HOME/nvim
	
echo "Setting up tmux"
	ln -s -f $HOME/dotfiles/tmux $XDG_CONFIG_HOME/tmux
	git clone https://github.com/tmux-plugins/tpm $XDG_CONFIG_HOME/tmux/plugins/tpm
	tmux source $XDG_CONFIG_HOME/tmux/tmux.conf

		
echo "Setting up GithubCLI and authorizing" 
	sudo mkdir -p -m 755 /etc/apt/keyrings && wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null 
	sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg 
	echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null 
	sudo apt update 
	sudo apt install gh -y
	sudo apt update
	sudo apt install gh
	gh auth login

echo "Installing Mysql"
	sudo apt install mysql-server -y
	sudo snap install mysql-workbench-community			
	 	 		 			
echo "Installing Golang"
	cd $HOME/Downloads
	curl -OL https://go.dev/dl/go1.22.2.linux-amd64.tar.gz
	sudo tar -C /usr/local -xvf go1.22.2.linux-amd64.tar.gz
	cd $HOME	

echo "Nerd Font"
	cd $HOME/Downloads
	sudo curl -OL https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.0/JetBrainsMono.zip
	unzip JetBrainsMono.zip -d $XDG_DATA_HOME/fonts/
	fc-cache $XDG_DATA_HOME/fonts

echo "Symlink remaining dotfiles" 	
	ln -s -f ~/dotfiles/vscode/settings.json $XDG_CONFIG_HOME/Code/User/settings.json

echo "Setting up Docker"
	# Add Docker's official GPG key:
	sudo apt-get update
	sudo apt-get install ca-certificates curl -y
	sudo install -m 0755 -d /etc/apt/keyrings
	sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
	sudo chmod a+r /etc/apt/keyrings/docker.asc

	# Add the repository to Apt sources:
	echo \
	  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
	  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
	  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
	sudo apt-get update
	sudo chmod 666 /var/run/docker.sock
	
 	sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

echo "Setting up Browser"
	sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
	echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
	sudo apt update
	sudo apt install brave-browser -y
	

echo "Remember to clean up files"
echo "Remember to change terminal font to JetBrains Mono nerd font"
echo "Remember to install tmux packages <prefix> + I"
echo "run sudo mysql"
echo "run ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'root';
