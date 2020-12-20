function Invoke-DSBlink {
    <#
    .SYNOPSIS
        Blinks a device
    .DESCRIPTION
        Lets a device blink
    .EXAMPLE
        Get-DSDevice -Name 'Hue Color Living Room' | Invoke-DSBlink
    #>

    Param(
        # Device object to send a blink command to
        [Parameter(Mandatory=$True,Position=1,ValueFromPipeline)]
        [DSDevice[]]$Device,
        
        # Skips the Certificate check when contacting the Digitalstrom Server
        [Parameter(Mandatory=$False,Position=2)]
        [switch]$SkipCertificateCheck
    )

    Begin{
        $RelevantConfig = Merge-DSParameterConfig -Parameters $PSBoundParameters
    }

    Process{
        $Invoke = Invoke-DSRAWRequest -URI "/device/blink?dsid=$($_.object.id)" -SkipCertificateCheck:$RelevantConfig.SkipCertificateCheck
        [pscustomobject]@{UDA=$_.Name;Success=$Invoke}
    }
 
    End{}
}