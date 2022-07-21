# WSL Setup

## Synopsis
Ansible config for setting up an Ubuntu development environment in WSL

## Quick Start

### Clone this repo and configure **group_vars/all.yml**
```
PS > git clone https://github.com/jeremyj563/wsl-setup.git .\wsl-setup && cd $_
```

### Run the PowerShell function
```
PS wsl-setup> . .\scripts\Set-UbuntuConfig.ps1
PS wsl-setup> Set-UbuntuConfig -DistroName <distro-name>
```