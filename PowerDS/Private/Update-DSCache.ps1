function Update-DSCache {
    Param (
        [Parameter(Mandatory=$true,Position=0)]
        $CompleterFile,
        
        [Parameter(Mandatory=$true,Position=1)]
        $CacheName,
        
        [Parameter(Mandatory=$true,Position=2)]
        $Cache,

        [Parameter(Mandatory=$false,Position=3)]
        [switch]$AppendCache=$false
    )

    Write-Verbose "Writing to completer file $($CompleterFile)"
    $cache.Name | Where-Object {$_ -ne ""} | Select-Object -Unique | ForEach-Object {if ($_ -like "* *"){'"' + $_ + '"'} else {$_} } | Out-File $CompleterFile -ErrorAction SilentlyContinue
    Write-Verbose "Updating cache"
    if ($AppendCache) {
        $OldCache = @(Get-Variable -Name $CacheName -Scope Script -ErrorAction SilentlyContinue)
        if ($OldCache.Value) {
            Set-Variable -Name $CacheName -Value ($OldCache.Value + $cache | Select-Object -Unique) -Scope Script
        } else {
            Set-Variable -Name $CacheName -Value $cache -Scope Script
        }
    } else {
        Set-Variable -Name $CacheName -Value $cache -Scope Script
    }
}