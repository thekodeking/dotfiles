# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# History settings
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s histappend
shopt -s checkwinsize


if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR='vim'
  else
    export EDITOR='nvim'
fi


# Set terminal title
case "$TERM" in
    xterm*|rxvt*)
        PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
        ;;
    *)
        ;;
esac

# Enable color support for ls and add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Some ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Load bash aliases
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Enable programmable completion features
if ! shopt -oq posix; then
  for completion_file in /usr/share/bash-completion/bash_completion /etc/bash_completion; do
    [ -f "$completion_file" ] && . "$completion_file"
  done
fi

export ZDOTDIR=$HOME/.config/zsh

download() {
    local url="$1"
    local output_file="$2"

    if [ -z "$output_file" ]; then
        output_file=$(basename "$url")
    fi

    if command -v wget &> /dev/null; then
        wget -q --show-progress --progress=bar:force --no-check-certificate -O "$output_file" "$url" 2>&1
    else
        echo "Error: wget not found. Please install wget to use this function." >&2
        return 1
    fi
}


# Load zoxide
eval "$(zoxide init bash)"
eval "$(direnv hook bash)"
