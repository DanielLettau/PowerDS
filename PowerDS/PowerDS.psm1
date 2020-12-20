$WarningMessage = @'

You can set default properties using Set-DSDefaultConfig

'@
Write-Warning $WarningMessage
$Classes = @(Get-ChildItem -Path $PSScriptRoot\Classes\*.ps1 -ErrorAction SilentlyContinue | Sort-Object)
$Public  = @(Get-ChildItem -Path $PSScriptRoot\Public\*.ps1  -ErrorAction SilentlyContinue)
$Private = @(Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue)

#will be used in several functions
$ModuleName = 'PowerDS'
$global:DSConfigDir = Join-Path $env:appdata $ModuleName
$DSDefaultConfigFile = Join-Path $DSConfigDir 'Defaults.json'
$global:DSCompleterFileZones = Join-Path $DSConfigDir 'completer_DSZones'
$global:DSCompleterFileDevices = Join-Path $DSConfigDir 'completer_DSDevices'
$global:DSCompleterFileScenes = Join-Path $DSConfigDir 'completer_DSScenes'
$global:DSCompleterFileUDA = Join-Path $DSConfigDir 'completer_DSUDA'
Write-Verbose "Config directory was set to $:ConfigDir"

foreach ($File in ($Classes + $Private + $Public)) {
    Write-Verbose "Loading $($File.fullname)"
    . $File.fullname
}
Export-ModuleMember -Function $Public.Basename
Export-ModuleMember -Function Invoke-DSRAWRequest