# ANSIBLE MANAGED FILE - wsl-setup

. "$HOME/.profile"

for f in ~/.bash_profile.d/*.sh; do source $f; done
