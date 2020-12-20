function Disable-DSUDA {
    <#
    .SYNOPSIS
        Disables a user defined action
    .DESCRIPTION
        Disables one or more user defined actions
    .EXAMPLE
        Disables the doorbell user defined actions
        Get-DSUDA -Name Ring_Doorbell | Disable-DSUDA
    .OUTPUTS
        Custum Object including UDA name and success status
    #>
    Param(
        # A user defined action returned by Get-DSUDA
        [Parameter(Mandatory=$True,Position=1,ValueFromPipeline)]
        [DSUDA[]]$Uda,

        # Skips the Certificate check when contacting the Digitalstrom Server
        [Parameter(Mandatory=$False,Position=2)]
        [switch]$SkipCertificateCheck
    )
    Begin {
        $RelevantConfig = Merge-DSParameterConfig -Parameters $PSBoundParameters
        $AllResults = New-Object -TypeName 'System.Collections.ArrayList'
    }
    Process {
        $Invoke = Invoke-DSRAWRequest -URI "/event/raise?name=system-addon-user-defined-actions-config&parameter=actions%3Ddisable%3Bid%3D%2522$($_.id)%2522&a" -SkipCertificateCheck:$RelevantConfig.SkipCertificateCheck
        $Result = [pscustomobject]@{UDA=$_.Name;Success=$Invoke}
        $AllResults.Add($Result) | Out-Null
    }
    End {
        $AllResults
    }
}