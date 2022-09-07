$value = ". $PSScriptRoot\Set-UbuntuConfig.ps1"
$path = $PROFILE.CurrentUserAllHosts

$valueExists = Select-String -Path "$path" -Pattern "$value" -SimpleMatch

if (-not $valueExists) {
    Add-Content -Path "$path" -Value "`n$value"
}