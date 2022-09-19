function Set-ProfileScript {
    $Local:ErrorActionPreference = 'SilentlyContinue'
    $value = ". $PSScriptRoot\Set-UbuntuConfig.ps1"
    $path = $PROFILE.CurrentUserAllHosts

    $valueExists = Select-String -Path "$path" -Pattern "$value" -SimpleMatch -Quiet

    if (-not $valueExists) {
        Add-Content -Path "$path" -Value "`n$value"
    }
}

Set-ProfileScript

# reload the profile for the current session
. "$($PROFILE.CurrentUserAllHosts)"