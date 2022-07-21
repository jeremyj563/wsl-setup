# WSL Setup

## Synopsis
Ansible config for setting up an Ubuntu development environment in WSL

## Quick Start
```ps1
# 1. Clone this repo and configure group_vars/all.yml
PS > git clone https://github.com/jeremyj563/wsl-setup.git .\wsl-setup && cd $_

# 2. Source the config script
PS wsl-setup> . .\scripts\Set-UbuntuConfig.ps1

# 3. Run the config script
PS wsl-setup> Set-UbuntuConfig -DistroName <distro-name>
```