fish_add_path $HOME/Dotfiles/scripts
abbr install sudo pacman -S
abbr uninstall sudo pacman -Rns
abbr upgrade-system sudo pacman -Syu
abbr upgrade-aur yay -Syu --devel --timeupdate
abbr nap systemctl suspend

if status is-login; and test -z "$DISPLAY"; and test (tty) = "/dev/tty1"
  exec Hyprland
end
