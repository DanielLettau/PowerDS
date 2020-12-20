function Get-DSZone {
    <#
    .SYNOPSIS
        Returns Zones
    .DESCRIPTION
        Return Zones usually representing rooms
    .EXAMPLE
        Get-DSZone -Name Livingroom
    .EXAMPLE
        Get-DSZone -ID 2
    #>
    [CmdletBinding(DefaultParameterSetName = 'Name')]
    [OutputType('DSZone')]
    Param(
        # Returns a room with a specific name
        [Parameter(ParameterSetName='Name',Mandatory=$False,Position=0)]
        [ArgumentCompleter({Get-Content $DSZonesCompleterFile})]
        [string[]]$Name,
        
        # Retruns only rooms on a given floor (ID)
        [Parameter(ParameterSetName='Floor',Mandatory=$False,Position=0)]
        [int[]]$FloorID,
        
        # Using data from cache instead of getting it via API
        [Parameter(Mandatory=$False,Position=1)]
        [switch]$UseCache,
        
        # Skips the Certificate check when contacting the Digitalstrom Server
        [Parameter(Mandatory=$False,Position=2)]
        [switch]$SkipCertificateCheck
    )

    $RelevantConfig = Merge-DSParameterConfig -Parameters $PSBoundParameters
    if ($RelevantConfig.UseCache -and $script:cache_DSZones.count -gt 0) {
        $script:cache_DSZones
    } else {
        $structure = Invoke-DSRAWRequest -URI '/apartment/getStructure' -SkipCertificateCheck:$RelevantConfig.SkipCertificateCheck
        if ($structure) {
            $cache = New-Object System.Collections.ArrayList($null)
            $structure.apartment.zones | ForEach-Object {
                if ($null -eq $Name -or $_.Name -in $Name -and $null -eq $FloorID -or $_.FloorID -in $floorId) {
                    New-Object DSZone -Property @{Name=$_.Name;ID=$_.id;FloorID=$_.floorId} | Tee-Object -Variable new
                    $cache.Add($new) | Out-Null
                }
            }
            if ($null -eq $Name -and $null -eq $FloorID) {
                Update-DSCache -CompleterFile $global:DSCompleterFileZones -CacheName cache_DSZones -cache $cache
            }
        }
    }
}