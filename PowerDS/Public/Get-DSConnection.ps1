function Get-DSConnection {
    <#
    .SYNOPSIS
        Retrieves a saved DS Connection
    .DESCRIPTION
        Gets you all the saved Digitalstrom Connections from the PowerDS Config directory (always in usersope)
    .EXAMPLE
        Retrieves all the saved connections
        Get-DSConnection
    .EXAMPLE
        Retrieves only the saved connection named 'local'
        Get-DSConnection -Name local
    .OUTPUTS
        Digitalstrom Connections of type DSConnection
    #>
    Param(
        [Parameter(Mandatory=$False,Position=0)]
        [string]$Name="*"
    )

    $ConfigFile = Join-Path $DSConfigDir ('conn_' + $Name + '.json')
    Write-Verbose "Looking for $ConfigFile"
    
    if ((Test-Path $DSConfigDir) -eq $true) {
        Get-ChildItem $ConfigFile | ForEach-Object {[DSConnection](Get-Content $_ | ConvertFrom-Json)}
    } else {
        Write-Warning "ConfigDir $ConfigDir not found"
    }
}