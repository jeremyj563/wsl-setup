<#   
.SYNOPSIS
Function that provisions and configures a development environment on an Ubuntu distribution in WSL
    
.DESCRIPTION 
* Configures an existing Ubuntu WSL distribution using wsl.exe, then uses Ansible to apply the configuration
* Pass the -NewDistro switch to provision and configure a new Ubuntu distribution

.PARAMETER DistroName
[string] Optional name of the distribution to provision and configure (default: Ubuntu-K8s)

.PARAMETER LinuxCredential
[PSCredential] The non-root credential to create and use for configuring the user environment

.PARAMETER DistroUri
[string] Optional URI of the distribution archive to download and provision

.PARAMETER DistroSha
[string] Optional SHA256 hash of the distribution archive to provision

.PARAMETER DownloadPath
[string] Optional path of where to download the distribution archive to

.PARAMETER InstallPath
[string] Optional path of where to store the distribution's Hyper-V hard disk files

.PARAMETER NewDistro
[switch] Provision and configure a new distribution

.PARAMETER BootstrapOnly
[switch] Run the bootstrap process then skip configuring the distribution

.PARAMETER ForceBootstrap
[switch] Run the bootstrap process on an already provisioned distribution

.PARAMETER SetDefault
[switch] Set the distribution as default once configured

.PARAMETER NoTerminate
[switch] Do not terminate distribution after applying the configuration

.INPUTS
None. You cannot pipe objects to Set-UbuntuConfig

.OUTPUTS
None.

.NOTES   
Name: Set-UbuntuConfig.ps1
Author: Jeremy Johnson
Date Created: 7-18-2022
Date Updated: 11-13-2023
Version: 1.1.7

.LINK
Official WSL distribution download links:
- https://docs.microsoft.com/en-us/windows/wsl/install-manual#step-6---install-your-linux-distribution-of-choice
- https://github.com/microsoft/WSL/blob/master/distributions/DistributionInfo.json

.EXAMPLE
    PS > . .\Set-UbuntuConfig.ps1

.EXAMPLE
    PS > Set-UbuntuConfig -DistroName <distro-name> -DistroUri <distro-uri> -DistroSha <distro-sha>
    PS > Set-UbuntuConfig -d <name> -u <uri> -h <sha>

.EXAMPLE
    PS > Set-UbuntuConfig -DistroName <distro-name>
    PS > Set-UbuntuConfig -d <name>

.EXAMPLE
    PS > Set-UbuntuConfig -DistroName <distro-name> -NewDistro
    PS > Set-UbuntuConfig -d <name> -n

.EXAMPLE
    PS > Set-UbuntuConfig -DistroName <distro-name> -ForceBootstrap
    PS > Set-UbuntuConfig -d <name> -f
#>

function Set-UbuntuConfig {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false)]
        [Alias('d')]
        [string] $DistroName = 'Ubuntu-K8s',

        [Parameter(Mandatory=$true)]
        [Alias('c')]
        [PSCredential] $LinuxCredential,

        [Parameter(Mandatory=$false)]
        [Alias('u')]
        [string] $DistroUri = 'https://wslstorestorage.blob.core.windows.net/wslblob/Ubuntu2204LTS-230518_x64.appx',

        [Parameter(Mandatory=$false)]
        [Alias('h')]
        [string] $DistroSha = '6A723A25AC7A072238FAC386A8AB3D425B84F9FD806F01104D4D0C4D5E5F42FE',

        [Parameter(Mandatory=$false)]
        [Alias('l')]
        [string] $DownloadPath = "$env:TEMP\wsl\Ubuntu.zip",

        [Parameter(Mandatory=$false)]
        [Alias('p')]
        [string] $InstallPath = "$env:USERPROFILE\wsl\$DistroName",

        [Parameter(Mandatory=$false)]
        [Alias('n')]
        [switch] $NewDistro = $false,

        [Parameter(Mandatory=$false)]
        [Alias('b')]
        [switch] $BootstrapOnly = $false,

        [Parameter(Mandatory=$false)]
        [Alias('f')]
        [switch] $ForceBootstrap = $false,

        [Parameter(Mandatory=$false)]
        [Alias('s')]
        [switch] $SetDefault = $false,

        [Parameter(Mandatory=$false)]
        [Alias('t')]
        [switch] $NoTerminate = $false
    )

    begin {
        function Test-LastExitCode {
            param (
                [string] $Message
            )
            if (-not $?) {
                throw "Exit code: $LASTEXITCODE`n$Message"
            }
        }
        function Set-ScriptVars {
            $script:cred = $LinuxCredential.GetNetworkCredential()
            $script:root = wsl.exe -d $DistroName -u root -e wslpath $PSScriptRoot
            Test-LastExitCode -Message $script:root
        }
        function Test-DistroSha {
            $fileHash = Get-FileHash -Path $DownloadPath -Algorithm SHA256
            $sha = $fileHash.Hash
            if (-not ($sha -eq $DistroSha)) {
                Write-Warning -Message "Distro SHA mismatch`n`nExpected: $DistroSha`nGot: $sha`n"
                return $false
            }
            return $true
        }
        function Test-UbuntuArchive {
            if (Test-Path -Path $DownloadPath) {
                $validSha = Test-DistroSha
                return $validSha
            }
            return $false
        }
        function Get-UbuntuArchive {
            if (-not (Test-UbuntuArchive)) {
                Write-Host -Object "Downloading archive to: $DownloadPath`n" -ForegroundColor Yellow
                $downloadDir = Split-Path -Path $DownloadPath -Parent
                New-Item -Path $downloadDir -Type Directory -Force -ErrorAction SilentlyContinue
                Invoke-WebRequest -Uri $DistroUri -OutFile $DownloadPath -UseBasicParsing -ErrorAction Stop
            }
            $archive = Get-Item -LiteralPath $DownloadPath
            return $archive
        }
        function Expand-UbuntuArchive {
            param (
                [object] $Archive
            )
            Expand-Archive -Path $Archive -DestinationPath $Archive.Directory -Force -ErrorAction Stop
            $importFile = Join-Path -Path $Archive.Directory -ChildPath 'install.tar.gz'
            return $importFile
        }
        function Import-UbuntuDistro {
            param (
                [object] $Archive
            )
            if (Test-UbuntuArchive) {
                Write-Host -Object "Archive found at: $DownloadPath`n" -ForegroundColor Green
                Write-Host -Object "Importing archive to: $InstallPath`n" -ForegroundColor Yellow
                New-Item -Path $InstallPath -Type Directory -Force -ErrorAction SilentlyContinue | Out-Null
                $importFile = Expand-UbuntuArchive -Archive $Archive
                $result = wsl.exe --import $DistroName $InstallPath $importFile
                Test-LastExitCode -Message $result
            }
        }
        function Stop-UbuntuDistro {
            if (-not $NoTerminate) {
                Start-Process -FilePath wsl.exe -ArgumentList "--terminate $DistroName" -NoNewWindow -Wait
            }
        }
        function Test-ExistingDistro {
            $distros = wsl.exe --list
            $exists = $DistroName -in $distros
            if ((-not $ForceBootstrap) -and $exists) {
                throw "Distro named '$DistroName' already exists! Use -ForceBootstrap to override"
            }
        }
        function Start-DistroBootstrap {
            Set-ScriptVars
            Start-Process -FilePath wsl.exe -ArgumentList "--distribution $DistroName", "--user root", "--exec ""$script:root/install-ansible.sh""" -NoNewWindow -Wait
            Start-Process -FilePath wsl.exe -ArgumentList "--distribution $DistroName", "--user root", "--exec ansible-playbook ""$script:root/../playbook-wsl-bootstrap.yml"" -e ""linux_username=$($script:cred.UserName) linux_password=$($script:cred.Password)""" -NoNewWindow -Wait
            Stop-UbuntuDistro
        }
        function Start-DistroConfig {
            Set-ScriptVars
            Start-Process -FilePath wsl.exe -ArgumentList "--distribution $DistroName", "--user $($script:cred.UserName)", "--exec ansible-galaxy install -r ""$script:root/../requirements.yml""" -NoNewWindow -Wait
            Start-Process -FilePath wsl.exe -ArgumentList "--distribution $DistroName", "--user $($script:cred.UserName)", "--exec ansible-playbook ""$script:root/../playbook-wsl-config.yml"" -e ""linux_username=$($script:cred.UserName) linux_password=$($script:cred.Password)""" -NoNewWindow -Wait
            Stop-UbuntuDistro
        }
        function New-UbuntuDistro {
            $archiveName = Split-Path $DownloadPath -Leaf
            $archive = Get-UbuntuArchive | Where-Object -Property Name -EQ $archiveName
            Import-UbuntuDistro -Archive $archive
        }
        function Set-DefaultDistro {
            Write-Host -Object "Setting distro '$DistroName' as default`n" -ForegroundColor Yellow
            Start-Process -FilePath wsl.exe -ArgumentList "--set-default $DistroName" -NoNewWindow -Wait
        }
        function Set-Environment {
            $env:WSLENV = "HTTP_PROXY:HTTPS_PROXY:FTP_PROXY:NO_PROXY"
        }
    }

    process {
        if ($NewDistro) {
            New-UbuntuDistro
            Start-DistroBootstrap
        } elseif ($ForceBootstrap) {
            Test-ExistingDistro
            Start-DistroBootstrap
        }
        if (-not $BootstrapOnly) {
            Start-DistroConfig
        }
    }

    end {
        if ($SetDefault) {
            Set-DefaultDistro
        }
    }
}
