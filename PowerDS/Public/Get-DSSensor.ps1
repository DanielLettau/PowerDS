function Get-DSSensor {
    <#
    .SYNOPSIS
        Returns Sensor
    .DESCRIPTION
        Returns Sensor Data
    .EXAMPLE
        Get-DSSensor
    .EXAMPLE
        $zone | Get-DSScene -SkipCertificateCheck:$false -Name Dimmed
    #>

    [OutputType('DSSensor')]
    Param(
        # Return only sensors with a certain ID
        [Parameter(Mandatory=$False,Position=1)]
        [int[]]$id,

        # Skips the Certificate check when contacting the Digitalstrom Server
        [Parameter(Mandatory=$False,Position=3)]
        [switch]$SkipCertificateCheck
    )
    Begin{
        $RelevantConfig = Merge-DSParameterConfig -Parameters $PSBoundParameters
    }
    Process{
        Write-Verbose "Using API"
        $Sensors = Invoke-DSRAWRequest -URI "/apartment/getDeviceBinaryInputs" -SkipCertificateCheck:$RelevantConfig.SkipCertificateCheck
        if ($Sensors) {
            $Sensors.devices | ForEach-Object {
                if ($null -eq $id -or $_.dsuid -in $id) {
                    New-Object DSSensor -Property @{id=$_.dsuid;value=$_.binaryInputs.state;Inputtype=$_.binaryInputs.inputType}
                }
            }
        }
    }
    End{}
}