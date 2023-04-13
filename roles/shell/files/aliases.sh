# ANSIBLE MANAGED FILE - wsl-setup

alias reload!='. ~/.bashrc'
alias ..='cd ..'
alias ...='cd ../../../'
alias ....='cd ../../../../'
alias .....='cd ../../../../'
alias .4='cd ../../../../'
alias .5='cd ../../../../..'
alias l.='ls -d .* --color=auto'
alias l='ls -CF'
alias ls='ls --color=auto'
alias ll='ls -lah'
alias la='ls -A'
alias grep='grep --color=auto'
alias pubkey='cat ~/.ssh/id_ed25519.pub'
alias c='clear'
alias statc='stat -c %a'
alias psw='source $HOME/source/repos.personal/jeremyj563/proxy-switcher/proxy-switcher.sh'
alias proxy_on='psw $PROXY'
alias proxy_off='psw'
alias ports='netstat -tulanp'
alias upgrade='sudo apt update && sudo apt full-upgrade'
