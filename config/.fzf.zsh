# Setup fzf
# ---------
if [[ ! "$PATH" == */home/chenqs/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/chenqs/.fzf/bin"
fi

source <(fzf --zsh)
