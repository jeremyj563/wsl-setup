# ANSIBLE MANAGED FILE - wsl-setup

chmod 700 "$HOME/.ssh" 2>/dev/null
find "$HOME/.ssh" -type f -name '*.pub' -or -name 'authorized_keys' -or -name 'known_hosts' -exec chmod 644 {} \;
find "$HOME/.ssh" -type f -not -name '*.*' -not -name 'known_hosts' -not -name 'authorized_keys' -exec chmod 600 {} \;
