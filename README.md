# WSL Setup

## Synopsis
Ansible config for setting up an Ubuntu development environment in WSL

## Quick Start
```ps1
# 1. Clone this repo
PS > git clone https://github.com/jeremyj563/wsl-setup.git .\wsl-setup && cd $_

# 2. Set vars in group_vars/all.yml (optional)

# 3. Source the config script
PS wsl-setup> . .\scripts\Set-UbuntuConfig.ps1

# 4. Run the config script
PS wsl-setup> Set-UbuntuConfig -DistroName <distro-name>
```