# Ansible managed

chmod 700 /home/wsl/.ssh
find /home/wsl/.ssh -type f -name '*.pub' -or -name 'authorized_keys' -or -name 'known_hosts' -exec chmod 644 {} \;
find /home/wsl/.ssh -type f -not -name '*.*' -not -name 'known_hosts' -not -name 'authorized_keys' -exec chmod 600 {} \;