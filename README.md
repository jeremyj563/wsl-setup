# WSL Setup

## Synopsis
Ansible + PowerShell config for setting up Ubuntu development environments in WSL

## Initial Setup (first run only)

### Clone this repo
```
PS > git clone https://github.com/jeremyj563/wsl-setup.git && cd wsl-setup
```

### Configure `group_vars\all.yml`
```
PS wsl-setup> code .\group_vars\all.yml
```

### Add `Set-UbuntuConfig` cmdlet function to your PowerShell profile (optional)
```
PS wsl-setup> . .\scripts\Set-ProfileScript.ps1
```

## Usage

### Run `Set-UbuntuConfig` (can be ran from anywhere if dot sourced as in previous step)
```
PS > Set-UbuntuConfig -DistroName <distro-name> [-NewDistro] [-SetDefault]
```