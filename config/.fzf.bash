# Setup fzf
# ---------
if [[ ! "$PATH" == */home/$(whoami)/.fzf/bin* ]]; then
	PATH="${PATH:+${PATH}:}/home/$(whoami)/.fzf/bin"
fi

eval "$(fzf --bash)"
