# CC Dotfiles
Quick install command
```Shell
read -rp "SSID: " s; read -rsp "Password: " p; echo
sudo iwctl --passphrase "$p" station wlan0 connect "$s"
sudo pacman -S --needed git
git clone https://github.com/CameronConroy/CC-Dotfiles.git ~/dotfiles
bash ~/dotfiles/.install.sh
```
