function Get-DSUDA {
    <#
    .SYNOPSIS
        Returns user defined actions
    .DESCRIPTION
        Returns user defined actions
    .EXAMPLE
        Get-DSUDA -Name "Ring bell"
    #>
    [OutputType('DSUDA')]
    Param(
        #Returns only user defined actions matching the given name(s)
        [Parameter(Mandatory=$False,Position=1)]
        [ArgumentCompleter({Get-Content $global:DSCompleterFileUDA})]
        [string[]]$Name,

        #Returns only user defined actions matching the given ID(s)
        [Parameter(Mandatory=$False,Position=2)]
        [int[]]$Id,

        # Using data from cache instead of getting it via API
        [Parameter(Mandatory=$False,Position=3)]
        [switch]$UseCache,
        
        # Skips the Certificate check when contacting the Digitalstrom Server
        [Parameter(Mandatory=$False,Position=4)]
        [switch]$SkipCertificateCheck
    )
    Begin {
        $RelevantConfig = Merge-DSParameterConfig -Parameters $PSBoundParameters
        $cache = New-Object System.Collections.ArrayList($null)
    }
    Process {
        If ($RelevantConfig.UseCache -and $script:cache_DSUDA.count -gt 0) {
            Write-Verbose "Using cache"
            $script:cache_DSUDA | ForEach-Object {
                if ((($null -eq $name -and $null -eq $id) -or $_.Name -in $Name -or $_.id -in $id) -and $null -ne $_.id) {
                    $_
                }
            }
        } else {
            Write-Verbose "Using API"
            #noch umstellen auf query2
            #$UDA = Invoke-DSRAWRequest -URI '/property/query2?query=/usr/events/*(name,id,disabled)' -SkipCertificateCheck:$RelevantConfig.SkipCertificateCheck
            $UDA = Invoke-DSRAWRequest -URI '/property/query?query=/scripts/system-addon-user-defined-actions/*(name,id,disabled)' -SkipCertificateCheck:$RelevantConfig.SkipCertificateCheck
            $UDA."system-addon-user-defined-actions" | ForEach-Object {
                if ((($null -eq $Name -and $null -eq $id) -or $_.Name -in $Name -or $_.id -in $id) -and $null -ne $_.id) {
                    New-Object DSUDA -Property @{Name=$_.Name;id=$_.id;enabled=!$_.disabled} | Tee-Object -Variable new
                    $cache.Add($new) | Out-Null
                }
            }
    
        }
    }
    End {
        if ($null -eq $Name -and $null -eq $id -and $null -eq $UseCache) {
            Update-DSCache -CompleterFile $global:DSCompleterFileUDA -CacheName cache_DSUDA -cache $cache
        }
    }
}