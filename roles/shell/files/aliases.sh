## ANSIBLE MANAGED FILE: wsl-setup

# general
alias reload!='. ~/.bashrc'
alias ..='cd ..'
alias ...='cd ../../'
alias .2='cd ../../'
alias .3='cd ../../../'
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

# aws
alias login-awsprofile='python3 $REPOS/scripts/py/Py3AWSTokenRequest.py -e $AWS_PROFILE'
alias a='awsv2'
alias aws='awsv2'
alias apls='aws configure list-profiles'
alias apu='export AWS_PROFILE='
alias apc='echo $AWS_PROFILE'
alias api='aws sts get-caller-identity'

# kubectl
alias kctx='kubectl config use-context $(kubectl config get-contexts -o name | fzf --height=10 --prompt="Kubernetes Context> ") > /dev/null 2>&1'
alias kcns='kubectl config set-context --current --namespace "$(kubectl get ns -o name | fzf -d/ --with-nth=2 | cut -d/ -f2)"'
alias kcred='FZF_KUBECTL_USER=$(kubectl config view --template="{{ range .users }}{{ printf \"%s\n\" .name }}{{ end }}" | fzf --height=10 --prompt="Kubernetes User> ") && read -p "token: " FZF_KUBECTL_TOKEN && kubectl config set-credentials $FZF_KUBECTL_USER --token=$FZF_KUBECTL_TOKEN'

# pyenv
alias pyls='pyenv virtualenvs'
alias pyc='pyenv virtualenv'
alias pya='pyenv activate'
alias pyd='pyenv deactivate'

# tmux
alias start-tmux='npx -y zx $REPOS/scripts/js/start-tmux.mjs'
