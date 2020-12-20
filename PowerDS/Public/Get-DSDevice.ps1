function Get-DSDevice {
    <#
    .SYNOPSIS
        Lists Devices from DSS
    .DESCRIPTION
        Lists all or a subset of Devices from DSS
    .EXAMPLE
        Get-DSDevice -Name 'Hue Color Living Room'
    #>

    [OutputType('DSDevice')]
    Param(
        # Filters the returned Devices by one or more given names
        [Parameter(Mandatory=$False,Position=1)]
        [ArgumentCompleter({Get-Content $DSCompleterFileDevices})]
        [string[]]$Name,
        
        # Filters the returned Devices by a given id
        [Parameter(Mandatory=$False,Position=2)]
        [string[]]$id,
        
        # Using data from cache instead of getting it via API
        [Parameter(Mandatory=$False,Position=3)]
        [switch]$UseCache=$False,
        
        # Skips the Certificate check when contacting the Digitalstrom Server
        [Parameter(Mandatory=$False,Position=4)]
        [switch]$SkipCertificateCheck
    )

    Begin{
        $RelevantConfig = Merge-DSParameterConfig -Parameters $PSBoundParameters
        $cache = New-Object System.Collections.ArrayList($null)
        if ($RelevantConfig.UseCache -and $script:cache_DSDevices.count -gt 0) {
            Write-Verbose "Using cache"
            $CachedDevices = $script:cache_DSDevices
        } else {
            Write-Verbose "Using API"
            $Devices = Invoke-DSRAWRequest -URI '/apartment/getDevices' -SkipCertificateCheck:$RelevantConfig.SkipCertificateCheck
        }
    }

    Process{
        if ($CachedDevices) {
            $CachedDevices | ForEach-Object {
                if (($null -eq $name -and $null -eq $id) -or $_.Name -in $Name -or $_.id -in $id) {
                    $_
                }
            }
        } else {
            $Devices | ForEach-Object {
                if (($null -eq $name -and $null -eq $id) -or $_.Name -in $Name -or $_.dsuid -in $id) {
                    New-Object DSDevice -Property @{Name=$_.Name;id=$_.dsuid;object=$_} | Tee-Object -Variable new
                    $cache.add($new) | Out-Null
                }
            }
        }
    }

    End{
        if ($null -eq $Name -and $null -eq $id -and $null -eq $CachedDevices) {
            Update-DSCache -CompleterFile $global:DSCompleterFileDevices -CacheName cache_DSDevices -cache $cache
        }
    }
}