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

### Add `Set-UbuntuConfig` to PowerShell profile (recommended)
```
PS wsl-setup> . .\scripts\Set-ProfileScript.ps1
```

## Usage

### Run `Set-UbuntuConfig`
```ps1
# Note: This command can be ran from anywhere if dot sourced as shown in initial setup

PS > Set-UbuntuConfig -DistroName <distro-name> [-NewDistro] [-SetDefault]
```