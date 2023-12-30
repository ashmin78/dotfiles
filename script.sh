sudo apt update -y

tmp_dir='/tmp/temp_install'
mkdir $tmp_dir
cd $tmp_dir

echo "=================================================="
echo "installing git ..."
sudo apt install git -y
echo "git installation completed !!!"
echo "=================================================="

echo "=================================================="
echo "cloning dotfiles"
git clone --bare https://github.com/ashmin78/dotfiles.git $HOME/dotfiles
function dotfile{
	/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME $@
}
dotfile checkout
if [ $? = 0 ]; then
	echo "clone sucessful !!";
else
	echo "Existing files found. Backing up pre-existing dot files.";
	mkdir -p $HOME/.dotfiles_bkp
	dotfile checkout 2>$1 | egrep "\s+\." | awk {'print $1'} | xarg -I{} mv {} $HOME/.dotfiles_bkp/{}
	echo "clone sucessful !!";
fi;
dotfile checkout
echo "=================================================="

echo "=================================================="
echo "installing starship ..."
curl -sS https://starship.rs/install.sh | sh
echo "starship installation completed !!!"
echo "=================================================="

echo "=================================================="
echo "installing brave browser ..."
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update
sudo apt install brave-browser
echo "brave browser installation completed !!!"
echo "=================================================="

echo "=================================================="
echo "installing vscode ..."
sudo apt-get install wget gpg
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg
sudo apt install apt-transport-https
sudo apt update
sudo apt install code
echo "vscode installation completed !!!"
echo "=================================================="

echo "=================================================="
echo "installing miniconda ..."
mkdir -p ~/miniconda3
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh
bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
rm -rf ~/miniconda3/miniconda.sh
echo "miniconda installation completed !!!"
echo "=================================================="

echo "=================================================="
echo "running post installation work ..."
# ~/miniconda3/bin/conda init bash
# echo 'eval "$(starship init bash)"' >> $HOME/.bashrc
