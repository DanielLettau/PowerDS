function Get-DSScene {
    <#
    .SYNOPSIS
        Returns Scenes
    .DESCRIPTION
        Return lightscenes in a room
    .EXAMPLE
        Get-DSZone -Name Livingroom | Get-DSScene -UseCache
    .EXAMPLE
        $zone | Get-DSScene -SkipCertificateCheck:$false -Name Dimmed
    #>

    [OutputType('DSScene')]
    Param(
        # A zone returned by Get-DSZone
        [Parameter(Mandatory=$True,Position=1,ValueFromPipeline)]
        [DSZone[]]$Zone,
        
        # Filter the zones by name(s)
        [Parameter(Mandatory=$False,Position=2)]
        [ArgumentCompleter({Get-Content $global:DSCompleterFileScenes})]
        [string[]]$Name,
        
        # Return only zones with a certain ID
        [Parameter(Mandatory=$False,Position=3)]
        [int[]]$id,
        
        # A group ID. Usually you are good with the default of 1
        [Parameter(Mandatory=$False,Position=4)]
        [int]$GroupID=1,
        
        # Using data from cache instead of getting it via API
        [Parameter(Mandatory=$False,Position=5)]
        [switch]$UseCache=$False,
        
        # Skips the Certificate check when contacting the Digitalstrom Server
        [Parameter(Mandatory=$False,Position=6)]
        [switch]$SkipCertificateCheck
    )
    Begin{
        $RelevantConfig = Merge-DSParameterConfig -Parameters $PSBoundParameters
        $cache = New-Object System.Collections.ArrayList($null)
    }
    Process{
        $Parent=$_
        If ($RelevantConfig.UseCache -and $script:cache_DSScenes.count -gt 0 -and $script:cache_DSScenes.ParentZone -contains $Parent) {
            Write-Verbose "Using cache"
            $UsingCache = $true
            $script:cache_DSScenes | ForEach-Object {
                if ((($null -eq $name -and $null -eq $id) -or $_.Name -in $Name -or $_.id -in $id) -and $_.Parentzone -eq $Parent) {
                    $_
                }
            }
        } else {
            Write-Verbose "Using API"
            $Scenes = Invoke-DSRAWRequest -URI "/zone/getReachableScenes?id=$($Parent.ID)&groupID=$($GroupID)" -SkipCertificateCheck:$RelevantConfig.SkipCertificateCheck
            if ($Scenes) {
                $scenes.userSceneNames | ForEach-Object {
                    if (($null -eq $name -and $null -eq $id) -or $_.sceneName -in $Name -or $_.sceneNr -in $id) {
                        New-Object DSScene -Property @{Name=$_.sceneName;id=$_.sceneNr;ParentZone=$Parent} | Tee-Object -Variable new
                        $cache.add($new) | Out-Null
                    }
                }
            }
        }
    }
    End{
        if ($null -eq $Name -and $null -eq $id -and $null -eq $UsingCache) {
            Update-DSCache -CompleterFile $global:DSCompleterFileScenes -CacheName cache_DSScenes -cache $cache -AppendCache
        }
    }
}