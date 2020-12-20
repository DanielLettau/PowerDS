function Invoke-DSScene {
    <#
    .SYNOPSIS
        Switches light scenes
    .DESCRIPTION
        Executes a light scene returned by Get-DSScene
    .EXAMPLE
        $zone | Get-DSScene -UseCache -Name 'Dimmed wall light' | Invoke-DSScene -Verbose
    #>
    Param(
        # A light scene returned by Get-DSScene
        [Parameter(Mandatory=$True,Position=1,ValueFromPipeline)]
        [DSScene[]]$Scene,

        # A group ID. Usually you are good with the default of 1
        [Parameter(Mandatory=$False,Position=2)]
        [int]$GroupID=1,

        # Force
        [Parameter(Mandatory=$False,Position=3)]
        [bool]$Force=$false,

        # Skips the Certificate check when contacting the Digitalstrom Server
        [Parameter(Mandatory=$False,Position=4)]
        [switch]$SkipCertificateCheck
    )
    Begin{
        $RelevantConfig = Merge-DSParameterConfig -Parameters $PSBoundParameters
        $AllResults = New-Object -TypeName 'System.Collections.ArrayList'
    }
    Process{
        $Invoke = Invoke-DSRAWRequest -URI "/zone/callScene?id=$($_.ParentZone.id)&groupID=$($GroupID)&sceneNumber=$($_.id)&force=$($force.tostring())" -SkipCertificateCheck:$RelevantConfig.SkipCertificateCheck
        $Result = [pscustomobject]@{Scene=$Scene;Success=$Invoke}
        $AllResults.Add($Result) | Out-Null
    }
    End{
        $AllResults
    }
}