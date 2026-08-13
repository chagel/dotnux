fish_add_path $HOME/Dotfiles/scripts
fish_add_path $HOME/.local/bin
fish_add_path $HOME/go/bin

abbr install sudo pacman -S
abbr uninstall sudo pacman -Rns
abbr upgrade-system sudo pacman -Syu
abbr upgrade-aur yay -Syu
abbr nap systemctl suspend

# Keys come from 1Password instead of llm's own keys.json, which is deleted.
# A function, not a script: ~/.local/bin/llm comes first on PATH, so only a
# function shadows it. set -lx keeps the keys out of the shell environment.
function llm --description "llm with API keys read from 1Password"
    set -lx OPENAI_API_KEY (mail-pass 'op://Private/cfx7ecmfy3pc7a3zcc7vr2fmhe/apikey')
    set -lx ANTHROPIC_API_KEY (mail-pass 'op://Private/kyapm6qumqcvjzzmtqvvypxmi4/apikey')
    command llm $argv
end

if status is-login; and test -z "$DISPLAY"; and test (tty) = "/dev/tty1"
  # Kaby Lake UHD 620 + dock: mesa hands aquamarine Y_TILED_CCS buffers that the
  # kernel rejects on the dock's DP connector, and Hyprland segfaults in
  # SDRMConnector::releaseStashedCommit while adding the monitor. Force linear.
  set -gx AQ_NO_MODIFIERS 1
  exec start-hyprland
end
