# WSL Setup

## Synopsis
Ansible config for setting up Ubuntu development environments in WSL

## Provision a New Distribution

### Clone this repo and configure **group_vars/all.yml**
```
PS > git clone https://github.com/jeremyj563/wsl-setup.git && cd wsl-setup
```

### Run the PowerShell function
```
PS wsl-setup> . .\scripts\Set-UbuntuConfig.ps1
PS wsl-setup> Set-UbuntuConfig -DistroName <distro-name>
```

## Configure an Existing Distribution

### Run the PowerShell function passing the -ExistingDistro switch
```
PS wsl-setup> . .\scripts\Set-UbuntuConfig.ps1
PS wsl-setup> Set-UbuntuConfig -DistroName <distro-name> -ExistingDistro
```