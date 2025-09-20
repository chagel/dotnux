fish_add_path $HOME/Dotfiles/scripts
fish_add_path $HOME/.local/bin

abbr install sudo pacman -S
abbr uninstall sudo pacman -Rns
abbr upgrade-system sudo pacman -Syu
abbr upgrade-aur yay -Syu --devel --timeupdate
abbr nap systemctl suspend

# API Keys
function load_api_keys --description "Load API keys from password store(1Password)"
    if type -q pass
        set -gx OPENAI_API_KEY (op item get cfx7ecmfy3pc7a3zcc7vr2fmhe --reveal --fields credential || echo "")
        set -gx ANTHROPIC_API_KEY (op item get kyapm6qumqcvjzzmtqvvypxmi4 --reveal --fields credential || echo "")
    end
end

if status is-login; and test -z "$DISPLAY"; and test (tty) = "/dev/tty1"
  exec Hyprland
end
