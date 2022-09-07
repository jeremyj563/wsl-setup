# WSL Setup

## Synopsis
Ansible + PowerShell config for setting up Ubuntu development environments in WSL

## Instructions

### Clone this repo
```
PS > git clone https://github.com/jeremyj563/wsl-setup.git && cd wsl-setup
```

### Configure `group_vars\all.yml`
```
PS wsl-setup> code .\group_vars\all.yml
```

### Add the `Set-UbuntuConfig` Cmdlet function to your PowerShell Profile script
```
PS wsl-setup> .\scripts\Set-ProfileScript.ps1
```

### Run the `Set-UbuntuConfig` function
```
PS wsl-setup> Set-UbuntuConfig -DistroName <distro-name> [-NewDistro] [-SetDefault]
```