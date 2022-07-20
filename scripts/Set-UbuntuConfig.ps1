<#   
.SYNOPSIS
Function that provisions and configures a development environment on an Ubuntu distribution running in WSL
    
.DESCRIPTION 
- Downloads the Ubuntu WSL distro, installs it with wsl.exe, then uses Ansible to apply the configuration
- Alternatively an existing distro can be configured by passing the -ExistingDistro switch


.PARAMETER DistroName
[string] The name of the Ubuntu distribution to provision and configure

.PARAMETER LinuxUsername
[string] The non-root username to use for configuring the development environment (default is 'wsl')

.PARAMETER LinuxPassword
[string] The password for the non-root user being used to configure the development environment

.PARAMETER DistroUri
[string] Optional URI of the Ubuntu distribution to download and install

.PARAMETER DownloadPath
[string] Optional path of where to download the Ubuntu distribution

.PARAMETER InstallPath
[string] Optional path of where to store the Ubuntu Hyper-V hard disk files

.PARAMETER ExistingDistro
[switch] Optionally configure an already provisioned Ubuntu distribution matching DistroName

.INPUTS
None. You cannot pipe objects to Set-UbuntuConfig

.OUTPUTS
None.

.NOTES   
Name: Set-UbuntuConfig.ps1
Author: Jeremy Johnson
Date Created: 7-18-2022
Date Updated: 7-18-2022
Version: 1.0.0

.EXAMPLE
    PS > . .\Set-UbuntuConfig.ps1

.EXAMPLE
    PS > Set-UbuntuConfig -DistroName '[distro-name]' -DistroUri '[distro-uri]'

.EXAMPLE
    PS > Set-UbuntuConfig -n [name] -u [uri]

.EXAMPLE
    PS > Set-UbuntuConfig -DistroName '[distro-name]'

.EXAMPLE
    PS > Set-UbuntuConfig -d [name]

.EXAMPLE
    PS > Set-UbuntuConfig -DistroName '[distro-name]' -ExistingDistro

.EXAMPLE
    PS > Set-UbuntuConfig -n [name] -e
#>

function Set-UbuntuConfig {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [Alias('n')]
        [string] $DistroName,

        [Parameter(Mandatory=$false)]
        [Alias('u')]
        [string] $LinuxUsername = 'wsl',

        [Parameter(Mandatory=$true)]
        [Alias('p')]
        [string] $LinuxPassword,

        [Parameter(Mandatory=$false)]
        [Alias('u')]
        [string] $DistroUri = 'https://wsldownload.azureedge.net/Ubuntu.2020.424.0_x64.appx',

        [Parameter(Mandatory=$false)]
        [Alias('d')]
        [string] $DownloadPath = "$env:TEMP\wsl\Ubuntu.zip",

        [Parameter(Mandatory=$false)]
        [Alias('p')]
        [string] $InstallPath = "$env:USERPROFILE\wsl\Ubuntu",

        [Parameter(Mandatory=$false)]
        [Alias('e')]
        [switch] $ExistingDistro = $false
    )

    begin {
        function Get-UbuntuArchive {
            if (Test-Path -Path $DownloadPath) {
                Write-Host -Object "Ubuntu archive found at: $DownloadPath" -ForegroundColor Green
            } else {
                $downloadDir = Split-Path -Path $DownloadPath -Parent
                New-Item -Path $downloadDir -Type Directory -Force -ErrorAction SilentlyContinue
                Invoke-WebRequest -Uri $DistroUri -OutFile $DownloadPath -UseBasicParsing -ErrorAction Stop
            }
            $archive = Get-ChildItem -Path $DownloadPath
            return $archive
        }
        function Expand-UbuntuArchive {
            param (
                [object] $Archive
            )
            Expand-Archive -Path $Archive -DestinationPath $Archive.DirectoryName -Force -ErrorAction Stop
            $importFile = Join-Path -Path $Archive.DirectoryName -ChildPath 'install.tar.gz'
            return $importFile
        }
        function Import-UbuntuDistro {
            param (
                [object] $Archive
            )
            New-Item -Path $InstallPath -Type Directory -Force -ErrorAction SilentlyContinue | Out-Null
            $importFile = Expand-UbuntuArchive -Archive $Archive
            Start-Process -FilePath 'wsl.exe' -ArgumentList "--import $DistroName $InstallPath $importFile"
        }
        function Start-DistroBootstrap {
            Start-Process -FilePath wsl.exe -ArgumentList "--distribution $DistroName", "--user root", "--exec bash install-ansible.sh" -NoNewWindow -Wait
            Start-Process -FilePath wsl.exe -ArgumentList "--distribution $DistroName", "--user root", "--exec ansible-playbook playbook-wsl-user.yml -e ""linux_username=$LinuxUsername linux_password=$LinuxPassword""" -NoNewWindow -Wait
            Start-Process -FilePath wsl.exe -ArgumentList "--distribution $DistroName", "--user $LinuxUsername", "--exec ansible-galaxy install -r requirements.yml" -NoNewWindow -Wait
            Start-Process -FilePath wsl.exe -ArgumentList "--terminate $DistroName" -NoNewWindow -Wait
        }
        function Start-DistroConfig {
            Start-Process -FilePath wsl.exe -ArgumentList "--distribution $DistroName", "--user $LinuxUser", "--exec ansible-playbook playbook-wsl-config.yml -e ""linux_username=$LinuxUsername linux_password=$LinuxPassword""" -NoNewWindow -Wait
        }
    }

    process {
        if (-Not $ExistingDistro) {
            $archive = Get-UbuntuArchive
            Import-UbuntuDistro -Archive $archive
            Start-DistroBootstrap
        }
        Start-DistroConfig
    }

    end {
    }
}
