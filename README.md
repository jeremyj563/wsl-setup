# WSL Setup

## Synopsis
Ansible config for setting up Ubuntu development environments in WSL

## Instructions

### Clone this repo and configure **group_vars\all.yml**
```
> git clone https://github.com/jeremyj563/wsl-setup.git && cd wsl-setup
> notepad .\group_vars\all.yml
```

### Run the PowerShell function
```
PS wsl-setup> . .\scripts\Set-UbuntuConfig.ps1
PS wsl-setup> Set-UbuntuConfig -DistroName <distro-name> [-ExistingDistro] [-SetDefault]
```