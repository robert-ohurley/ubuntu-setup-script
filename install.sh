#!/bin/bash

source ./utils.sh

if [ ! -n $HOME ]; then
	setHomePath
fi


#Setup XDG variables
export XDG_DATA_HOME=$HOME/.local/share
export XDG_CACHE_HOME=$HOME/.cache
export XDG_CONFIG_HOME=$HOME/.config
export XDG_PICTURES_DIR=$HOME/picures
export XDG_STATE_HOME=$HOME/.local/state
export NVM_DIR="$XDG_DATA_HOME/nvm"
export HISTFILE="$XDG_STATE_HOME"/zsh/history
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME"/npm/npmrc


#Create directories
makeDirIfNotExist $HOME/Projects
makeDirIfNotExist $HOME/Programming
makeDirIfNotExist $HOME/Uni
makeDirIfNotExist $XDG_DATA_HOME/fonts
makeDirIfNotExist $HOME/.config/wget
makeDirIfNotExist $XDG_DATA_HOME/nvm
makeDirIfNotExist $XDG_STATE_HOME
makeDirIfNotExist $XDG_CACHE_HOME/zsh
makeDirIfNotExist $XDG_CACHE_HOME/starship
makeDirIfNotExist $XDG_CONFIG_HOME/git
makeDirIfNotExist $XDG_CONFIG_HOME/zsh
makeDirIfNotExist $XDG_CONFIG_HOME/npm
makeDirIfNotExist $XDG_CONFIG_HOME/alacritty
continue?



#Update
sudo apt-get update && sudo apt-get upgrade -y
continue?

#Install Tools/Utilities
sudo apt install git neovim tmux vlc curl eza mysql-server gnome-tweaks stow bear jq  -y
sudo apt-get install ripgrep make gcc unzip unzip fzf
curl -sS https://starship.rs/install.sh | sh
sudo apt-get update && sudo apt-get upgrade -y
continue?

sudo snap install btop

#yazi
apt install ffmpeg 7zip jq poppler-utils fd-find ripgrep fzf zoxide imagemagick
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup update
cargo install --locked yazi-fm yazi-cli




#Install misc deps
	#Bear
apt-get install python cmake pkg-config
apt-get install libfmt-dev libspdlog-dev nlohmann-json3-dev \
                libgrpc++-dev protobuf-compiler-grpc libssl-dev


#Clone dotfiles
git clone https://github.com/robert-ohurley/dotfiles.git $HOME/dotfiles
continue?

# Ruby
sudo apt-get install ruby-full

sudo apt instal sshfs

#Zshell
chsh -s $(which zsh)
sudo apt install zsh -y
echo "if [ \"${ZSH_VERSION:-unset}\" = \"unset\" ] ; then
	export SHELL=/bin/zsh
	exec /bin/zsh -l
fi" >> $HOME/.bashrc
sudo chmod 666 /etc/zsh/zshenv
echo "export ZDOTDIR="$XDG_CONFIG_HOME"/zsh" >> /etc/zsh/zshenv
continue?


#Alacritty
cd $HOME/Downloads
git clone https://github.com/alacritty/alacritty.git
cd $HOME/Downloads/alacritty
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
export PATH=$HOME/.cargo/bin:$PATH
export PATH=/usr/local/bin/:$PATH
rustup override set stable
rustup update stable
sudo apt install cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3
cargo build --release
sudo tic -xe alacritty,alacritty-direct extra/alacritty.info
sudo cp target/release/alacritty /usr/local/bin # or anywhere else in $PATH
sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
sudo desktop-file-install extra/linux/Alacritty.desktop
sudo update-desktop-database
continue?


#I can finally get rid of NVM, use FNM instead and maybe alias it to nvm?
curl -fsSL https://fnm.vercel.app/install | bash
fnm install 22.5.1
continue?


#TPM
git clone https://github.com/tmux-plugins/tpm $XDG_CONFIG_HOME/tmux/plugins/tpm
continue?


#Golang <3
cd $HOME/Downloads
curl -OL https://go.dev/dl/go1.22.3.linux-amd64.tar.gz
sudo tar -C /usr/local -xvf go1.22.3.linux-amd64.tar.gz
continue?


#Nerd Fonts
cd $HOME/Downloads
sudo curl -OL https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.0/JetBrainsMono.zip
unzip JetBrainsMono.zip -d $XDG_DATA_HOME/fonts/
fc-cache $XDG_DATA_HOME/fonts
continue?


# Docker
sudo apt-get update
sudo apt-get install ca-certificates curl -y
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo chmod 666 /var/run/docker.sock
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
continue?


#Brave Browser
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update
sudo apt install brave-browser -y
continue?


#Stow dotfiles
cd $HOME/dotfiles/
stow -v -t $HOME/.config config
continue?


#Additional configuration
curl -LO --output-dir ~/.config/alacritty https://github.com/catppuccin/alacritty/raw/main/catppuccin-mocha.toml
continue?


#Cleanup
rm $HOME/Downloads/JetBrainsMono.zip
rm $HOME/Downloads/go1.22.3.linux-amd64.tar.gz
continue?


#Notes to self.
echo "Remember to install tmux packages <prefix> + I"


#Run -> ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'root';
