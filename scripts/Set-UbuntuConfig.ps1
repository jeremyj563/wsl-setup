<#   
.SYNOPSIS
Function that provisions and configures a development environment on an Ubuntu distribution running in WSL
    
.DESCRIPTION 
- Downloads the Ubuntu WSL distro, installs it with wsl.exe, then uses Ansible to apply the configuration
- Alternatively an existing distro can be configured by passing the -ExistingDistro switch

.PARAMETER DistroName
[string] The name of the distribution to provision and configure

.PARAMETER LinuxCredential
[PSCredential] The non-root credential to create and use for configuring the user environment

.PARAMETER DistroUri
[string] Optional URI of the distribution archive to download and install

.PARAMETER DistroSha
[string] Optional SHA256 hash of the distribution archive to install

.PARAMETER DownloadPath
[string] Optional path of where to download the distribution archive to

.PARAMETER InstallPath
[string] Optional path of where to store the distribution's Hyper-V hard disk files

.PARAMETER ExistingDistro
[switch] Configure an already existing distribution (matched on DistroName)

.PARAMETER ForceBootstrap
[switch] Run the bootstrap process on an already provisioned distribution

.PARAMETER SetDefault
[switch] Set the distribution as default once configured

.INPUTS
None. You cannot pipe objects to Set-UbuntuConfig

.OUTPUTS
None.

.NOTES   
Name: Set-UbuntuConfig.ps1
Author: Jeremy Johnson
Date Created: 7-18-2022
Date Updated: 8-26-2022
Version: 1.0.4

.EXAMPLE
    PS > . .\Set-UbuntuConfig.ps1

.EXAMPLE
    PS > Set-UbuntuConfig -DistroName '[distro-name]' -DistroUri '[distro-uri]'

.EXAMPLE
    PS > Set-UbuntuConfig -d [name] -u [uri]

.EXAMPLE
    PS > Set-UbuntuConfig -DistroName '[distro-name]'

.EXAMPLE
    PS > Set-UbuntuConfig -d [name]

.EXAMPLE
    PS > Set-UbuntuConfig -DistroName '[distro-name]' -ExistingDistro

    .EXAMPLE
    PS > Set-UbuntuConfig -d [name] -e
#>

function Set-UbuntuConfig {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [Alias('d')]
        [string] $DistroName,

        [Parameter(Mandatory=$true)]
        [Alias('c')]
        [PSCredential] $LinuxCredential,

        [Parameter(Mandatory=$false)]
        [Alias('u')]
        [string] $DistroUri = 'https://wsldownload.azureedge.net/Ubuntu.2020.424.0_x64.appx',

        [Parameter(Mandatory=$false)]
        [Alias('s')]
        [string] $DistroSha = '5FBD489AC156279E0D6E3448E0070C3E3DDF3A062E14E60CAAA2C68BE78E0130',

        [Parameter(Mandatory=$false)]
        [string] $DownloadPath = "$env:TEMP\wsl\Ubuntu.zip",

        [Parameter(Mandatory=$false)]
        [Alias('p')]
        [string] $InstallPath = "$env:USERPROFILE\wsl\$DistroName",

        [Parameter(Mandatory=$false)]
        [Alias('e')]
        [switch] $ExistingDistro = $false,

        [Parameter(Mandatory=$false)]
        [switch] $ForceBootstrap = $false,

        [Parameter(Mandatory=$false)]
        [switch] $SetDefault
    )

    begin {
        function Test-DistroSha {
            $fileHash = Get-FileHash -Path $DownloadPath -Algorithm SHA256
            $sha = $fileHash.Hash
            if (-not ($sha -eq $DistroSha)) {
                Write-Warning -Message "Distro SHA mismatch.`nExpected: $DistroSha`nGot: $sha`n"
                return $false
            }
            return $true
        }
        function Test-UbuntuArchive {
            if (Test-Path -Path $DownloadPath) {
                Write-Host -Object "Archive found at: $DownloadPath`n" -ForegroundColor Green
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
            Write-Host -Object "Importing archive to: $InstallPath`n" -ForegroundColor Yellow
            New-Item -Path $InstallPath -Type Directory -Force -ErrorAction SilentlyContinue | Out-Null
            $importFile = Expand-UbuntuArchive -Archive $Archive
            Start-Process -FilePath 'wsl.exe' -ArgumentList "--import $DistroName $InstallPath $importFile" -NoNewWindow -Wait
        }
        function Stop-UbuntuDistro {
            Start-Process -FilePath wsl.exe -ArgumentList "--terminate $DistroName" -NoNewWindow -Wait
        }
        function Get-NetworkCredential() {
            $credential = $LinuxCredential.GetNetworkCredential()
            return $credential
        }
        function Start-DistroBootstrap {
            $cred = Get-NetworkCredential
            Start-Process -FilePath wsl.exe -ArgumentList "--distribution $DistroName", "--user root", "--exec bash ./scripts/install-ansible.sh" -NoNewWindow -Wait
            Start-Process -FilePath wsl.exe -ArgumentList "--distribution $DistroName", "--user root", "--exec ansible-playbook playbook-wsl-bootstrap.yml -e ""linux_username=$($cred.UserName) linux_password=$($cred.Password)""" -NoNewWindow -Wait
            Stop-UbuntuDistro
        }
        function Start-DistroConfig {
            $cred = Get-NetworkCredential
            Start-Process -FilePath wsl.exe -ArgumentList "--distribution $DistroName", "--user $($cred.UserName)", "--exec ansible-galaxy install -r requirements.yml" -NoNewWindow -Wait
            Start-Process -FilePath wsl.exe -ArgumentList "--distribution $DistroName", "--user $($cred.UserName)", "--exec ansible-playbook playbook-wsl-config.yml -e ""linux_username=$($cred.UserName) linux_password=$($cred.Password)""" -NoNewWindow -Wait
            Stop-UbuntuDistro
        }
        function Test-ExistingDistro {
            $distros = wsl.exe --list
            $exists = $DistroName -in $distros
            return $exists
        }
        function New-UbuntuDistro {
            if ((-not $ForceBootstrap) -and (Test-ExistingDistro)) {
                throw "Distro named '$DistroName' already exists! Either use -ExistingDistro or pass -ForceBootstrap to override."
            }
            $archiveName = Split-Path $DownloadPath -Leaf
            $archive = Get-UbuntuArchive | Where-Object -Property Name -EQ $archiveName
            Import-UbuntuDistro -Archive $archive
            Start-DistroBootstrap
        }
        function Set-DefaultDistro {
            Write-Host -Object "Setting distro '$DistroName' as default`n" -ForegroundColor Yellow
            Start-Process -FilePath wsl.exe -ArgumentList "--set-default $DistroName" -NoNewWindow -Wait
        }
    }

    process {
        if (-not $ExistingDistro) {
            New-UbuntuDistro
        }
        Start-DistroConfig
    }

    end {
        if ($SetDefault) {
            Set-DefaultDistro
        }
    }
}
