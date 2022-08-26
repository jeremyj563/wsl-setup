# WSL Setup

## Synopsis
Ansible config for setting up Ubuntu development environments in WSL

## Instructions

### Clone this repo
```
> git clone https://github.com/jeremyj563/wsl-setup.git && cd wsl-setup
```

### Configure `group_vars\all.yml`
```
wsl-setup> code .\group_vars\all.yml
```

### Run the `Set-UbuntuConfig` PowerShell function
```
PS wsl-setup> . .\scripts\Set-UbuntuConfig.ps1
PS wsl-setup> Set-UbuntuConfig -DistroName <distro-name> [-ExistingDistro] [-SetDefault]
```