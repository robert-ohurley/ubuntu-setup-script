#!/bin/sh


if [[ $EUID -ne 0 ]]; then
   	echo "This script must be run as root" 
   	exit 1
fi


setHomeDir() {
	echo "Enter home dir e.g. /home/rojet "
	read homedir
	export HOME=$homedir
}
setHomeDir


makeDirIfNotExist() {
	 if [[ ! -d $1 ]]; then
	 	mkdir $1
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
	apt-get update && sudo apt-get upgrade -y


#Git supports XDG out of the box.
echo "Installing Git and Clone Dotfiles"
	sudo apt install git-all -y
	makeDirIfNotExist "$XDG_CONFIG_HOME/git"
	git clone git@github.com:robert-ohurley/dotfiles.git $HOME
	ln -s -f $HOME/dotfiles/git/config $XDG_CONFIG_HOME/git
	

echo "Installing Packages"
	sudo apt install curl
	sudo snap install --classic code
	sudo apt install vlc -y 
	sudo apt install tmux
	sudo apt-get install unzip
	sudo apt install gnome-tweaks
	sudo snap install discord
	

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
	ln -s -f $HOME/dotfiles/zsh/.zshrc $XDG_CONFIG_HOME/zsh/.zshrc
	rm -rf $XDG_CONFIG_HOME/.oh-my-zsh/custom 
	ln -s -f ~/dotfiles/zsh/custom $XDG_CONFIG_HOME/.oh-my-zsh/custom
	git clone https://github.com/zsh-users/zsh-autosuggestions $XDG_CONFIG_HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions

	
echo "Installing Node Version Manager and Node v20.12.1"
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
	export NVM_DIR="$HOME/.local/share/nvm"
	[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  #This loads nvm
	[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  #nvm bash_completion
	nvm install 20
	ln -s -f $HOME/dotfiles/npm/npmrc $XDG_CONFIG_HOME/npm/npmrc


echo "Setting up Nvim"
	cd $HOME/downloads	
	curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
	sudo rm -rf /opt/nvim
	sudo tar -C /opt -xzf nvim-linux64.tar.gz

	
echo "Setting up tmux"
	git clone https://github.com/tmux-plugins/tpm $XDG_CONFIG_HOME/.tmux/plugins/tpm
	ln -s -f $HOME/dotfiles/tmux $XDG_CONFIG_HOME/tmux
	tmux source $XDG_CONFIG_HOME/.tmux/tmux.conf

		
echo "Setting up GithubCLI and authorizing" 
	sudo mkdir -p -m 755 /etc/apt/keyrings && wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null && sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null && sudo apt update && sudo apt install gh -y
	gh auth login


echo "Installing Mysql"
	apt install mysql-server -y
	sudo snap install mysql-workbench-community			
	 	 	
	 			
echo "Installing Golang"
	cd $HOME/downloads
	curl -OL https://go.dev/dl/go1.22.2.linux-amd64.tar.gz
	sudo tar -C /usr/local -xvf go1.22.2.linux-amd64.tar.gz
	cd $HOME	

	
echo "Nerd Font"
	cd $HOME/downloads
	sudo curl -OL https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.0/JetBrainsMono.zip
	unzip JetBrainsMono.zip -d $XDG_DATA_HOME/fonts/
	fc-cache $XDG_DATA_HOME/fonts
	rm JetBrainsMono.zip
	
	
echo "Symlink remaining dotfiles" 	
	ln -s -f ~/dotfiles/vscode/settings.json $XDG_CONFIG_HOME/Code/User/settings.json


echo "Setting up Docker"
	cd $HOME/downloads
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
	
echo "Tidy up"
	sudo touch /etc/sudoers.d/admin_flag
	sudo chmod 666 /etc/sudoers.d/admin_flag
	echo "Defaults \!admin_flag" >> /etc/sudoers.d/admin_flag
	pkexec chmod 0755 /etc/sudoers.d/admin_flag

echo "Clean up files"
	rm $HOME/downloads/go1.22.2.linux-amd64.tar.gz
	rm $HOME/downloads/nvim-linux64.tar.gz
	rm $HOME/gcm-linux_amd64.2.4.1.deb
	rm $HOME/get-docker.sh

