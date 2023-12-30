#!/bin/bash

sudo apt update -y
function log(){
	log_dir=$HOME/.initial_setuup.log
	touch $log
 	echo $@ | tee -a $log_dir
}

log "==================================================" 
log "installing utilities ..."
sudo apt install -y git
sudo apt install -y ranger
sudo apt install -y neovim
sudo apt install -y fzf
sudo apt install -y openssh-server
log "utilities installation completed !!!"
log "=================================================="

log "=================================================="
log "cloning dotfiles"
git clone --bare https://github.com/ashmin78/dotfiles.git $HOME/dotfiles
alias dotfile="/usr/bin/git --git-dir=$HOME/dotfiles --work-tree=$HOME"
dotfile checkout
if [ $? = 0 ]; then
	log "clone sucessful !!";
else
	log "Existing files found. Backing up pre-existing dot files.";
	# mkdir -p $HOME/.dotfiles_bkp
	dotfile checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} dirname {} | uniq | xargs -I{} mkdir -p $HOME/.dotfiles_bkp/{}
	dotfile checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} $HOME/.dotfiles_bkp/{}
	log "clone sucessful !!";
fi;
dotfile checkout
log "=================================================="

log "=================================================="
log "installing starship ..."
curl -sS https://starship.rs/install.sh | sh
log "starship installation completed !!!"
log "=================================================="

log "=================================================="
log "installing brave browser ..."
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
 "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update -y
sudo apt install brave-browser -y
log "brave browser installation completed !!!"
log "=================================================="

log "=================================================="
log "installing vscode ..."
sudo apt-get install wget gpg -y
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
sudo sh -c ' "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg
sudo apt install apt-transport-https -y
sudo apt update -y
sudo apt install code -
log "vscode installation completed !!!"
log "=================================================="

log "=================================================="
log "installing miniconda ..."
mkdir -p ~/miniconda3
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh
bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
rm -rf ~/miniconda3/miniconda.sh
log "miniconda installation completed !!!"
log "=================================================="

log "=================================================="
log "running post installation work ..."
# ~/miniconda3/bin/conda init bash
#  'eval "$(starship init bash)"' >> $HOME/.bashrc
echo 'alias dotfile="/usr/bin/git --git-dir=$HOME/dotfiles --work-tree=$HOME"' >> $HOME/.bashrc
