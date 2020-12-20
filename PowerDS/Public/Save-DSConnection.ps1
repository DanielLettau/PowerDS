function Save-DSConnection {
    <#
    .SYNOPSIS
        Saves DS Connections to file
    .DESCRIPTION
        Saves a Digitalstrom Connection to the PowerDS config directory (always in usersope)
    .EXAMPLE
        Saves a connection from variable $conn
        Save-DSConnection -DSConnection $conn
    .EXAMPLE
        Saves a connection from variable $conn and overwrites an existing connection
        Save-DSConnection -DSConnection $conn -Force
    .EXAMPLE
        Saves a newly created connection
        New-DSConnection -ConnectionName local -DSServerAddress 192.168.1.2 -Port 8080 -Credential $cred | Save-DSconnection
    .OUTPUTS
        Digitalstrom Connections of type DSConnection
    #>
    Param(
        [Parameter(Mandatory=$True,ValueFromPipeline=$True,Position=0)]
        [DSConnection[]]$DSConnection,
        [Parameter(Mandatory=$False,Position=1)]
        [switch]$Force=$False
    )
    Begin {
        if ((Test-Path $DSConfigDir) -eq $false) {
            try {
                Write-Verbose "Creating configuration directory $ConfigDir"
                New-Item -Path $DSConfigDir -ItemType Directory -ErrorAction Stop | Out-Null
            } catch {
                Write-Error "Error creating config directory $DSConfigDir"
            }
        }
    }
    Process {
        foreach ($Connection in $DSConnection) {
            $ConfigFile = Join-Path $DSConfigDir ('conn_' + $Connection.Name + '.json')
            Write-Verbose "Config file was set to $ConfigFile"
   
            Write-Verbose "Writing connection to $configfile"
            if ((test-path $ConfigFile) -eq $true -and $force -eq $False) {
                Write-Error "$Configfile already present. Use -Force to overwrite."
            } else {
                try {                
                    $Connection | ConvertTo-Json | Out-File $ConfigFile
                    Get-Item $ConfigFile
                } catch {
                    Write-Error "Error saving connection $($Connection.Name)"
                }
            }
        }
    }
}