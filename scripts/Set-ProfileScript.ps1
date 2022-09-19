function Set-ProfileScript {
    $Local:ErrorActionPreference = 'SilentlyContinue'
    $value = ". $PSScriptRoot\Set-UbuntuConfig.ps1"
    $file = $PROFILE.CurrentUserAllHosts

    $valueExists = Select-String -Path "$file" -Pattern "$value" -SimpleMatch -Quiet

    if (-not $valueExists) {
        $path = Split-Path -LiteralPath $file
        New-Item -Path $path -ItemType Directory -Force | Out-Null
        Add-Content -Path "$file" -Value "`n$value"
    }
}

Set-ProfileScript

# reload the profile for the current session
. "$($PROFILE.CurrentUserAllHosts)"