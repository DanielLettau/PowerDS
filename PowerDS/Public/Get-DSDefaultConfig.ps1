<#
.SYNOPSIS
    Gets the PowerDS default configuration
.DESCRIPTION
    Gets the PowerDS default configuration of the current user
.EXAMPLE
    Lists all config items
    Get-DSDefaultConfig
#>
function Get-DSDefaultConfig {
    if (test-path $DSDefaultConfigFile) {
        Get-Content $DSDefaultConfigFile | ConvertFrom-Json
    } else {
        Write-Warning "No default config file found"
    }
}